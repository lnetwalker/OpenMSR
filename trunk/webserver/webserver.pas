//{$Id$}

{$MODE OBJFPC}{$H+}
unit webserver;

{ (c) 2006 by Hartmut Eilers < hartmut@eilers.net				}
{ distributed  under the terms of the GNU GPL V 2				}
{ see http://www.gnu.org/licenses/gpl.html for details				}
{ derived from the original work of pswebserver (c) by 				}
{ Vladimir Sibirov								}

{ simple embeddable HTTP server for FPC Pascal for Linux and			}
{ Windows, using non-blocking socket I/O to easy fit and			}
{ integrate in different programs 						}
{ tested on Win 32  W2K Advanced Server and Debian Linux 			}
{ can serve static HTML Pages and Images and special dynamic			}
{ content provided by the embedding program					}
{ see example program pwserver.pas for information about usage			}

{ History: 									}
{ 15.03.2006 startet with Vladimirs Code 					}
{ 17.03.2006 running non Block http server on linux 				}
{ 20.03.2006 startet porting to win32 using winsock 				}
{ 24.03.2006 WINSOCK code works including read of request 			}
{ 27.03.2006 WINSOCK code works 						}
{ 02.04.2006 serving of simple text pages work 					}
{ 03.04.2006 cleaned code, tested with firefox and konqueror -> ok 		}
{   	     wget doesn't receive anything :( 					}
{ 17.10.2006 started the unit webserver from pswebserver code			}
{		     currently only GET requests are supported			}
{ 12.11.2006 added registration of special URLs through callback		}
{ 18.11.2006 added sending of variable data to the embedding process		}

interface

{$ifdef LINUX}
	{$define Unix}
{$endif}
{$ifdef MacOSX}
	{$define Unix}
{$endif}
	

procedure start_server(address:string;port:word;BlockMode: Boolean;doc_root,logfile:string);
procedure SetupSpecialURL(URL:string;proc : tprocedure);
procedure SetupVariableHandler(proc: tprocedure);
procedure SendPage(myPage : AnsiString);
procedure serve_request;
function GetURL:string;
function GetParams:string;
procedure stop_server();


implementation

uses 
{$ifdef Unix}
	BaseUnix, Unix,dos,
{$endif}
{$ifdef Windows}
	windows,
{$endif}
	CommonHelper,crt,inetaux,sockets;



{$ifdef WIN32}
	type
		TFDSet = Winsock.TFDSet; 
{$endif}
	
const 
	LocalAddress = '127.0.0.1';
	debug = true;
	MaxUrl = 25;
	
var

	// Listening socket
	{$ifdef Unix}
		sock,csock	: longint;
	{$else}
		sock		: TSocket;
		ConnSock	: TSocket;
	{$endif}

	// Maximal queue length
	max_connections	: integer;

	binData			: byte;

	// Server and Client address
	{$ifdef Unix}
		srv_addr	: TInetSockAddr;
		cli_addr	: psockaddr;
		// Conncected socket i/o
		sin, sout,			// Descriptors for listening port
		ccsin,ccsout	: text;		// Descriptors for client communication dynamic ports
		Addr_len	: LongInt;
	{$endif}
	{$ifdef Win32}
		srv_addr	: TSockAddr;
		cli_addr	: TSockAddr;	
		GInitData	: TWSADATA;
		addr_len 	: u_int;
		NON_BLOCK	: LongInt;
		FDRead		: TFDSet;
		Result		: integer;
		TimeVal 	: TTimeVal;
		FCharBuf	: array [1..32768] of char;
		RecBufSize	: integer;
		sendString	: AnsiString;
		BytesToSend	: word;
	{$endif}

	// Buffers
	buff			: String;
	post			: array [1..65535] of string;

	// Counter
	BufCnt			: Integer;

	// DOCUMENT ROOT
	DocRoot			: string;

	{ the requested URL, the File to serve and the send data}
	params,URL		: string;
	SpecialURL		: array[1..MaxUrl] of String;
	UrlPointer		: byte;

	G			: file of byte;

	header,page,
	CType			: AnsiString;

	PageSize		: LongInt;

	TRespSize,
	status			: string;

	// Request size
	reqSize,reqCnt		: word;

	// LOG-Files
	DBG,ERR,ACC		: text;

	ServingRoutine		: array[1..MaxUrl] of tprocedure;
	VariableHandler		: tprocedure;

	// this variable is just used to convert numerics to string
	blubber			: string;

	saveaccess		: Boolean;
	
	
procedure writeLOG(MSG: string);
begin
	writeln(DBG,MSG);
	flush(DBG);
end;


procedure errorLOG(MSG: string);
begin
	writeln(ERR,MSG);
	flush(ERR);
end;


procedure accessLOG(MSG: string);
begin
	if saveaccess then begin
	    writeln(ACC,MSG);
	    flush(ACC);
	end;
end;


procedure SetupSpecialURL(URL:string;proc : tprocedure);
begin
	if proc <> nil then ServingRoutine[UrlPointer]:=proc;
	if URL <> '' then SpecialURL[UrlPointer]:=URL;
	inc(UrlPointer);
	if debug then writeLOG('registered special URL'+URL);
end;
	

procedure SetupVariableHandler(proc : tprocedure);
begin
	if proc <> nil then VariableHandler:=proc;
	if debug then writeLOG('registered Variable Handler');
end;


procedure start_server(address:string;port:word;BlockMode: Boolean;doc_root,logfile:string);

begin
	if logfile<>'' then begin
	    // open logfile
	    assign(ACC,logfile);
	    rewrite(ACC);
	    saveaccess:=true;
	end;
	
	{ Initialization}
	if debug then writeLOG('PWS Pascal Web Server - starting server...');
	if (port=0) then port:=10080;
	//if (address='') then address:=LocalAddress;
	str(port,blubber);
	if debug then writeLOG('using port='+blubber+' address='+address);
	DocRoot:=doc_root;
	BufCnt:=1;
	reqCnt:=0;
	max_connections := 5;
	{$ifdef Unix}
		srv_addr.family := AF_INET;
		srv_addr.port := htons(port);
		if (address='') then srv_addr.addr :=0 
		else srv_addr.addr := StrToAddr(address);
	{$else}
		srv_addr.sin_family := AF_INET;
		srv_addr.sin_port := htons(port);
		// BUG ?!?
		if (address='') then srv_addr.sin_addr.S_addr :=0 
		else srv_addr.sin_addr.S_addr := StrToAddr(Address);
		{ Inititialize WINSOCK }
		if WSAStartup($101, GInitData) <> 0 then errorLOG('Error init Winsock');
	{$endif}
	
	{ Create socket }
	sock := fpsocket(PF_INET, SOCK_STREAM, 0);

	if not(BlockMode) then begin
		{ set socket to non blocking mode }
		{$ifdef Unix}
			FpFcntl(sock,F_SetFd,MSG_DONTWAIT);
		{$endif}
		{$ifdef Windows}
			NON_BLOCK:=1;
			Result:=ioctlsocket(sock,FIONBIO,@NON_BLOCK);
			if ( Result=SOCKET_ERROR ) then errorLOG('setting NON_BLOCK failed :(');
		{$endif}
	end;

	// Binding the server
	if debug then writeLOG('Binding port..');
	{$ifdef Unix}
		if fpbind(sock, @srv_addr, sizeof(srv_addr))<> 0 then begin
			errorLOG('!! Error in bind().');
			halt;
		end;
	{$else}
		if (bind(sock, srv_addr, SizeOf(srv_addr)) <> 0) then  begin
			errorLOG('!! Error in bind');
			halt;
		end;
	{$endif}
	
	// Listening on port
	if debug then writeLOG('listen..');
	{$ifdef Unix}
	fplisten(sock, max_connections);
	{$else}
	if (listen(sock, max_connections) = SOCKET_ERROR) then errorLOG('listen() failed with error '+ IntToSTr(WSAGetLastError()));
	{$endif}
end;


procedure SendPage(myPage : AnsiString);
var
	i 		: byte;

begin
	PageSize:=length(myPage);
	if status='' then status:='200 ok';

	{ generate the header }
	header:='HTTP/1.1 '+status+chr(10);
	header:=header+'Connection: close'+chr(10);
	header:=header+'MIME-Version: 1.0'+chr(10);
	header:=header+'Server: bonita'+chr(10);
	{ currently the mimetype of an object is always text/html }
	header:=header+CType;
	header:=header+'Content-length: ';
	{ the Content-length is the size of the served object }
	{ without the size of the header } 
	str(PageSize,TRespSize);
	header:=header+TRespSize;
	header:=header+chr(10);
	str(PageSize,blubber);
	if debug then begin
		writeLOG('DocSize: '+blubber);
		writeLOG('Header: '+header);
		writeLOG('/Header');

		// Sending response
		writeLOG('serving data...');
	end;
	{$ifdef Unix}
		str(BufCnt,blubber);
		if debug then writeLOG('BufCnt='+blubber);
		{ if I send the header and the page together }
		{ firefox has a problem and displays nothing }
		i:=0;
		repeat
			inc(i);
		until (copy(post[i],1,10)='User-Agent');
		if debug then writeLOG('User-Agent='+copy(post[i],13,7));
		if (copy(post[i],13,7)='Mozilla') then begin
			if debug then writeLOG('Mozilla -> sending header,page');
			writeln(ccsout,header);
			writeln(ccsout,myPage);
		end
		else begin
			if debug then writeLOG('other -> sending header+page');
			writeln(ccsout,header+myPage);
		end;
		//writeln(ccsout);

		// Flushing output
		//flush(ccsout);

	{$else}
		{ note chr(10) is newline }
		{ build the string that should be send }
		sendString:=header + chr(10) + chr(10) + myPage;
		BytesToSend:=length(sendString);
		if debug then begin 
			writeLOG('respSize: '+IntToSTr(BytesToSend));
			writeLOG('Page=' + sendString);
		end;
		//Result:=send(ConnSock,@header,sizeof(header),0);
		//Result:=send(ConnSock,@myPage,sizeof(myPage),0);
		Result:=send(ConnSock,@sendString,BytesToSend,0);
		if debug then errorLOG(IntToSTr(Result) + ' Bytes send');
		if ( Result=SOCKET_ERROR ) then errorLOG('send Data failed :(');
		Shutdown(ConnSock, 2);
	{$endif}
	if debug then writeLOG('finished request..., connection closed');
	BufCnt:=1;
end;


procedure process_request;
var Paramstart,i	: word;
    UserAgent		: string;
    jahr,mon,tag,wota 	: word;
    std,min,sec,ms	: word;
    TimeString		: string;
{$ifdef Windows}
    st 			: systemtime;
    n			: word;
{$endif}

begin
	reqSize:=0;
	if debug then writeLOG('reading request data');
	repeat
		{ actually we should switch to blocking mode here, }
		{ because it is possible that some amount of time  }
		{ is between the connect and the request           }
		{$ifdef Unix}
			readln(ccsin, buff);
			str(BufCnt,blubber);
			if debug then writeLOG('Req['+blubber+']='+buff);
			post[BufCnt] := buff;
			if copy(buff,1,11)='User-Agent:' then UserAgent:=copy(buff,12,length(buff));
			reqSize:=reqSize+length(post[BufCnt]);
			inc(BufCnt);
		{$else}
			RecBufSize:=recv(ConnSock,@FCharBuf[1],SizeOf(FCharBuf),0);
			if (RecBufSize=SOCKET_ERROR) then errorLOG('socket error during read '+IntToSTr(WSAGetLastError));
			buff:=copy(FCharBuf,1,RecBufSize);
			BufCnt:=1;
			{ Request zerlegen und in array post zeile fuer Zeile speichern }
			repeat
				post[BufCnt]:=copy(buff,1,pos(chr(10),buff)-1);
				if debug then writeLOG('Req['+IntToStr(BufCnt)+']='+post[BufCnt]);
				buff:=copy(buff,pos(chr(10),buff)+1,length(buff));
				inc(BufCnt);
			until length(buff)<1;
			reqSize:=RecBufSize;
		{$endif}	
	until length(buff)<1;

	inc(reqCnt);
	str(reqCnt,blubber);
	if debug then writeLOG('# of Requests : '+blubber);
	str(reqSize,blubber);
	if debug then writeLOG('requestSize: '+blubber);

	{ processing the request }

	{ post[1] is the request URI, extract the wanted URL }
	{ after first slash (/) in the string the URL starts and longs until next blank }
	{ e.g. "GET /path/to/a/non/existing/file.htm HTTP/1.1" }
	{ request type is ignored it's always GET assumed }
	URL:=copy(post[1],pos('/',post[1]),length(post[1]));
	URL:=copy(URL,1,pos(' ',URL)-1);
	Paramstart:=pos('?',URL);

	if ( Paramstart <> 0 ) then begin
		// this URL has parameters
		params:=copy(URL,Paramstart,length(URL));
		URL:=copy(URL,1,Paramstart-1);
		if VariableHandler<>nil then VariableHandler;
	end;

	// set Content Type
	if (pos('jpg',URL)<>0) then
		CType:='Content-Type: image/jpeg'+chr(10)
	else
		CType:='Content-Type: text/html'+chr(10);

	i:=0;
	repeat
		inc(i);
		if (URL=SpecialURL[i]) then begin
			status:='200 OK';
			str(i,blubber);
			if debug then writeLOG('special URL['+blubber+'] detected: '+URL);
			if ServingRoutine[i] <> nil then ServingRoutine[i];
		end;
	until (i=MaxUrl) or (URL=SpecialURL[i]);
	if not(URL=SpecialURL[i]) then begin
		URL:=DocRoot+URL;			// add current dir as Document root
		if debug then writeLOG('requested URL='+URL);

		{ now open the file, read and serve it }
		{$ifdef Windows}
		for n:=1 to length(URL) do if (URL[n]='/') then URL[n]:='\';
		{$endif}
		{$i-}
		assign(G,URL);
		reset (G);
		{$i+}
		page:='';
		if (IoResult=0) then begin { the file exists }
			status:='200 OK';
			while not eof(G) do begin  { read the file }
				read(G,BinData);
				page:=page+chr(BinData);
			end;
		end
		else begin  { file not found }
			page:='<html><body>Error: 404 Document not found</body></html>';
			status:='404 Not Found';
			errorLOG('Error 404 doc '+URL+' not found');
		end;

		SendPage(page);
	end;
	{ write access log in common logfile format, that looks like:
		78.34.183.237 - - [16/Jun/2009:15:11:09 +0200] "GET /templates/eilers.net/images/mw_menu_cap_r.png HTTP/1.1" 404 8219 "http://www.eilers.net/templates/eilers.net/css/template.css" "Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.0.10) Gecko/2009042523 Ubuntu/9.04 (jaunty) Firefox/3.0.10"                                                                            
		78.34.183.237 - - [16/Jun/2009:15:11:09 +0200] "GET /templates/eilers.net/images/mw_menu_normal_bg.png HTTP/1.1" 404 8219 "http://www.eilers.net/templates/eilers.net/css/template.css" "Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.0.10) Gecko/2009042523 Ubuntu/9.04 (jaunty) Firefox/3.0.10"                                                                        
		74.6.22.178 - - [16/Jun/2009:15:14:37 +0200] "GET /robots.txt HTTP/1.0" 200 304 "-" "Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)"           
		74.6.22.178 - - [16/Jun/2009:15:14:37 +0200] "GET /vrml/ HTTP/1.0" 404 8219 "-" "Mozilla/5.0 (compatible; Yahoo! Slurp/3.0; http://help.yahoo.com/help/us/ysearch/slurp)"           
		77.180.99.188 - - [16/Jun/2009:15:15:34 +0200] "GET / HTTP/1.0" 200 10503 "-" "check_http/v1944 (nagios-plugins 1.4.11)"
		65.55.106.161 - - [16/Jun/2009:16:01:24 +0200] "GET /vrml/ HTTP/1.1" 404 8219 "-" "msnbot/2.0b (+http://search.msn.com/msnbot.htm)"
		77.180.99.188 - - [16/Jun/2009:16:04:05 +0200] "GET / HTTP/1.0" 200 10503 "-" "check_http/v1944 (nagios-plugins 1.4.11)"
		65.55.51.115 - - [16/Jun/2009:16:07:23 +0200] "GET /robots.txt HTTP/1.1" 200 304 "-" "msnbot/2.0b (+http://search.msn.com/msnbot.htm)"
		
		field description
		host rfc931 username date:time request statuscode bytes referrer applinformation
	}
 {$ifdef Unix} // LINUX
	gettime(std,min,sec,ms); 
	getdate(jahr,mon,tag,wota);
 {$else}        // WINDOWS
	getlocaltime( st );
	std:= st.whour;
	min:= st.wminute;
	sec:= st.wsecond;
	ms:= st.wmilliseconds;
 {$endif} 
	TimeString:='['+IntToStr(tag)+'/'+IntToStr(mon)+'/'+IntToStr(jahr)+':'+IntToStr(std)+':'+IntToStr(min)+':'+IntToStr(sec)+':'+IntToStr(ms)+']';
	accessLog('unknown'+' - - '+TimeString+' GET "'+URL+'" '+copy(status,1,3)+' '+IntToStr(SizeOf(page))+' '+UserAgent);

end;


procedure serve_request;
{ this procedure must be called frequently to serve any outstanding requests }
begin
	// Main loop accepting client connections
	// Opening socket descriptors
	// Reading whole request -> accept on socket, then read requested data

	if debug then writeLOG('accept connection');
	
	{$ifdef LINUX}
	{$else}
	{$endif}



	{$ifdef Unix}
	{$I-}
		if debug then writeLOG('Sock2Text');
		Sock2Text(sock,sin,sout);
		if debug then writeLOG('reset');
		reset(sin);
		//if debug then writeLOG('rewrite');
		//rewrite(sout);
	{$I+}
		if debug then WriteLOG('Reading requests...');
		if (SelectText(sin,10000)>0) then begin
			Addr_len:=SizeOf(cli_addr);
			csock:=fpaccept(sock, cli_addr,@Addr_len);
			Sock2Text(csock,ccsin,ccsout);
			reset(ccsin);
			rewrite(ccsout);
			process_request;
			if debug then WriteLOG('Closing In Stream');
			close(ccsin);
			if debug then WriteLOG('Closing Out Stream');
			close(ccsout);
			if debug then WriteLOG('Closing Client Socket');
			CloseSocket(csock);
		end;
		if debug then WriteLOG('Reading requests...done');

		// Closing connected socket descriptors
		if debug then WriteLOG('trying to close socket descriptors');
		close(sin);
		//close(sout);
		if debug then WriteLOG('closeing socket descriptors done');
	{$endif}
	{$ifdef Windows}
		fd_zero(FDRead);
		fd_set(sock,FDRead);
		{ a timeout must be set with timeout=nil it blocks }
		TimeVal.tv_sec:=0;
		TimeVal.tv_usec:=0;
		Result:=Select(0, @FDRead, nil, nil, @TimeVal);
		if Result = SOCKET_ERROR then errorLOG('ERROR='+IntToStr(WSAGetLastError));
		if debug then WriteLOG('data read');
		if (Result > 0) then begin
			if debug then writeLOG('analyzing data');
			addr_len:=SizeOf(cli_addr);
			ConnSock:=accept(sock, @cli_addr,@addr_len);
			if ( ConnSock=INVALID_SOCKET) then
				errorLOG('accept failed');
			if debug then writeLOG('calling process_request');
			process_request;
		end;
	{$endif}
end;

function GetURL:string;
begin
	GetURL:=URL;
end;


function GetParams:string;
begin
	GetParams:=params;
end;


procedure stop_server;
begin
	// Closing listening socket
	fpshutdown(sock, 2);
	// Shutting down
	if debug then writeLOG('shuting down pwserver...');
end;

begin
	// don''t write access log
	saveaccess:=false;

	// open logfiles
	//error Log
	assign(ERR,'/tmp/deviceserver_err.log');
	rewrite(ERR);

	// debug Log
	if debug then begin
		assign(DBG,'/tmp/deviceserver_dbg.log');
		rewrite(DBG);
	end;

	UrlPointer:=1;
end.
