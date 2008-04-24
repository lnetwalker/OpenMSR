{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                CompactUtils

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  A compact alternative to Sysutils unit, Classes unit, StringLists, and more.

  This CompactUtils unit makes executables that are nice and compact in size,
  yet still powerful (and in some cases more powerful) than if using classes or
  sysutils units.

  No need for bulky Classes or sysutils unit to be linked into your program!

  See also StrWrap1 unit, which has more functions in addition to CompactUtils,
  that you will find useful!
  
  -----------------------------------------------------------------------------
  Note:
  -----------------------------------------------------------------------------
  If you don't like the stringlist in this unit because it appears awkward at
  first glance, remember that's not just what this unit is intended for!

  There are plenty of actual general purpose functions available in this unit,
  which offer the exact same behaviour as in the Sysutils unit - but without the
  disadvantages of the sysutils 60K bloat problem. Many functions in this unit
  and the other units included in this project, were taken directly from the
  FPC sources - no, I didn't spend time reinventing the wheel - I just
  took many of the functions from Sysutils and reorganized them into a unit
  without any initialization or finalization

  This is not a rewritten sysutils from scratch, and that's a good thing! Much
  of this code is exactly the same as the existing FPC code, just that I've
  organized it here to take advantage of smartlinking.

  ----------------------------------------------------------------------------
   Why do classes and sysutils cause so much kilobytes and bulk into our exes?
  ----------------------------------------------------------------------------
    Initialization and finalization. This CompactUtils unit was created with
    no initialization and finalization. Initialization and finalization ruins
    much of the smartlinking process!

    Note: even the dos unit itself has initialization and finalization. Not
          just the sysutils unit. As for BaseUnix, I'll tell you more
          about that in the next release of CompactUtils.

    A lot of the functions in Sysutils and Dos units do not rely on any
    initialization in actual practise - but in your program, they haul
    in the initialization and finalization anyway! They were just put in those
    units for your convenience by the FPC team. Some of the functions in dos
    unit and sysutils unit do require and rely on initialization/finalization in
    those units, but many do not! That's an important point to remember, and
    exactly why this unit was created. This means some of the functions in
    dos/sysutils can be strategically pulled out (copy and paste!) which do not
    rely on finalization/initialization. It's called reorganization..

    As for classes? there are just some tricks used in this CompactUtils
    unit for tiny classes. Without the bulk of the classes unit itself.
    You don't have to use the classes in this unit, they are just here for those
    times when you need a simple stringlist without the bloat. See the demo
    application included, proving to you the huge savings.

  ----------------------------------------------------------------------------
   So this unit does not rely on Classes unit, but has stringlists available?
  ----------------------------------------------------------------------------
    Yes, a stringlist without using classes.  (actually old pascal objects.)

    Don't fear NewStrList versus TStringList.create. Give it a try, it's
    really no different. You still call strlist.free and strlist:=nil just
    like normal.
      
  ----------------------------------------------------------------------------
   There is exe/dll/elf size reduction and speed gains by using CompactUtils?
  ----------------------------------------------------------------------------

    Small-medium utilities and CGI programs or DLL's/DSO's that you want to
    load into the memory fast, will benefit from this CompactUtils unit.
    Think about CGI and servers especially. Trim off some load on the server
    simply by using CompactUtils instead of sysutils!

    However, it's not just for the kilobyte savings. This CompactUtils unit 
    still has powerful functions regardless of the size/compactness benefits. 

  ----------------------------------------------------------------------------
   Is it a drop in replacement?
  ----------------------------------------------------------------------------
    Yes, for many functions.
    
    Rule of thumb: when you are considering using SysUtils in any application
    whatsoever, try CompactSysUtils and CompactStrUtils first (and also 
    CompactUtils). If CompactSysUtils.pas doesn't meet your needs
    then simply replace CompactSysUtils in your uses clause with SysUtils.
    Compact Utils project includes a replacement for sysutils and strutils,
    and in some cases classes. 
    
    The units in this project will be engineered as a drop in units 
    (CompactSysUtils, and CompactStrUtils) so that you can simply replace the 
    SysUtils and StrUtils text in your uses clause and do nothing more.
    Currently it is drop in supported for i386 platforms only. In the future,
    other platforms like i64 will be supported.

--------------------------------------------------------------------------------
 GOALS:
--------------------------------------------------------------------------------

  -compatible with freepascal (and delphi later)
  
  -unit should work on Linux and Windows, and in the future other operating
   systems if anyone wants to help. Currently Linux and Windows are the
   ones being maintained by the current developer.
  
  -no classes unit reliance!

  -no sysutils reliance!
  
  -includes many useful functions and structures that the sysutils and classes
   units contain, but without the bulk/killobytes that the classes and
   sysutils cost you

  -CompactUtils is not just for size reduction and speed gains. It is for
   convenience too. You can use it in small or big applications.


--------------------------------------------------------------------------------
 TODO:
--------------------------------------------------------------------------------


  Streams and threads are left out for now. Do not use any stream or thread
  functions in this unit, as they are just here under construction for now.
  They should be commented out or deleted for now, but please notify
  me if I forgot to comment out or delete a stream or thread function.

 General to do
  
   -Delphi support. Right now only freepascal is being worked on.

   -put more sysutils style functions in here that do not
   i.e. simply pull out strategically, some functions in the sysutils
   and dos units which do not rely on finalization. Cut/copy/paste

 Left out for now, to do later:

   -CompareAnsiStrListItems

   -TStrList.AnsiSort, TStrListEx.AnsiSort

   -lots of stream code

   -TStream.ReadAsync, TStream.SeekAsync, TStream.WriteAsync
   
   -NewThread, NewThreadEx, etc.
   
   -Stringlist load from stream, save to stream.


--------------------------------------------------------------------------------
 CONTRIBUTORS/AUTHORS:
--------------------------------------------------------------------------------

  Lars aka L505
  http://z505.com

  Much of the ideas and source code derived from KOL (Vladimir Kladov)
  and contributors. Portions of this file are from the FPC source code too.
  
  Anyone wishing to contribute to this unit is welcome. I can easily put
  it on SVN. Contact fpcunits(@)z505(.)com


--------------------------------------------------------------------------------
 LICENSE/TERMS:
--------------------------------------------------------------------------------

  This file shall be used under the same license as the KOL project since code
  is derived from the KOL project. See the KOL license (open source, free) for
  more details.

  See also licenses in the StrWrap1 file, plus the freepascal units such as dos,
  windows, baseunix, math.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

}
unit CompactUtils;

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ENDIF}


interface


uses
 {$IFDEF WIN32}
  windows,
 {$ENDIF}

{$IFDEF FPC}
 {$IFDEF UNIX}
  baseunix,
  {$ENDIF}
{$ELSE}
  messages,
{$ENDIF}
  StrWrap1;


const
  INVALID_HANDLE_VALUE = -1 ;  //L505: added constant

const
  { File open modes }
  fmOpenRead       = $0000;
  fmOpenWrite      = $0001;
  fmOpenReadWrite  = $0002;
  { Share modes}
  fmShareCompat    = $0000;
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
  fmShareDenyRead  = $0030;
  fmShareDenyNone  = $0040;


