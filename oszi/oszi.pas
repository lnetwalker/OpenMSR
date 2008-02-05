program oszi;

{ (c) 2006 by Hartmut Eilers < hartmut@eilers.net					}
{ distributed  under the terms of the GNU GPL V 2					}
{ see http://www.gnu.org/licenses/gpl.html for details				}

{ this program may be used as an osziloscope in connection with 	}
{ a supported A/D IO Card											}

{ $Id$ }

uses qgtk2,PhysMach;

var 
	i,
	xmitte,ymitte,
	timebase,
	Raster,
	maxx,
	maxy,
	PixelPerTimeBase : Integer;

	PauseButton,
	ExitButton,
	TimerValue		: qWidget;

	Timer,
	OldTimer		: word;

	Pause			: boolean;

	Background		: qpic;

	ox,oy			: Array [1..8] of Integer;

	NoOfInputs		: byte;

	Farbe			: Array [1..8] of LongInt = (qRed,qAqua,qBlue,qYellow,qPurple,qWhite,qBrown,qGray);

	YcMax,Yrmax		: LongInt;


procedure oncreate;

begin
	{ black Background }
	qsetClr( qBlack );
	qfillrect( 0, 0, maxx, maxy);
	{ Green Grid }
	qsetClr( qGreen );
	for i:=1 to round(int(maxx/Raster)) do begin
		qline(0,i*Raster,maxx,i*Raster);
		qline(i*Raster,0,i*Raster,maxy);
	end;
	qline(0,ymitte,maxx,ymitte);
	qline(xmitte,0,xmitte,maxy);
	// save the Background
	qgetpic(0,0,PixelPerTimeBase,maxy,Background);

end;



function GetNewValue(value:integer): Integer;
var
	Yc	: real;
	Yc2	: integer;

begin
	{ read a new value and normalize it to this coordinate system }
	PhysMachReadAnalog;
	writeln('analog_in[',value,']=',analog_in[value]);
	// see CoordinateTransformation.txt
	//       Yr + Yrmax
	//yc = -------------- *  Ycmax 
	//         2*Yrmax
	Yc:=((analog_in[value]+Yrmax)/(2*Yrmax))*maxy;
	writeln('Yc[',value,']=',Yc);
	//     (Yc-Ycmax)*-1
	//Yc'=---------------*Yc'max
	//     	Ycmax
	yc:=analog_in[value];
	Yc2:=round((Yc-Yrmax)*-1/(Yrmax)*maxy);
	writeln('Yc2[',value,']=',Yc2);
	GetNewValue:=Yc2;
	//GetNewValue:=round(sin(value)*(maxy/4))+ymitte;
end;


procedure ontimer;
var 	x,y,i		: integer;
begin
	if not(Pause) then begin

		x:=timebase;
		inc(timebase,PixelPerTimeBase);

		// delete the old signal where we currently draW
		qdrawpic(x, 0,Background);
		qsetClr( qGreen );
		// readraw the vertical line if needed
		if ((x mod Raster) = 0 ) then qline(x,0,x,maxy);

		for i:=1 to NoOfInputs do begin
			{ get next value from A/D device }
			{ and draw a line from current coordinates to new ones }
			y:=GetNewValue(i);

			qsetClr(Farbe[i]);
			qline(ox[i],oy[i],x,y);
			ox[i]:=x;
			oy[i]:=y;

			if x >= maxx then begin
				timebase:=0;
				ox[i]:=0;oy[i]:=ymitte;
			end
		end;	
	end;
end;

procedure onClose;
begin
if qdialog('Quit?','Yes', 'No','') =1 then
      qdestroy;
end;

procedure onPause;
begin
	if qToggleGetA(PauseButton) then Pause:=true
	else Pause:=false;
end;

procedure onTimebase;
begin
	val(qinput('Timervalue in ms:', '100'),Timer );
	if Timer > 0 then begin
		if Timer < 2 then Timer:=2;
		if Timer <> OldTimer then begin
			writeln('Timebase changed try to stop timer ',OldTimer,'  ms');
			qtimerstop(OldTimer);
			OldTimer:=Timer;
			writeln ( ' restarting new timer with ',Timer,' ms');
			qtimerstart(Timer, @ontimer);
		end
	end
end;


begin
	NoOfInputs:=2;
	Raster:= 40;
	maxx:=480;
	maxy:=480;
	PixelPerTimeBase:=20;
	Timer:=100;
	Yrmax:=2147483647;


	xmitte:=round(int(maxx/2));
	ymitte:=round(int(maxy/2));
	timebase:=0;

	// initialize Hardware
	PhysMachInit;
	PhysMachloadCfg('.oszi.cfg');
	writeln('detected Hardware: ',HWPlatform);
	
	qstart('Oszi', nil, nil);
	TimerValue:=qbutton('Timebase',  @onTimebase);
	PauseButton:=qbuttonToggle('||', @onPause);
	ExitButton:=qbutton('Exit',@onClose);
	qNextRow;

	qdrawstart(maxx,maxy, @oncreate,nil, nil);
	qtimerstart(Timer, @ontimer);

	qGo;
end.