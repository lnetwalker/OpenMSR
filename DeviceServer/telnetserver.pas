unit telnetserver;

{ this unit implements a telnet compatible server 	}
{ the interpreter who works on the telnet session 	}
{ must be supplied by the calling program		}

{ (c) copyright by Hartmut Eilers 2008, released 	}
{ under the GNU GPL V2 or later see http://www.gnu.org	}

{ Based on Sebastian Koppehel's example at		}
{ http://www.bastisoft.de/pascal/pasinet.html		}
{ with modifications  by Richard Pasco			}
{ http://www.richpasco.org/mailform.html		}

{ $Id$ }

{ 18.03.2008	Project start				}

{$ifdef MacOSX}
	{$define Linux}
{$endif}


{$ifdef CPU64}
	{$define Linux64}
{$endif}

interface

Procedure TelnetSetupInterpreter(proc : tprocedure);
procedure TelnetInit(LPort: Word;logfile:String);
procedure TelnetServeRequest(WelcomeMSG : String);
Procedure TelnetWriteAnswer(Line : String);
function  TelnetGetData:String;
procedure TelnetShutDown;
function  TelnetDebug(debugging:boolean):boolean;

implementation

uses crt,sockets,CommonHelper,
{$ifdef Linux}
	BaseUnix,Unix,
{$endif}
{$ifdef Windows}
	Windows,Winsock,
{$endif}
	inetaux;

const
	MaxConn 		= 1;
	Size_InetSockAddr	: longint = sizeof(TInetSockAddr);

var
	lSock, uSock 	: LongInt;
	sAddr 				: TInetSockAddr;
	Line 					: String;
	sin, sout 		: Text;
	LOG						: Text;
	InterpreterProc	: tprocedure;
	ListenPort 		: Word ;
	ShutDownProc	: Boolean;
	// LOG-Files
	DBG,ERR,ACC		: text;
	saveaccess		: Boolean;
	debug					: Boolean;

{$ifdef Windows}
	FDRead			: TFDSet;
	sock				: TSocket;
	Result			: integer;
	TimeVal 		: TTimeVal;
	addr_len	 	: u_int;
	cli_addr		: TSockAddr;
	ConnSock		: TSocket;
	RecBufSize	: integer;
	FCharBuf		: array [1..32768] of char;
{$endif}


function  TelnetDebug(debugging:boolean):boolean;
begin
	debug:=debugging;
	TelnetDebug:=true;
end;


function IntToStr(value:LongInt):String;
var dummy : string;

begin
	str(value,dummy);
	IntToStr:=dummy;
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


procedure Error(level: word; msg: string; number: word);
var
	NumStr,LevelStr		: String;
begin
	str(number,NumStr);
	str(level,LevelStr);
	if debug then debugLOG('telnetsrv',2,'Error occured: Level='+LevelStr+' Number='+NumStr+' Msg='+msg);
	Writeln(msg,number);
	halt(level);
end;


Procedure TelnetSetupInterpreter(proc : tprocedure);
begin
	if proc <> nil then InterpreterProc:=proc;
	if debug then
		debugLOG('telnetsrv',2,'registered Telnet Interpreter');
end;


procedure TelnetInit(LPort: Word;logfile:String);
begin
	ShutDownProc:=false;
	// open logfile
	assign(LOG,logfile);
	rewrite(LOG);

	lSock := fpSocket(af_inet, sock_stream, 0);
	if lSock = -1 then Error(1,'Socket error: ',socketerror);

	if LPort=0 then LPort:=ListenPort;

	with sAddr do begin
		sin_family := af_inet;
		sin_port := htons(LPort);
		sin_addr.s_addr := 0;
	end;

	if fpBind(lSock, @sAddr, sizeof(sAddr))<>0 then Error(1,'Bind error: ',socketerror);
	if fpListen(lSock, MaxConn)<>0 then Error(1,'Listen error: ',socketerror);

end;


procedure TelnetServeRequest(WelcomeMSG : String);


begin
	if debug then
		debugLOG('telnetsrv',2,'Waiting for connections...');
	uSock := fpAccept(lSock, @sAddr, @Size_InetSockAddr);

	if uSock = -1 then Error(1,'Telnet Accept error: ',socketerror);
	// set NonBlocking IO
	{$ifdef LINUX}
		FpFcntl(usock,F_SetFd,MSG_DONTWAIT);
	{$endif}

{$ifndef CPU64}
	if debug then
		debugLOG('telnetsrv',2,'Accepted connection from ' + AddrToStr(sAddr.sin_addr.s_addr));
{$endif}

	Sock2Text(uSock, sin, sout);

	Reset(sin);
	Rewrite(sout);
	Write(sout, WelcomeMSG);
	repeat
	{$ifdef Linux}
		if SelectText(sin,10000)>0 then begin
			Readln(sin, Line);
			if debug then
				debugLOG('telnetsrv',2,'Heard: '+line);
			if Line = 'close' then break;
			if InterpreterProc <> nil then InterpreterProc;
		end;
	{$endif}
	{$ifdef Windows}
		fd_zero(FDRead);
		fd_set(sock,FDRead);
		{ a timeout must be set with timeout=nil it blocks }
		TimeVal.tv_sec:=0;
		TimeVal.tv_usec:=0;
		Result:=Select(0, @FDRead, nil, nil, @TimeVal);
		if Result = SOCKET_ERROR then errorLOG('ERROR='+IntToStr(WSAGetLastError));
		if (Result > 0) then begin
			addr_len:=SizeOf(cli_addr);
			ConnSock:=accept(sock, @cli_addr,@addr_len);
			if ( ConnSock=INVALID_SOCKET) then
				errorLOG('accept failed');
//			process_request;
			RecBufSize:=recv(ConnSock,@FCharBuf[1],SizeOf(FCharBuf),0);
			if (RecBufSize=SOCKET_ERROR) then errorLOG('socket error during read '+IntToSTr(WSAGetLastError));
			Line:=copy(FCharBuf,1,RecBufSize);
		end;

	{$endif}
		if ShutDownProc then break;
	until false;

	Close(sin);
	Close(sout);
	fpShutdown(uSock, 2);
	if debug then
		debugLOG('telnetsrv',2,'Connection closed.');
end;


Procedure TelnetWriteAnswer(Line : String);
begin
	Write(sout, Line);
end;


function TelnetGetData:String;
begin
	TelnetGetData:=Line;
end;


procedure TelnetShutDown;
begin
	ShutDownProc:=true;
	delay(500);
	fpShutdown(lsock,2);
	fpShutdown(usock,2);
end;


begin
	debug:=false;
	InterpreterProc:=nil;
	ListenPort:= 45054; //$AFFE;			// decimal 45054

	// don''t write access log
	saveaccess:=false;

	// open logfiles
	//error Log
	{$ifdef WIN32}
	assign(ERR,'\temp\DevSrv_TelnetErr.log');
	{$endif}
	{$ifdef Linux}
	assign(ERR,'/tmp/deviceserver_TelnetErr.log');
	{$endif}
	{$I-}rewrite(ERR);{$I+}
	if ioresult <> 0 then
	begin
		writeln ('Could not open ERROR logfile');
		halt(1);
	end;
end.
