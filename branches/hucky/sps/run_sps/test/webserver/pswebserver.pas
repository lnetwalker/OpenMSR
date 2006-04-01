//{$Id$}

{$H+}{$MODE OBJFPC}
program pswebserver;

{ simple HTTP test server }
{ non-blocking socket I/O }
{ based on pswebserver (c) by Vladimir Sibirov }
{ modified by Hartmut Eilers <hartmut@eilers.net> }
{ currently only runs on Linux }
{ porting to Win32 in progress }
{ running on Win 32  W2K Advanced Server }

{ History: }
{ 15.03.2006 startet with Vladimirs Code }
{ 17.03.2006 running non Block http server on linux }
{ 20.03.2006 startet porting to win32 using winsock }
{ 24.03.2006 WINSOCK code works including read of request }
{ 27.03.2006 WINSOCK code works }



{$ifdef LINUX}
	uses sockets, crt, inetaux, oldlinux;
{$else}
	uses winsock,crt,inetaux;
{$endif}

{$ifdef WIN32}
	type
		TFDSet = Winsock.TFDSet; 
{$endif}
	
const 
	testSize = 92;
	RemoteAddress = '127.0.0.1';
	
var

	// Listening socket
	{$ifdef LINUX }
		sock: longint;
	{$else}
		sock		: TSocket;
		ConnSock	: TSocket;
	{$endif}

	// Maximal queue length
	max_connections: integer;

	// A bool flag
	stop_service: boolean;

	// Server and Client address
	{$ifdef LINUX}
		srv_addr	: TInetSockAddr;
		cli_addr	: TInetSockAddr;
		// Conncected socket i/o
		sin, sout	: text;
	{$else}
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
	{$endif}

	// Buffers
	buff			: String;
	post			: array [1..65535] of string;

	// Counter
	BufCnt,i		: Integer;

	{ the requested URL, the File to serve and the response }
	URL			: String;
	F			: text;
	header,page,line	: AnsiString;
	PageSize,HeaderSize	: LongInt;
	TRespSize		: string;

	// Request size
	reqSize,reqCnt,respSize : word;
	