type
   _TObj = object
   protected
     procedure Init; virtual;
   public
     function VmtAddr: Pointer;
   end;

  PObj = ^TObj;

  PList = ^TList;

  TObjectMethod = procedure of object;

  TOnEvent = procedure( Sender: PObj ) of object;


   PPointerList = ^TPointerList;
   TPointerList = array[0..MaxInt div 4 - 1] of Pointer;

   TObj = {-} object( _TObj ) (*class*)

   protected
     fRefCount: Integer;
     fOnDestroy: TOnEvent;
     procedure DoDestroy;
   protected
     fAutoFree: PList;

     fTag: DWORD;
     { Custom data. }
   (*public*)
     destructor Destroy; {-} virtual; {+}{++}(* override; *){--}
   (*protected*)
     (*
     procedure Init; virtual;
     *)
     procedure Final;
   public
     procedure Free;

     // By Vyacheslav Gavrik:
     function InstanceSize: Integer;

     constructor Create;

     class function AncestorOfObject( Obj: Pointer ): Boolean;
     function VmtAddr: Pointer;
     procedure RefInc;
     procedure RefDec;
     property RefCount: Integer read fRefCount;

     property OnDestroy: TOnEvent read fOnDestroy write fOnDestroy;
     { This event is provided for any KOL object, so You can provide your own
       OnDestroy event for it. }
    procedure Add2AutoFree( Obj: PObj );
    procedure Add2AutoFreeEx( Proc: TObjectMethod );
    property Tag: DWORD read fTag write fTag;
   protected
    {$IFDEF USE_NAMES}
     FName: String;
     procedure SetName( const NewName: String );
    {$ENDIF}
   public
    {$IFDEF USE_NAMES}
     property Name: String read FName write SetName;
    {$ENDIF}
   end;


  TList = object( TObj )

  protected
    fItems: PPointerList;
    fCount: Integer;
    fCapacity: Integer;
    fAddBy: Integer;
    procedure SetCount(const Value: Integer);
    procedure SetAddBy(Value: Integer);
  (*public*)
    destructor Destroy; {-}virtual;{+}{++}(*override;*){--}

  (*protected*)
    procedure SetCapacity( Value: Integer );
    function Get( Idx: Integer ): Pointer;
    procedure Put( Idx: Integer; Value: Pointer );
    {$IFDEF USE_CONSTRUCTORS}
    procedure Init; virtual;
    {$ENDIF USE_CONSTRUCTORS}
  public
    procedure Clear;
    procedure Add( Value: Pointer );
    procedure Insert( Idx: Integer; Value: Pointer );
    function IndexOf( Value: Pointer ): Integer;
    procedure Delete( Idx: Integer );
    procedure DeleteRange( Idx, Len: Integer );
    procedure Remove( Value: Pointer );
    property Count: Integer read fCount write SetCount;
    property Capacity: Integer read fCapacity write SetCapacity;
    property Items[ Idx: Integer ]: Pointer read Get write Put; default;
    function Last: Pointer;
    procedure Swap( Idx1, Idx2: Integer );
    procedure MoveItem( OldIdx, NewIdx: Integer );
    procedure Release;
    procedure ReleaseObjects;
    property AddBy: Integer read fAddBy write SetAddBy;
    property DataMemory: PPointerList read fItems;

    procedure Assign( SrcList: PList );

    {$IFDEF _D4orHigher}
    procedure AddItems( const AItems: array of Pointer );
    {$ENDIF}
  end;


function NewList: PList;

{$IFDEF _D4orHigher}
function NewListInit( const AItems: array of Pointer ): PList;
{$ENDIF}


{$IFDEF USE_NAMES}
var
  NamedObjectsList: PList;

function FindObj( const Name: String ): PObj;
{$ENDIF}


//[DummyObjProc, DummyObjProcParam DECLARATION]
procedure DummyObjProc( Sender: PObj );
procedure DummyObjProcParam( Sender: PObj; Param: Pointer );


{ --- threads --- }

const
  ABOVE_NORMAL_PRIORITY_CLASS = $8000; // only for Windows 2K
  BELOW_NORMAL_PRIORITY_CLASS = $4000; // and higher !

type

  TThreadMethod = procedure of object;

type
  PStrList = ^TStrList;


  TStrList = object(TObj)
  protected
    procedure Init; virtual;
  protected
    fList: PList;
    fCount: Integer;
    fCaseSensitiveSort: Boolean;
    fTextBuf: PChar;
    fTextSiz: DWORD;
    function GetPChars(Idx: Integer): PChar;
    //procedure AddTextBuf( Src: PChar; Len: DWORD );
  protected
    function Get(Idx: integer): string;
    function GetTextStr: string;
    procedure Put(Idx: integer; const Value: string);
    procedure SetTextStr(const Value: string);
  (*public*)
    destructor Destroy; virtual;(*override;*)
  protected
    // by Dod:
    procedure SetValue(const AName, Value: string);
    function GetValue(const AName: string): string;
  public
    // by Dod:
    function IndexOfName(AName: string): Integer;
    { by Dod. Returns index of line starting like Name=... }
    property Values[const AName: string]: string read GetValue write SetValue;
    { by Dod. Returns right side of a line starting like Name=... }
  public
    function Add(const S: string): integer;
    procedure AddStrings(Strings: PStrList);
    procedure Assign(Strings: PStrList);
    procedure Clear;
    procedure Delete(Idx: integer);
    function IndexOf(const S: string): integer;
    function IndexOf_NoCase(const S: string): integer;
    function IndexOfStrL_NoCase( Str: PChar; L: Integer ): integer;
    function Find(const S: String; var Index: Integer): Boolean;
    procedure Insert(Idx: integer; const S: string);
    function LoadFromFile(const FileName: string): Boolean;
    procedure Move(CurIndex, NewIndex: integer);
    procedure SetText(const S: string; Append2List: boolean);
    procedure SetUnixText( const S: String; Append2List: Boolean );
    procedure SaveToFile(const FileName: string);
    property Count: integer read fCount;
    property Items[Idx: integer]: string read Get write Put; default;
    property ItemPtrs[ Idx: Integer ]: PChar read GetPChars;
    function Last: String;
    property Text: string read GetTextStr write SetTextStr;
    procedure Swap( Idx1, Idx2 : Integer );
    procedure Sort( CaseSensitive: Boolean );

// L505: TODO
//    procedure AnsiSort( CaseSensitive: Boolean );
//    { Call it to sort ANSI string list. }


    // by Alexander Pravdin:
  protected
    fNameDelim: Char;
    function GetLineName( Idx: Integer ): string;
    procedure SetLineName( Idx: Integer; const NV: string );
    function GetLineValue(Idx: Integer): string;
    procedure SetLineValue(Idx: Integer; const Value: string);
  public
    property LineName[ Idx: Integer ]: string read GetLineName write SetLineName;
    property LineValue[ Idx: Integer ]: string read GetLineValue write SetLineValue;
    property NameDelimiter: Char read fNameDelim write fNameDelim;
    function Join( const sep: String ): String;
    { by Sergey Shishmintzev. }
  end;


