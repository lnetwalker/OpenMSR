Unit adc12lc_io_access;

{ diese Unit stellt Funktionen zum I/O Access auf			} 
{ die Kolter ADC12LC ISA Card						}
{ zur Verfügung								}

{ If you have improvements please contact me at 			}
{ hartmut@eilers.net							}
{ all code is copyright by Hartmut Eilers and released under		}
{ the GNU GPL see www.gnu.org for license details			}

{ $Id$ }

INTERFACE

{ public functions to init the hardware and read and write ports }

function adc12lc_read_ports(io_port:longint):byte;
function adc12lc_read_analog(io_port:longint):longint;
function adc12lc_write_ports(io_port:longint;byte_value:byte):byte;
function adc12lc_hwinit(initstring:string;DeviceNumber:byte):boolean;


IMPLEMENTATION
uses crt;

const
	configByte = 128;
	
var
	ChannelPort	: Longint;
        BasePort 	: LongInt;
	ControlPort	: LongInt;
	StatusPort	: LongInt;
	Start12Bit	: LongInt;
	Start8Bit	: LongInt;
	ValMSB		: LongInt;
	ValLSB		: LongInt;

function adc12lc_read_ports(io_port:longint):byte;
begin
	adc12lc_read_ports:=0;
end;

function adc12lc_read_analog(io_port:longint):longint;
var
	dummy 		: byte;
	
begin
	{ select the Channel }
	WritePort(ChannelPort,io_port);
	delay(1);
	{ start 12 Bit Wandler }
	ReadPort(Start12Bit,dummy);
	{ wait 'till conversion is finished }
	repeat
	  ReadPort(StatusPort,dummy);
	until ((dummy and 128) != 128 );
	ReadPort(ValMSB,MSB);
	ReadPort(ValLSB,LSB);
	adc12lc_read_analog:=int((MSB*16) + (LSB div 16));
end;

function adc12lc_write_ports(io_port:longint;byte_value:byte):byte;
begin
	adc12lc_write_ports:=0;
end;

function adc12lc_hwinit(initstring:string;DeviceNumber:byte):boolean;

begin
	{ the baseport is given as one string }
	val(initdata,BasePort);
	{ assign the Ports according to BasePort }
	ChannelPort:=BasePort+1;
	StatusPort:=BasePort+2;
	ControlPort:=BasePort+3;
	Start12Bit:=BasePort+4;
	Start8Bit:=BasePort+5;
	ValMSB:=BasePort+6;
	ValLSB:=BasePort+7;
	if ( debug ) then
		writeln('Port : ',ControlPort,' ',configByte);
	{ allow full port access for the I/O addressrange  }
	fpIoPL(3);
	// configure Card
	WritePort(ControlPort,configByte);
	// select first input channel in multiplexer
	WritePort(ChannelPort,0);
end;

begin

end.