begin
	writeln('PSWebserver starting server...');
	{ Initialization}
	BufCnt:=1;
	reqCnt:=0;
	stop_service := false;
	max_connections := 5;
	{$ifdef LINUX}
		srv_addr.family := AF_INET;
		srv_addr.port := htons(10080);	 
		srv_addr.addr := StrToAddr(RemoteAddress);
	{$else}
		srv_addr.sin_family := AF_INET;
		srv_addr.sin_port := htons(10080);
		srv_addr.sin_addr.S_addr := StrToAddr(RemoteAddress);
        	{ Inititialize WINSOCK }
		if WSAStartup($101, GInitData) <> 0 then writeln ('Error init Winsock');
	{$endif}
	
	{ Create socket }
	sock := socket(PF_INET, SOCK_STREAM, 0);

	{ set socket to non blocking mode }
	{$ifdef LINUX}
		fcntl(sock,F_SetFd,Open_NonBlock);
	{$else}
		NON_BLOCK:=1;
		Result:=ioctlsocket(sock,FIONBIO,@NON_BLOCK);
		if ( Result=SOCKET_ERROR ) then writeln('setting NON_BLOCK failed :(');
	{$endif}
	
	// Binding the server
	writeln('Binding port..');
	{$ifdef LINUX}
		if not bind(sock, srv_addr, sizeof(srv_addr)) then writeln('!! Error in bind().');
	{$else}
		if (bind(sock, srv_addr, SizeOf(srv_addr)) <> 0) then writeln('!! Error in bind');
	{$endif}
	
	// Listening on port
	writeln('listen..');
	{$ifdef LINUX}
		listen(sock, max_connections);
	{$else}
		if (listen(sock, max_connections) = SOCKET_ERROR) then writeln('listen() failed with error ', WSAGetLastError());
	{$endif}
	// Main loop accepting client connections
	repeat

		// Opening socket descriptors
		{$ifdef LINUX}
			Sock2Text(sock,sin,sout);
			reset(sin);
			rewrite(sout);
		{$else}
		
		{$endif}

		writeln('doing select on socket');
		{$ifdef LINUX}
			repeat
			until (SelectText(sin,10000)>0); { busy loop, that's grappy test code }
		{$else}
			repeat
				fd_zero(FDRead);
				fd_set(sock,FDRead);
				{ a timeout must be set with timeout=nil it blocks }
				TimeVal.tv_sec:=0;
				TimeVal.tv_usec:=0;
				Result:=Select(0, @FDRead, nil, nil, @TimeVal);
				if Result = SOCKET_ERROR then writeln('ERROR=',WSAGetLastError);
			until Result > 0 ;
		{$endif}

		writeln('reading request....');
		// Reading whole request

		writeln('accept connection');
		{$ifdef LINUX}
			if not accept(sock, cli_addr, sin, sout) then writeln('!! Connection error in accept().');
		{$else}
			addr_len:=SizeOf(cli_addr);
			ConnSock:=accept(sock, @cli_addr,@addr_len);
			if ( ConnSock=INVALID_SOCKET) then
				writeln('accept failed');
		{$endif}

		reqSize:=0;
		writeln('reading request data');
		repeat
			{$ifdef LINUX}
				readln(sin, buff);
				writeln ('Req[',BufCnt,']=',buff);
				post[BufCnt] := buff;
				reqSize:=reqSize+length(post[BufCnt]);
				inc(BufCnt);
			{$else}
				RecBufSize:=recv(ConnSock,@FCharBuf[1],SizeOf(FCharBuf),0);
				if (RecBufSize=SOCKET_ERROR) then writeln ('socket error during read ',WSAGetLastError);
				buff:=copy(FCharBuf,1,RecBufSize);
				BufCnt:=1;
				{ Request zerlegen und in array post zeile f�r Zeile speichern }
				repeat
					post[BufCnt]:=copy(buff,1,pos(chr(10),buff)-1);
					writeln('Req[',BufCnt,']=',post[BufCnt]);
					buff:=copy(buff,pos(chr(10),buff)+1,length(buff));
					inc(BufCnt);
				until length(buff)<1;
				reqSize:=RecBufSize;
			{$endif}	
		until length(buff)<1;

		inc(reqCnt);
		writeln('# of Requests : ',reqCnt);
		writeln('requestSize: ',reqSize);
		respSize:=reqSize+testSize;
		writeln('response Size: ',respSize);

		{ post[1] is the request, extract the wanted URL }
		{ at position 5 in the string the URL starts and longs until next space }
		{ e.g. "GET /path/to/a/non/existing/file.htm HTTP/1.1" }
		URL:=copy(post[1],5,length(post[1]));
		URL:=copy(URL,1,pos(' ',URL)-1);
		URL:='.'+URL;
		writeln('requested URL=',URL);

		{ now open the file, read and serve it }
		{$i-}
		assign(F,URL);
		reset (F);
		{$i+}
		if (IoResult=0) then
			{ read the file }
			while not eof(F) do begin
				readln(F,line);
				writeln('page: ',line);
				page:=page+line;
			end
		else page:='not found';
		PageSize:=length(page);

		{ generate the header }
		header:='HTTP/1.0 200 OK'+chr(10);
		header:=header+'Connection: close'+chr(10);
		header:=header+'MIME-Version: 1.0'+chr(10);
		header:=header+'Server: PSW/alpha'+chr(10);
		header:=header+'Content-Type: text/html'+chr(10);
		header:=header+'Content-length: ';
		HeaderSize:=length(header);
		str(PageSize+HeaderSize,TRespSize);
		header:=header+TRespSize;
		header:=header+chr(10);
		writeln('DocSize: ',HeaderSize+PageSize);

		// Sending responce
		delay(10);
		writeln('serving data...');
		{$ifdef LINUX}
			writeln('BufCnt=',BufCnt);
			writeln(sout,header+page);
			writeln(sout);

			// Flushing output
			flush(sout);

			// Closing connected socket
			close(sin);
			close(sout);
		{$else}
			{ note chr(10) is newline }
			{ build the string that should be send }
			sendString:=header+page;
			{ copy string to send into the send buffer }
			for i:=1 to length(sendString) do FCharBuf[i]:=sendString[i];
			writeln('respSize: ',length(sendString));
			Result:=send(ConnSock,@FCharBuf[1],length(sendString),0);
			if ( Result=SOCKET_ERROR ) then writeln('send Data failed :(');
			Shutdown(ConnSock, 2);
		{$endif}
		write('.');	
		writeln('finished request..., connection closed');
		BufCnt:=1;
	until stop_service;

	// Closing listening socket
	shutdown(sock, 2);
	// Shutting down
 end.