var
  DefaultNameDelimiter: Char = '=';
  ThsSeparator: Char = ',';

function NewStrList: PStrList;

type
  PStrListEx = ^TStrListEx;

  TStrListEx = object( TStrList )
  protected
    FObjects: PList;
    function GetObjects(Idx: Integer): DWORD;
    procedure SetObjects(Idx: Integer; const Value: DWORD);
    procedure Init; {-}virtual;(*override;*)
    procedure ProvideObjCapacity( NewCap: Integer );
  public
    destructor Destroy; virtual;(*override;*)

    property Objects[ Idx: Integer ]: DWORD read GetObjects write SetObjects;
    procedure AddStrings(Strings: PStrListEx);
    procedure Assign(Strings: PStrListEx);
    procedure Clear;
    procedure Delete(Idx: integer);
    procedure Move(CurIndex, NewIndex: integer);
    procedure Swap( Idx1, Idx2 : Integer );
    procedure Sort( CaseSensitive: Boolean );


// L505: TODO
//    procedure AnsiSort( CaseSensitive: Boolean );
//    { Call it to sort ANSI string list. }

    function LastObj: DWORD;
    function AddObject( const S: String; Obj: DWORD ): Integer;
    procedure InsertObject( Before: Integer; const S: String; Obj: DWORD );
    function IndexOfObj( Obj: Pointer ): Integer;
  end;


function NewStrListEx: PStrListEx;

