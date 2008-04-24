{*******************************************************************************

                        SQL UTILITIES

*******************************************************************************
SQL escaping, unescaping, and any other general SQL utils

Copyright: Artistic license, a copy is included with your download.

*******************************************************************************}

unit sqlutils; {$IFDEF FPC}{$MODE OBJFPC}{$H+} {$IFDEF EXTRA_SECURE} {$R+}{$Q+}{$CHECKPOINTER ON} {$ENDIF}{$ENDIF}

interface
uses
  substrings; // string operations

{------------------------------------------------------------------------------}
{      PUBLIC PROCEDURE/FUNCTION DECLARATIONS                                  }
{------------------------------------------------------------------------------}
function EscapeSQL(const s: string): string;
function UnEscapeSQL(const s: string): string;


implementation

{------------------------------------------------------------------------------}
{      PUBLIC PROCEDURES/FUNCTIONS                                             }
{------------------------------------------------------------------------------}

{ MySQL-style escape }
function EscapeSQL(const s: string): string;
begin
  result:= s;
  if pos('''', result) > 0 then
    result := substrreplace(result, '''', '\''');
  if pos('"', result) > 0 then
    result := substrreplace(result, '"', '\"');
end;

{ Undo escape, MySQL-style }
function UnEscapeSQL(const s: string): string;
begin
  result:= s;
  if pos('\''', result) > 0 then
    result:= substrreplace(result, '\''', '''');
  if pos('\"' , result) > 0 then
    result:= substrreplace(result, '\"', '"');
end;

end.
