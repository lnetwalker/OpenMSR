{ An ansistring with capacity, grows in chunks. Much more efficient than
  concatenating ansistrings using s + s + s style, and much easier to use
  than growing the string in chunks yourself with manual setlengths/uniquestring
  It can also be known as a buffered ansistring.

  Could be placed into a class, I couldn't be bothered.

  Released under NRCOL public domain license.

  Lars (L505)
  http://z505.com
}

unit capstr; {$IFDEF fpc} {$MODE objfpc} {$H+} {$ENDIF}

interface

type
  PCapStr = ^TCapstr;
  TCapStr = record
    strlen: integer; // string length stored inside larger buffer area
    growby: integer; // grow the string in chunks
    data: ansistring; // string data
  end;

procedure resetbuf(buf: PCapstr); overload;
procedure resetbuf(buf: PCapstr; growby: integer); overload;
procedure addchar(c: char; buf: PCapstr);
procedure addstr(const s: ansistring; buf: PCapstr);
procedure endupdate(buf: PCapstr);
procedure delete(buf: PCapstr; startat: integer; cnt: integer);

implementation

const
  DEFAULT_CHUNK_SIZE = 1280;

procedure delete(buf: PCapstr; startat: integer; cnt: integer);
begin
  if buf^.strlen < 1 then exit;
  if buf^.data = '' then exit;
  system.delete(buf^.data, startat, cnt);
  buf^.strlen:= buf^.strlen - cnt;
end;

{ call this to reset the data structure to zero and the default growby value }
procedure resetbuf(buf: PCapstr);
begin
  buf^.data:= '';
  buf^.strlen:= 0;
  buf^.growby:= DEFAULT_CHUNK_SIZE;

end;

{ same as above but with custom growby }
procedure resetbuf(buf: PCapstr; growby: integer);
begin
  buf^.data:= '';
  buf^.strlen:= 0;
  if buf^.growby < 1 then
    buf^.growby:= DEFAULT_CHUNK_SIZE
  else
    buf^.growby:= growby;
end;


{ private function, grows the capstring in chunks automatically only when
  absolutely needs to }
procedure grow(buf: PCapstr; addlen: integer);
var
  growmult: integer;
begin
  if addlen <= buf^.growby then // only grow one chunk if there is room for data incoming
    setlength(buf^.data, length(buf^.data) + buf^.growby)
  else
  begin // must grow in more than one chunk since data is too large to fit
    growmult:= (addlen div buf^.growby) + 1;   // div discards the remainder so we must add 1 to make room for that extra remainder
    setlength(buf^.data, length(buf^.data) + growmult);
  end;
end;

{ add single character to capacitance string }
procedure addchar(c: char; buf: PCapstr);
var
  newlen: integer;
const
  clen = 1;
begin
  newlen:= buf^.strlen + clen;
  if newlen > length(buf^.data) then grow(buf, clen);
  buf^.data[newlen]:= c; // concat
  buf^.strlen:= newlen; // string length stored, but not actual buffer length
end;

{ add existing string to capstring }
procedure addstr(const s: string; buf: PCapstr);
var
  newlen: integer;
  slen: integer;
  i: integer;
  oldlen: integer;
begin
  slen:= length(s);
  if slen = 0 then exit; // do nothing
  oldlen:= length(buf^.data);
  newlen:= buf^.strlen + slen;
  if newlen > oldlen then grow(buf, slen);
  //  debugln('debug: wslen: ' + inttostr(wslen) );
{  for i:= 1 to slen do
    buf^.data[(buf^.strlen + i)]:= s[i]; }
  Move(pchar(S)[0], pchar(buf^.data)[buf^.strlen], slen);

  buf^.strlen:= newlen; // string length stored, but not actual buffer length
end;

{ endupdate MUST be called after doing your work with the string, this
  sets the string to the correct length (trims extra buffer spacing at end) }
procedure endupdate(buf: PCapstr);
begin
  if buf^.strlen < 1 then exit;
  if buf^.data = '' then exit;
  setlength(buf^.data, buf^.strlen);
end;

end.