function StrComp_NoCase(const Str1, Str2: PChar): Integer;
function StrLComp(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;
function StrLComp_NoCase(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;
function StrLen(const Str: PChar): Cardinal;
function StrScanLen(Str: PChar; Chr: Char; Len: Integer): PChar;

procedure NormalizeUnixText( var S: String );


type
  TCompareEvent = function (const Data: Pointer; const e1,e2 : Dword) : Integer;

  TSwapEvent = procedure (const Data : Pointer; const e1,e2 : Dword);

  procedure SortData( const Data: Pointer; const uNElem: Dword;
                      const CompareFun: TCompareEvent;
                      const SwapProc: TSwapEvent );

  function Parse( var S : String; const Separators : String ) : String;
  function IndexOfCharsMin( const S, Chars : String ) : Integer;
  function IndexOfChar( const S : String; Chr : Char ) : Integer;
//  function AnsiCompareStr(const S1, S2: string): longint;
  function StrComp(const Str1, Str2: PChar): Integer;
  function FileCreate (const FileName: string; Mode: Longint) : Longint;

  function StrScan(Str: PChar; Chr: Char): PChar;
{ Fast search of given character in a string. Pointer to found character
  (or nil) is returned. }

{$ifdef fpc}
  function strmove(dest, source: pchar; l: SizeInt) : pchar;
  function StrPCopy(Dest: PChar; Source: string): PChar;
{$else} //needed for delphi
  function StrPCopy(Dest: PChar; const Source: string): PChar;
  function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar;
{$endif}



{$ifndef _D6orHigher}
type
   TMethod = packed record
    Code: Pointer; // Pointer to method code.
    Data: Pointer; // Pointer to object, owning the method.
   end;
{$endif}


 function Min( X, Y: Integer ): Integer;
 function Max( X, Y: Integer ): Integer;
{$ifndef fpc} // fpc does not need these, already defined in system
 function LowerCase(const S: string): string;
 function UpperCase(const S: string): string;
{$endif}

 function Int2Str( Value : Integer ) : String;
 
 function AnsiCompareStr(const S1, S2: string): longint;

{------------------------------------------------------------------------------}
implementation
{------------------------------------------------------------------------------}



{ _TObj }

//[procedure _TObj.Init]
procedure _TObj.Init;
begin
{$IFDEF _D2orD3}
  FillChar( Pointer( Integer(@Self) + 4 )^, Sizeof( Self ) - 4, 0 );
{$ENDIF}
end;


//[function _TObj.VmtAddr]
function _TObj.VmtAddr: Pointer;
asm
   MOV EAX, [EAX]
end;

{ TObj }

class function TObj.AncestorOfObject(Obj: Pointer): Boolean;
asm
        MOV     ECX, [EAX]
        MOV     EAX, EDX
        JMP     @@loop1
@@loop:
        MOV     EAX,[EAX]
@@loop1:
        TEST    EAX,EAX
        JE      @@exit
        CMP     EAX,ECX
        JNE     @@loop
@@success:
        MOV     AL,1
@@exit:
end;


constructor TObj.Create;
begin
  Init;
  {++}(* inherited; *){--}
end;


procedure TObj.DoDestroy;
begin
  if fRefCount <> 0 then
  begin
    if not LongBool( fRefCount and 1) then
       Dec( fRefCount );
  end
  else
     Destroy;
end;


procedure TObj.RefDec;
begin
  Dec( fRefCount, 2 );
  if (fRefCount < 0) and LongBool(fRefCount and 1) then
    Destroy;
end;

procedure TObj.RefInc;
begin
  Inc( fRefCount, 2 );
end;

function TObj.VmtAddr: Pointer;
asm
       MOV    EAX, [EAX - 4]
end;

function TObj.InstanceSize: Integer;
asm
       MOV    EAX, [EAX]
       MOV    EAX,[EAX-4]
end;
{+}

//[procedure TObj.Free]
{$IFDEF F_P}
procedure TObj.Free;
begin
  if Self <> nil then
    DoDestroy;
end;
{$ELSE DELPHI}

procedure TObj.Free;
begin
  if @Self <> nil then
    DoDestroy;
end;
{$ENDIF F_P/DELPHI}


destructor TObj.Destroy;
begin
  Final;
  {$IFDEF USE_NAMES}
  Name := '';
  {$ENDIF}
  {$IFDEF DEBUG_ENDSESSION}
  if EndSession_Initiated then
    LogFileOutput( GetStartDir + 'es_debug.txt',
                   'FINALLED: ' + Int2Hex( DWORD( @ Self )
                   {$IFDEF USE_NAMES}
                   + ' (name:' + FName + ')'
                   {$ENDIF}
                   , 8 ) );
  {$ENDIF}
  {-}
  Dispose( @Self );
  {+} {++}(*
  inherited; *){--}
end;


(*

procedure TObj.Init;
begin

end;
*)


procedure TObj.Final;
var I: Integer;
    ProcMethod: TMethod;
    Proc: TObjectMethod Absolute ProcMethod;
begin
  if Assigned( fOnDestroy ) then
  begin
    fOnDestroy( @Self );
    fOnDestroy := nil;
  end;
  if fAutoFree <> nil then
  begin
    for I := 0 to fAutoFree.fCount div 2 - 1 do
    begin
      ProcMethod.Code := fAutoFree.fItems[ I * 2 ];
      ProcMethod.Data := fAutoFree.fItems[ I * 2 + 1 ];
      {-}
      Proc;
      {+}{++}(*
      asm
        MOV  EAX, [ProcMethod.Data]
        MOV  ECX, [ProcMethod.Code]
        CALL ECX
      end;
      *){--}
    end;
    fAutoFree.Free;
    fAutoFree := nil;
  end;
end;


procedure TObj.Add2AutoFree(Obj: PObj);
begin
  if fAutoFree = nil then
    fAutoFree := NewList;
  fAutoFree.Insert( 0, Obj );
  fAutoFree.Insert( 0, Pointer( @TObj.Free ) );
end;


procedure TObj.Add2AutoFreeEx( Proc: TObjectMethod );
begin
  if fAutoFree = nil then
    fAutoFree := NewList;
  fAutoFree.Insert( 0, Pointer( TMethod( Proc ).Data ) );
  fAutoFree.Insert( 0, Pointer( TMethod( Proc ).Code ) );
end;

{$IFDEF USE_NAMES}
procedure TObj.SetName(const NewName: String);
begin
  if FName <> '' then
  begin
    NamedObjectsList.Remove( @ Self );
    FName := '';
  end;
  if FindObj( NewName ) <> nil then Exit; // prevent duplications!
  FName := NewName;
  if FName <> '' then
    NamedObjectsList.Add( @ Self );
end;
{$ENDIF}



{ TList }

{$IFDEF USE_CONSTRUCTORS}
function NewList: PList;
begin
  New( Result, Create );
  //Result.fAddBy := 4;
end;

procedure TList.Init;
begin
  inherited;
  fAddBy := 4;
end;
{$ELSE not_USE_CONSTRUCTORS}

function NewList: PList;
begin

  New( Result, Create );
  (* Result := PList.Create; *)
  //Result.fAddBy := 4;
end;
{$ENDIF USE_CONSTRUCTORS}

function NewListInit( const AItems: array of Pointer ): PList;
var i: Integer;
begin
  Result := NewList;
  Result.Capacity := Length( AItems );
  for i := 0 to High( AItems ) do
    Result.Add( AItems[ i ] );
end;

destructor TList.Destroy;
begin
   Clear;
   inherited;
end;

procedure TList.Release;
var I: Integer;
begin
  if @ Self = nil then Exit;
  for I := 0 to fCount - 1 do
    if fItems[ I ] <> nil then
      FreeMem( fItems[ I ] );
  Free;
end;

procedure TList.ReleaseObjects;
var I: Integer;
begin
  if @ Self = nil then Exit;
  for I := fCount-1 downto 0 do
    PObj( fItems[ I ] ).Free;
  Free;
end;

//var NewItems: PPointerList;
procedure TList.SetCapacity( Value: Integer );
begin
   if Value < Count then
      Value := Count;
   if Value = fCapacity then Exit;
   ReallocMem( fItems, Value * Sizeof( Pointer ) );
   fCapacity := Value;
end;

procedure TList.Clear;
begin
   if fItems <> nil then
      FreeMem( fItems );
   fItems := nil;
   fCount := 0;
   fCapacity := 0;
end;

procedure TList.SetAddBy(Value: Integer);
begin
  if Value < 1 then Value := 1;
  fAddBy := Value;
end;

procedure TList.Add( Value: Pointer );
begin
   //if fAddBy <= 0 then fAddBy := 4;
   if fCapacity <= Count then
   begin
     if fAddBy <= 0 then
       Capacity := Count + Min( 1000, Count div 4 + 1 )
     else
       Capacity := Count + fAddBy;
   end;
   fItems[ fCount ] := Value;
   Inc( fCount );
end;

{$IFDEF _D4orHigher}
procedure TList.AddItems(const AItems: array of Pointer);
var i: Integer;
begin
  Capacity := Count + Length( AItems );
  for i := 0 to High( AItems ) do
    Add( AItems[ i ] );
end;
{$ENDIF}

procedure TList.Delete( Idx: Integer );
begin
   {Assert( (Idx >= 0) and (Idx < fCount), 'TList.Delete: index out of bounds' );
   Move( fItems[ Idx + 1 ], fItems[ Idx ], Sizeof( Pointer ) * (Count - Idx - 1) );
   Dec( fCount );}
   DeleteRange( Idx, 1 );
end;

procedure TList.DeleteRange(Idx, Len: Integer);
begin
  if Len <= 0 then Exit;
  if Idx >= Count then Exit;
  Assert( (Idx >= 0), 'TList.DeleteRange: index out of bounds' );
  if DWORD( Idx + Len ) > DWORD( Count ) then
    Len := Count - Idx;
  Move( fItems[ Idx + Len ], fItems[ Idx ], Sizeof( Pointer ) * (Count - Idx - Len) );
  Dec( fCount, Len );
end;

procedure TList.Remove(Value: Pointer);
var I: Integer;
begin
  I := IndexOf( Value );
  if I >= 0 then
    Delete( I );
end;

procedure TList.Put( Idx: Integer; Value: Pointer );
begin
   if Idx < 0 then Exit;
   if Idx >= Count then Exit;
   //Assert( (Idx >= 0) and (Idx < fCount), 'TList.Put: index out of bounds' );
   fItems[ Idx ] := Value;
end;

function TList.Get( Idx: Integer ): Pointer;
begin
   Result := nil;
   if Idx < 0 then Exit;
   if Idx >= fCount then Exit;
   //Assert( (Idx >= 0) and (Idx < fCount), 'TList.Get: index out of bounds' );
   Result := fItems[ Idx ];
end;

function TList.IndexOf( Value: Pointer ): Integer;
var I: Integer;
begin
   Result := -1;
   for I := 0 to Count - 1 do
   begin
      if fItems[ I ] = Value then
      begin
         Result := I;
         break;
      end;
   end;
end;

procedure TList.Insert(Idx: Integer; Value: Pointer);
begin
   Assert( (Idx >= 0) and (Idx <= Count), 'List index out of bounds' );
   Add( nil );
   if fCount > Idx then
     Move( FItems[ Idx ], FItems[ Idx + 1 ], (fCount - Idx - 1) * Sizeof( Pointer ) );
   FItems[ Idx ] := Value;
end;

procedure TList.MoveItem(OldIdx, NewIdx: Integer);
var Item: Pointer;
    //I: Integer;
begin
  if OldIdx = NewIdx then Exit;
  if NewIdx >= Count then Exit;
  Item := Items[ OldIdx ];
  Delete( OldIdx );
  Insert( NewIdx, Item );
end;

function TList.Last: Pointer;
begin
  if Count = 0 then
    Result := nil
  else
    Result := Items[ Count-1 ];
end;

procedure TList.Swap(Idx1, Idx2: Integer);
var Tmp: Pointer;
begin
  Tmp := FItems[ Idx1 ];
  FItems[ Idx1 ] := FItems[ Idx2 ];
  FItems[ Idx2 ] := Tmp;
end;

procedure TList.SetCount(const Value: Integer);
begin
  if Value >= Count then exit;
  fCount := Value;
end;

procedure TList.Assign(SrcList: PList);
begin
  Clear;
  if SrcList.fCount > 0 then
  begin
    Capacity := SrcList.fCount;
    fCount := SrcList.fCount;
    Move( SrcList.FItems[ 0 ], FItems[ 0 ], Sizeof( Pointer ) * fCount );
  end;
end;


///////////////////////////////////////// STRING LIST OBJECT /////////////////

{ TStrList }

function NewStrList: PStrList;
begin
  New( Result, Create );

(*  Result := PStrList.Create;  *)
end;

destructor TStrList.Destroy;
begin
  Clear;
  inherited;
end;

procedure TStrList.Init;
begin
  //inherited;
  fNameDelim := DefaultNameDelimiter;
end;

function TStrList.Add(const S: string): integer;
begin
  Result := fCount;
  Insert( Result, S );
end;

procedure TStrList.AddStrings(Strings: PStrList);
begin
  SetText( Strings.Text, True );
end;

procedure TStrList.Assign(Strings: PStrList);
begin
  Clear;
  AddStrings( Strings );
end;

procedure TStrList.Clear;
var I: Integer;
begin
  if fCount > 0 then
  for I := fList.Count - 1 downto 0 do
    Delete( I );
  fList.Free;
  fList := nil;
  fCount := 0;
  if fTextBuf <> nil then
  begin
    FreeMem( fTextBuf );
    fTextBuf := nil;
    fTextSiz := 0;
  end;
end;

procedure TStrList.Delete(Idx: integer);
var P: DWORD;
    El:Pointer;
begin
  P := DWORD( fList.fItems[ Idx ] );
  if (fTextBuf <> nil) and ( P >= DWORD( fTextBuf )) and
     ( P < DWORD( fTextBuf ) + fTextSiz ) then
  else
  begin
    El := FList.Items[ Idx ];
    FreeMem( El );
  end;
  fList.Delete( Idx );
  Dec( fCount );
end;

function TStrList.Get(Idx: integer): string;
begin
  if fList <> nil then
    Result := PChar( fList.Items[ Idx ] )
  else Result := '';
end;

function TStrList.GetPChars(Idx: Integer): PChar;
begin
  Result := PChar( fList.fItems[ Idx ] );
end;

function TStrList.GetTextStr: string;
var
   I, Len, Size: integer;
   P: PChar;
begin
     Size := 0;

     for I := 0 to fCount - 1 do
       Inc(Size, StrLen( PChar(fList.fItems[I]) ) + 2);

     SetString(Result, nil, Size);

     P := Pointer(Result);
     for I := 0 to Count - 1 do
     begin
       Len := StrLen(PChar(fList.fItems[I]));
       if (Len > 0) then
       begin
         System.Move(PChar(fList.fItems[I])^, P^, Len);
         Inc(P, Len);
       end;
       P^ := #13;
       Inc(P);
       P^ := #10;
       Inc(P);
     end;
end;

function TStrList.IndexOf(const S: string): integer;
begin
  for Result := 0 to fCount - 1 do
    if (S = PChar( fList.Items[Result] )) then Exit;
  Result := -1;
end;

function TStrList.IndexOf_NoCase(const S: string): integer;
begin
  for Result := 0 to fCount - 1 do
    if StrComp_NoCase( PChar( S ), PChar( fList.Items[Result] ) ) = 0 then Exit;
  Result := -1;
end;


function TStrList.IndexOfStrL_NoCase( Str: PChar; L: Integer ): integer;
begin
  for Result := 0 to fCount - 1 do
    if (StrLen( PChar( fList.fItems[ Result ] ) ) = DWORD( L )) and
       (StrLComp_NoCase( Str, PChar( fList.fItems[ Result ] ), L ) = 0) then Exit;
  Result := -1;
end;

function TStrList.Find(const S: String; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := FALSE;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := AnsiCompareStr( PChar( fList.Items[ I ] ), S );
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := TRUE;
        L := I;
        //break;
        //if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

procedure TStrList.Insert(Idx: integer; const S: string);
var Mem: PChar;
    L: Integer;
begin
  if fList = nil then
     fList := NewList;
  L := Length( S ) + 1;
  GetMem( Mem, L );
  Mem[0] := #0;
  if L > 1 then
     System.Move( S[1], Mem[0], L );
  fList.Insert( Idx, Mem );
  Inc( fCount );
end;

{$IFDEF UNIX}
function FileCreate (Const FileName: string; Mode: Longint) : Longint;
var
  LinuxFlags : longint;
begin
  LinuxFlags:=0;
  Case (Mode and 3) of
    0 : LinuxFlags:=LinuxFlags or O_RdOnly;
    1 : LinuxFlags:=LinuxFlags or O_WrOnly;
    2 : LinuxFlags:=LinuxFlags or O_RdWr;
  end;
  FileCreate:= fpOpen(FileName,LinuxFlags or O_Creat or O_Trunc);
end;
{$ENDIF UNIX}

{$IFDEF WIN32}
function FileCreate (const FileName: string; Mode: Longint) : Longint;
var
  FN : string;
begin
  FN:=FileName+#0;
  Result := CreateFile(@FN[1], GENERIC_READ or GENERIC_WRITE,
                       0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
end;
{$ENDIF WIN32}

function TStrList.LoadFromFile(const FileName: string): Boolean;
begin
  Text:= StrLoadFile(FileName);
end;

procedure TStrList.Move(CurIndex, NewIndex: integer);
begin
  fList.MoveItem( CurIndex, NewIndex );
end;

procedure TStrList.Put(Idx: integer; const Value: string);
begin
  Delete( Idx );
  Insert( Idx, Value );
end;

(* L505: Replaced with StrWrap1 function
function TStrList.SaveToFile(const FileName: string): Boolean;
var
 // F: HFile;
  F: THandle;  //L505: modified
  Buf: String;
begin
  F := FileCreate( FileName, fmOpenWrite); //L505 modified
  Result := F <> INVALID_HANDLE_VALUE;
  if Result then
  begin
    Buf := Text;
    FileWrite( F, Buf[ 1 ], Length( Buf ) );
    SetEndOfFile( F ); // necessary! - V.K.
    FileClose( F );
  end;
end;
*)

procedure TStrList.SaveToFile(const FileName: string);
begin
  StrSaveFile(FileName, Text);
end;

procedure TStrList.SetText(const S: string; Append2List: boolean);
var
  P, TheLast : PChar;
  L, I : Integer;

  procedure AddTextBuf(Src: PChar; Len: DWORD);
  var OldTextBuf, P: PChar;
      I : Integer;
  begin
    if Src <> nil then
    begin
      OldTextBuf := fTextBuf;
      GetMem( fTextBuf, fTextSiz + Len );
      if fTextSiz <> 0 then
      begin
        System.Move( OldTextBuf^, fTextBuf^, fTextSiz );
        for I := 0 to fCount - 1 do
        begin
          P := fList.fItems[ I ];
          if (DWORD( P ) >= DWORD( OldTextBuf )) and
             (DWORD( P ) < DWORD( OldTextBuf ) + fTextSiz) then
            fList.fItems[ I ] := Pointer( DWORD( P ) - DWORD( OldTextBuf ) + DWORD( fTextBuf ) );
        end;
        FreeMem( OldTextBuf );
      end;
      System.Move( Src^, fTextBuf[ fTextSiz ], Len );
      Inc( fTextSiz, Len );
    end;
  end;

begin
     if not Append2List then Clear;
     if S = '' then Exit;

     L := fTextSiz;
     AddTextBuf( PChar( S ), Length( S ) + 1 );

     P := PChar( DWORD( fTextBuf ) + DWORD( L ) );
     if fList = nil then
       fList := NewList;

     I := 0;
     TheLast := P + Length( S );
     while P^ <> #0 do
     begin
       Inc( I );
       P := StrScanLen( P, #13, TheLast - P );
       if P^ = #10 then
         Inc( P );
     end;

     Inc( fCount, I );
     if fList.fCapacity < fCount  then
        fList.Capacity := fCount;

     P := PChar( DWORD( fTextBuf ) + DWORD( L ) );
     while P^ <> #0 do
     begin
       fList.Add( P );
       P := StrScanLen( P, #13, TheLast - P );
       if PChar( P - 1 )^ = #13 then
         PChar( P - 1 )^ := #0;
       if P^ = #10 then Inc(P);
     end;
end;

procedure TStrList.SetUnixText(const S: String; Append2List: Boolean);
var S1: String;
begin
  S1 := S;
  NormalizeUnixText( S1 );
  SetText( S1, Append2List );
end;

procedure TStrList.SetTextStr(const Value: string);
begin
  SetText( Value, False );
end;

function CompareStrListItems( const Sender : Pointer; const e1, e2 : DWORD ) : Integer;
var S1, S2 : PChar;
begin
  S1 := PStrList( Sender ).fList.Items[ e1 ];
  S2 := PStrList( Sender ).fList.Items[ e2 ];
  if PStrList( Sender ).fCaseSensitiveSort then
    Result := StrComp( S1, S2 )
  else
    Result := StrComp( PChar( LowerCase( S1 ) ), PChar( LowerCase( S2 ) ) );
end;

procedure SwapStrListItems( const Sender: Pointer; const e1, e2: DWORD );
begin
  PStrList( Sender ).Swap( e1, e2 );
end;

procedure TStrList.Sort(CaseSensitive: Boolean);
begin
  fCaseSensitiveSort := CaseSensitive;
  SortData( @Self, fCount, @CompareStrListItems, @SwapStrListItems );
end;

procedure TStrList.Swap(Idx1, Idx2: Integer);
begin
  fList.Swap( Idx1, Idx2 );
end;

function TStrList.Last: String;
begin
  if Count = 0 then
    Result := ''
  else
    Result := Items[ Count - 1 ];
end;

function TStrList.IndexOfName(AName: string): Integer;
var
  i: Integer;
  L: Integer;
begin
  Result:=-1;
  // Do not start search if empty string
  L := Length( AName );
  if L > 0 then
  begin
    AName := LowerCase( AName ) + fNameDelim;
    Inc( L );
    for i := 0 to fCount - 1 do
    begin
      // For optimization, check only list entry that begin with same letter as searched name
      if StrLComp( PChar( LowerCase( ItemPtrs[ i ] ) ), PChar( AName ), L ) = 0 then
      begin
        Result:=i;
        exit;
      end;
    end;
  end;
end;

function TStrList.GetValue(const AName: string): string;
var
  i: Integer;
begin
  I := IndexOfName(AName);
  if I >= 0
  then Result := Copy(Items[i], Length(AName) + 2, Length(Items[i])-Length(AName)-1)
  else Result := '';
end;

procedure TStrList.SetValue(const AName, Value: string);
var
  I: Integer;
begin
  I := IndexOfName(AName);
  if i=-1
  then Add( AName + fNameDelim + Value )
  else Items[i] := AName + fNameDelim + Value;
end;

function TStrList.GetLineName(Idx: Integer): string;
begin
  Result := Items[ Idx ];
  Result := Parse( Result, fNameDelim );
end;

procedure TStrList.SetLineName(Idx: Integer; const NV: string);
begin
  Items[ Idx ] := NV + fNameDelim + LineValue[ Idx ];
end;

function TStrList.GetLineValue(Idx: Integer): string;
begin
  Result := Items[ Idx ];
  Parse( Result, fNameDelim );
end;

procedure TStrList.SetLineValue(Idx: Integer; const Value: string);
begin
  Items[ Idx ] := LineName[ Idx ] + fNameDelim + Value;
end;

function TStrList.Join( const sep: String ): String;
var
   I, Len, Size: integer;
   P: PChar;
begin
  Size := 0;

  for I := 0 to Count - 1 do
    Inc(Size, Integer( StrLen( ItemPtrs[I] ) ) + Length(Sep));

  SetString(Result, nil, Size);

  P := @ Result[ 1 ];
  for I := 0 to Count - 1 do
  begin
    Len := StrLen( ItemPtrs[I] );
    if (Len > 0) then
    begin
      System.Move( ItemPtrs[I]^, P^, Len);
      Inc(P, Len);
    end;
    P := StrPCopy(P, Sep);
  end;
end;

////////////////////////////////// EXTENDED STRING LIST OBJECT ////////////////

{ TStrListEx }

function NewStrListEx: PStrListEx;
begin
  {-}
  new( Result, Create );
  {+}
  {++}(*
  Result := PStrListEx.Create;
  *){--}
end;

destructor TStrListEx.Destroy;
var Obj: PList;
begin
  Obj := FObjects;
  inherited;
  Obj.Free;
end;

function TStrListEx.GetObjects(Idx: Integer): DWORD;
begin
  Result := DWORD( FObjects.Items[ Idx ] );
end;

procedure TStrListEx.SetObjects(Idx: Integer; const Value: DWORD);
begin
  ProvideObjCapacity( Idx + 1 );
  FObjects.Items[ Idx ] := Pointer( Value );
end;

procedure TStrListEx.Init;
begin
  FObjects := NewList;
end;

procedure SwapStrListExItems( const Sender: Pointer; const e1, e2: DWORD );
begin
  PStrListEx( Sender ).Swap( e1, e2 );
end;

procedure TStrListEx.Sort(CaseSensitive: Boolean);
begin
  fCaseSensitiveSort := CaseSensitive;
  SortData( @Self, fCount, @CompareStrListItems, @SwapStrListExItems );
end;

procedure TStrListEx.Move(CurIndex, NewIndex: integer);
begin
  // move string
  fList.MoveItem( CurIndex, NewIndex );
  // move object
  if FObjects.fCount >= Min( CurIndex, NewIndex ) then
  begin
    ProvideObjCapacity( max( CurIndex, NewIndex ) + 1 );
    FObjects.MoveItem( CurIndex, NewIndex );
  end;
end;

procedure TStrListEx.Swap(Idx1, Idx2: Integer);
begin
  // swap strings
  fList.Swap( Idx1, Idx2 );
  // swap objects
  if FObjects.fCount >= Min( Idx1, Idx2 ) then
  begin
    ProvideObjCapacity( max( Idx1, Idx2 ) + 1 );
    FObjects.Swap( Idx1, Idx2 );
  end;
end;

procedure TStrListEx.ProvideObjCapacity(NewCap: Integer);
begin
  if FObjects.FCount < NewCap then
  begin
    FObjects.Capacity := NewCap;
    FillChar( FObjects.FItems[ FObjects.FCount ],
              (FObjects.Capacity - FObjects.Count) * sizeof( Pointer ), 0 );
    FObjects.FCount := NewCap;
  end;
end;

procedure TStrListEx.AddStrings(Strings: PStrListEx);
var I: Integer;
begin
  I := Count;
  if Strings.FObjects.fCount > 0 then
    ProvideObjCapacity( Count );
  inherited AddStrings( Strings );
  if Strings.FObjects.fCount > 0 then
  begin
    ProvideObjCapacity( I + Strings.FObjects.fCount );
    System.Move( Strings.FObjects.FItems[ 0 ],
                 FObjects.FItems[ I ],
                 Sizeof( Pointer ) * Strings.FObjects.fCount );
  end;
end;

procedure TStrListEx.Assign(Strings: PStrListEx);
begin
  inherited Assign( Strings );
  FObjects.Assign( Strings.FObjects );
end;

procedure TStrListEx.Clear;
begin
  inherited;
  FObjects.Clear;
end;

procedure TStrListEx.Delete(Idx: integer);
begin
  inherited;
  if FObjects.fCount > Idx then // mdw: '>=' -> '>'
    FObjects.Delete( Idx );
end;

function TStrListEx.LastObj: DWORD;
begin
  if Count = 0 then
    Result := 0
  else
    Result := Objects[ Count - 1 ];
end;

function TStrListEx.AddObject(const S: String; Obj: DWORD): Integer;
begin
  Result := Count;
  InsertObject( Count, S, Obj );
end;

procedure TStrListEx.InsertObject(Before: Integer; const S: String; Obj: DWORD);
begin
  Insert( Before, S );
  ProvideObjCapacity( Before );
  FObjects.Insert( Before, Pointer( Obj ) );
end;

function TStrListEx.IndexOfObj( Obj: Pointer ): Integer;
begin
  Result := FObjects.IndexOf( Obj );
end;

function StrComp_NoCase(const Str1, Str2: PChar): Integer;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EDX
        XCHG    ESI,EAX
        OR      ECX, -1
        XOR     EAX,EAX
        REPNE   SCASB

        NOT     ECX
        MOV     EDI,EDX
  @@0:
        XOR     EDX,EDX
        REPE    CMPSB
        MOV     AL,[ESI-1]
        MOV     AH, AL
        SUB     AH, 'a'
        CMP     AH, 25
        JA      @@1
        SUB     AL, $20
  @@1:
        MOV     DL,[EDI-1]
        MOV     AH, DL
        SUB     AH, 'a'
        CMP     AH, 25
        JA      @@2
        SUB     DL, $20
  @@2:
        MOV     AH, 0
        SUB     EAX,EDX
        JNZ     @@exit
        CMP     DL, 0
        JNZ     @@0

  @@exit:
        POP     ESI
        POP     EDI
end;

function StrLComp_NoCase(const Str1, Str2: PChar; MaxLen: Cardinal): Integer;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     EDI,EDX
        MOV     ESI,EAX
        MOV     EBX,ECX
        XOR     EAX,EAX
        OR      ECX,ECX
        JE      @@exit
        REPNE   SCASB
        SUB     EBX,ECX
        MOV     ECX,EBX
        MOV     EDI,EDX
  @@0:
        XOR     EDX,EDX
        REPE    CMPSB
        MOV     AL,[ESI-1]
        MOV     AH, AL
        SUB     AH, 'a'
        CMP     AH, 25
        JA      @@1
        SUB     AL, $20
  @@1:
        MOV     DL,[EDI-1]
        MOV     AH, DL
        SUB     AH, 'a'
        CMP     AH, 25
        JA      @@2
        SUB     DL, $20
  @@2:
        MOV     AH, 0
        SUB     EAX,EDX
        JECXZ   @@exit
        JZ      @@0

  @@exit:
        POP     EBX
        POP     ESI
        POP     EDI
end;

function StrLComp(const Str1, Str2: PChar; MaxLen: Cardinal): Integer; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     EDI,EDX
        MOV     ESI,EAX
        MOV     EBX,ECX
        XOR     EAX,EAX
        OR      ECX,ECX
        JE      @@1
        REPNE   SCASB
        SUB     EBX,ECX
        MOV     ECX,EBX
        MOV     EDI,EDX
        XOR     EDX,EDX
        REPE    CMPSB
        MOV     AL,[ESI-1]
        MOV     DL,[EDI-1]
        SUB     EAX,EDX
@@1:    POP     EBX
        POP     ESI
        POP     EDI
end;

function StrLen(const Str: PChar): Cardinal; assembler;
asm
        XCHG    EAX, EDI
        XCHG    EDX, EAX
        OR      ECX, -1
        XOR     EAX, EAX
        CMP     EAX, EDI
        JE      @@exit0
        REPNE   SCASB
        DEC     EAX
        DEC     EAX
        SUB     EAX,ECX
@@exit0:
        MOV     EDI,EDX
end;

function StrScanLen(Str: PChar; Chr: Char; Len: Integer): PChar; assembler;
asm
        PUSH    EDI
        XCHG    EDI, EAX
        XCHG    EAX, EDX
        REPNE   SCASB
        XCHG    EAX, EDI
        POP     EDI
        { -> EAX => to next character after found or to the end of Str,
             ZF = 0 if character found. }
end;

procedure NormalizeUnixText( var S: String );
var I: Integer;
begin
  if S <> '' then
  begin
    if S[ 1 ] = #10 then
      S[ 1 ] := #13;
    for I := 2 to Length(S) do
      if (S[I]=#10) and (S[I-1]<>#13) then
        S[I] := #13;
  end;
end;

procedure SortData( const Data: Pointer; const uNElem: Dword;
                    const CompareFun: TCompareEvent;
                    const SwapProc: TSwapEvent );
{ uNElem - number of elements to sort }

  function Compare( const e1, e2 : DWord ) : Integer;
  begin
    Result := CompareFun( Data, e1 - 1, e2 - 1 );
  end;

  procedure Swap( const e1, e2 : DWord );
  begin
    SwapProc( Data, e1 - 1, e2 - 1 );
  end;

  procedure qSortHelp(pivotP: Dword; nElem: Dword);
  label
    TailRecursion,
    qBreak;
  var
    leftP, rightP, pivotEnd, pivotTemp, leftTemp: Dword;
    lNum: Dword;
    retval: integer;
  begin
    TailRecursion:
      if (nElem <= 2) then
      begin
        if (nElem = 2) then
          begin
            rightP := pivotP +1;
            retval := Compare(pivotP,rightP);
            if (retval > 0) then Swap(pivotP,rightP);
          end;
        exit;
      end;
      rightP := (nElem -1) + pivotP;
      leftP :=  (nElem shr 1) + pivotP;
      { sort pivot, left, and right elements for "median of 3" }
      retval := Compare(leftP,rightP);
      if (retval > 0) then Swap(leftP, rightP);
      retval := Compare(leftP,pivotP);

      if (retval > 0) then
        Swap(leftP, pivotP)
      else
      begin
        retval := Compare(pivotP,rightP);
        if retval > 0 then Swap(pivotP, rightP);
      end;
      if (nElem = 3) then
      begin
        Swap(pivotP, leftP);
        exit;
      end;
      { now for the classic Horae algorithm }
      pivotEnd := pivotP + 1;
      leftP := pivotEnd;
      repeat

        retval := Compare(leftP, pivotP);
        while (retval <= 0) do
          begin

            if (retval = 0) then
              begin
                Swap(leftP, pivotEnd);
                Inc(pivotEnd);
              end;
            if (leftP < rightP) then
              Inc(leftP)
            else
              goto qBreak;
            retval := Compare(leftP, pivotP);
          end; {while}
        while (leftP < rightP) do
          begin
            retval := Compare(pivotP, rightP);
            if (retval < 0) then
              Dec(rightP)

            else
              begin
                Swap(leftP, rightP);
                if (retval <> 0) then
                  begin
                    Inc(leftP);
                    Dec(rightP);
                  end;
                break;
              end;
          end; {while}

      until (leftP >= rightP);
    qBreak:
      retval := Compare(leftP,pivotP);
      if (retval <= 0) then Inc(leftP);

      leftTemp := leftP -1;
      pivotTemp := pivotP;
      while ((pivotTemp < pivotEnd) and (leftTemp >= pivotEnd)) do
      begin
        Swap(pivotTemp, leftTemp);
        Inc(pivotTemp);
        Dec(leftTemp);
      end; {while}
      lNum := (leftP - pivotEnd);
      nElem := ((nElem + pivotP) -leftP);

      if (nElem < lNum) then
      begin
        qSortHelp(leftP, nElem);
        nElem := lNum;
      end
        else
      begin
        qSortHelp(pivotP, lNum);
        pivotP := leftP;
      end;
      goto TailRecursion;
    end; {qSortHelp }

begin
  if (uNElem < 2) then  exit; { nothing to sort }
  qSortHelp(1, uNElem);
end;

function Parse( var S : String; const Separators : String ) : String;
var Pos : Integer;
begin
  Pos := IndexOfCharsMin( S, Separators );
  if Pos <= 0 then
     Pos := Length( S ) + 1;
  Result := S;
  S := Copy( Result, Pos + 1, MaxInt );
  Result := Copy( Result, 1, Pos - 1 );
end;

function IndexOfCharsMin( const S, Chars : String ) : Integer;
var I, J : Integer;
begin
  Result := -1;
  for I := 1 to Length( Chars ) do
  begin
    J := IndexOfChar( S, Chars[ I ] );
    if J > 0 then
    begin
      if (Result < 0) or (J < Result) then
         Result := J;
    end;
  end;
end;

function IndexOfChar( const S : String; Chr : Char ) : Integer;
var
  P, F : PChar;
begin
   P := PChar( S );
   F := StrScan( P, Chr );
   Result := -1;
   if F = nil then Exit;
   Result := Integer( F ) - Integer( P ) + 1;
end;

procedure DummyObjProc( Sender: PObj );
begin
end;

procedure DummyObjProcParam( Sender: PObj; Param: Pointer );
begin
end;

{$IFDEF WIN32}
function AnsiCompareStr(const S1, S2: string): longint;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, 0, PChar(S1), -1,
    PChar(S2), -1 ) - 2;
end;
{$ENDIF WIN32}

{$IFDEF UNIX}
function AnsiCompareStr(const S1, S2: string): integer;
begin
  result:=widestringmanager.CompareStrAnsiStringProc(s1,s2);
end;
{$ENDIF UNIX}

function StrComp(const Str1, Str2: PChar): Integer; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EDX
        XCHG    ESI,EAX
        OR      ECX, -1
        XOR     EAX,EAX
        REPNE   SCASB
        NOT     ECX
        MOV     EDI,EDX
        XOR     EDX,EDX
        REPE    CMPSB
        MOV     AL,[ESI-1]
        MOV     DL,[EDI-1]
        SUB     EAX,EDX
        POP     ESI
        POP     EDI
end;

{$ifdef fpc}
function strmove(dest,source : pchar;l : SizeInt) : pchar;
begin
  move(source^,dest^,l);
  strmove:=dest;
end;

function StrPCopy(Dest: PChar; Source: string): PChar;
begin
  result:= StrMove(Dest, PChar(Source), length(Source)+1);
end ;
{$endif}

function StrScan(Str: PChar; Chr: Char): PChar; assembler;
asm
        PUSH    EDI
        PUSH    EAX
        MOV     EDI,Str
        OR      ECX, -1
        XOR     AL,AL
        REPNE   SCASB
        NOT     ECX
        POP     EDI
        XCHG    EAX, EDX
        REPNE   SCASB

        XCHG    EAX, EDI
        POP     EDI

        JE      @@1
        XOR     EAX, EAX
        RET

@@1:    DEC     EAX
end;


function Min( X, Y: Integer ): Integer;
asm
  {$IFDEF USE_CMOV}
  CMP   EAX, EDX
  CMOVG EAX, EDX
  {$ELSE}
  CMP EAX, EDX
  JLE @@exit
  MOV EAX, EDX
@@exit:
  {$ENDIF}
end;

function Max( X, Y: Integer ): Integer;
asm
  {$IFDEF USE_CMOV}
  CMP EAX, EDX
  CMOVL EAX, EDX
  {$ELSE}
  CMP EAX, EDX
  JGE @@exit
  MOV EAX, EDX
@@exit:
  {$ENDIF}
end;

{$ifndef fpc} // not needed for fpc, defined in system
function StrPCopy(Dest: PChar; const Source: string): PChar;
begin
  Result := StrLCopy(Dest, PChar(Source), Length(Source));
end;

function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar; assembler;
asm

        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,ECX
        XOR     AL,AL
        TEST    ECX,ECX
        JZ      @@1
        REPNE   SCASB
        JNE     @@1
        INC     ECX
@@1:    SUB     EBX,ECX
        MOV     EDI,ESI
        MOV     ESI,EDX
        MOV     EDX,EDI
        MOV     ECX,EBX
        SHR     ECX,2
        REP     MOVSD
        MOV     ECX,EBX
        AND     ECX,3
        REP     MOVSB
        STOSB
        MOV     EAX,EDX
        POP     EBX
        POP     ESI
        POP     EDI
end;

function LowerCase(const S: string): string;
var I : Integer;
begin
  Result := S;
  for I := 1 to Length( S ) do
    if Result[ I ] in [ 'A'..'Z' ] then
       Inc( Result[ I ], 32 );
end;

function UpperCase(const S: string): string;
var I : Integer;
begin
  Result := S;
  for I := 1 to Length( S ) do
    if Result[ I ] in [ 'a'..'z' ] then
       Dec( Result[ I ], 32 );
end;

{$ENDIF NOT FPC}

function Int2Str( Value : Integer ) : string;
var Buf : array[ 0..15 ] of Char;
    Dst : PChar;
    Minus : Boolean;
    D: DWORD;
begin
  Dst := @Buf[ 15 ];
  Dst^ := #0;
  Minus := False;
  if Value < 0 then
  begin
    Value := -Value;
    Minus := True;
  end;
  D := Value;
  repeat
    Dec( Dst );
    Dst^ := Char( (D mod 10) + Byte( '0' ) );
    D := D div 10;
  until D = 0;
  if Minus then
  begin
    Dec( Dst );
    Dst^ := '-';
  end;
  Result := Dst;
end;

end.

