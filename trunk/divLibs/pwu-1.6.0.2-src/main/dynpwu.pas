(*******************************************************************************

                                PSP/PWU 1.6.X

********************************************************************************

--------------------------------------------------------------------------------
 Main Declaration/Initialization Unit
--------------------------------------------------------------------------------                    
  IMPORT UNIT DECLARATIONS  (dynamic PSP/PWU)
  This unit contains the declarations for web programs using the PSP/PWU library.
                                                            
  Authors/Credits: L505 (Lars),

********************************************************************************)


{$IFDEF FPC}{$MODE OBJFPC}{$H+} 
  {$IFDEF EXTRA_SECURE}
    {$R+}{$Q+}{$CHECKPOINTER ON}
  {$ENDIF}
{$ENDIF}

{$ifdef win32} {$define windows} 
{$endif}

//{$DEFINE VERBOSE_ERROR} //Verbose error reporting, helps debugging, turn off to save exececutable space

//{$DEFINE FORCE_DEBUG} // Force HTTP header early, leave off unless you have
                        // unknown 500 errors and a dead program.

unit dynpwu;


interface

uses
  pwuErrors,  
  pwuTypes{, sdsMain};

{ exact DLL version required }
{$i ../version/version.inc}

{------------------------------------------------------------------------------}
{  SPECIAL MEMORY MANAGER                                                      }
{------------------------------------------------------------------------------}

  // procedure to get memory manager from library
  type
    TGetMemMan = procedure (out MemMan : TMemoryManager); stdcall;
  var
    GetMemMan: TGetMemMan;

  // storage buffer for imported memory manager
  var
    GottenMemMan : TMemoryManager;
    OldMemMan: TMemoryManager;

{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{  PUBLIC PROCEDURE/FUNCTION TYPE DECLARATIONS                                 }
{------------------------------------------------------------------------------}
(*
 { sdsMain } //todo move to dynsds
  type
    TColumnFree        = procedure (cp: SDS_ColumnInfo);
    TColumnIndex       = function (cp: SDS_ColumnInfo; const name: string): longword;
    TColumnInfo        = function (const FileName: string): SDS_ColumnInfo;
    TColumnName        = function (cp: SDS_ColumnInfo; index: longword): string;
    TColumnType        = function (cp: SDS_ColumnInfo; index: longword): byte;
    TEscape            = function (const str: string): string;
    TExportCSV         = function (const FileName: string): string;
    TExportCSV_custom  = function (const filename, encloser, delimiter: string): string;
    TExportSDS         = function (const FileName: string): string;
    TExportSQL         = function (const FileName, SQLTable: string): string;
    TExportXML         = function (const FileName, TableTag, RowTag: string): string;
    TFetchColumn       = function (ap: SDS_Array; index: longword): string;
    TFetchColumn_float = function (ap: SDS_Array; index: longword): double;
    TFetchColumn_int   = function (ap: SDS_Array; index: longword): longint;
    TFetchField        = function (ap: SDS_Array; const name: string): string;
    TFetchField_float  = function (ap: SDS_Array; const name: string): double;
    TFetchField_int    = function (ap: SDS_Array; const name: string): longint;
    TFetchRow          = function (rp: SDS_Result): SDS_Array;
    TFreeResult        = procedure (rp: SDS_Result);
    TFreeRow           = procedure (ap: SDS_Array);
    TImportSQL         = function (const dump: string): longword;
    TLastID            = function (const FileName: string): longword;
    TNumFields         = function (const FileName: string): longword;
    TNumRows           = function (const FileName: string): longword;
    TResultCmd         = function (rp: SDS_Result): string;
    TResultEOF         = function (rp: SDS_Result): boolean;
    TResultError       = function (rp: SDS_Result): string;
    TResultFields      = function (rp: SDS_Result): longword;
    TResultPointer     = function (rp: SDS_Result): longword;
    TResultRewind      = procedure (rp: SDS_Result);
    TResultRows        = function (rp: SDS_Result): longword;
    TResultSeek        = procedure (rp: SDS_Result; index: longword);
    TResultTime        = function (rp: SDS_Result): double;
    TTotalFields       = function (const FileName: string): longword;
    TQuery             = function (const InputQuery: string): SDS_Result;
*)

 { pwuMain }
  type

  {-- CGI Variable Functions --}
    TGetCGIVar          = function (const name: string): string;
    TGetCGIVar_SafeHTML = function (const name: string): string;
//    TGetEnvVar          = function (const name: string): string; //MOVED TO PWUENVVAR.PAS
    TGetCGIVar_S        = function (const name: string; const SecureLevel: integer): string;
    TGetCGIVarAsInt     = function (const name: string): longint;
    TFetchCGIVarName    = function (index: longword): string;
    TFetchCGIVarValue   = function (index: longword): string;
    TGetCGIVar_SF       = function (const name: string; const SecureLevel: integer): string;
    TCountCGIVars       = function: longword;
    TCountWebVars       = function: longword;
    TGetCGIVarAsFloat   = function (const name: string): double;
    TIsCgiVar           = function (const name: string): boolean;

  {-- Cookie Functions --}
    TSetCookieAsFloat   = function (const name: string; value: double): boolean;
    TSetCookieAsInt     = function (const name: string; value: longint): boolean;
    TSetCookieEx        = function (const name, value, path, domain, expires: string): boolean;
    TSetCookieAsFloatEx = function (const name: string; value: double; const path, domain, expires: string): boolean;
    TSetCookieAsIntEx   = function (const name: string; value: longint; const path, domain, expires: string): boolean;
    TUnsetCookieEx      = function (const name, path, domain: string): boolean;
    TUnsetCookie        = function (const name: string): boolean;
    TIsCookie           = function (const name: string): boolean;
    TSetCookie          = function (const name, value: string): boolean;
    TFetchCookieName    = function (index: longword): string;
    TFetchCookieValue   = function (index: longword): string;
    TGetCookieAsFloat   = function (const name: string): double;
    TCountCookies       = function: longword;
    TGetCookie          = function (const name: string): string;
    TGetCookieAsInt     = function (const name: string): longint;

  {-- Config Functions --}
    TGetWebConfigVar        = function (const name: string): string;
    TCountWebConfigVars     = function: longword;
    TSetWebConfigVar        = function (const name, value: string): boolean;
    TIsWebConfigVar         = function (const name: string): boolean;
    TFetchWebConfigVarName  = function (index: longword): string;
    TFetchWebConfigVarValue = function (index: longword): string;

  {-- Environment Variable Functions --}
    TIsEnvVar     = function (const name: string): boolean;

  {-- Filtering Functions --}

    TFilterHTML_S      = function (const s: string; const SecureLevel: integer): string;
    TTrimBadChars_S    = function (const s: string; const SecureLevel: integer): string;
    TTrimBadChars      = function (const s: string): string;
    TFilterHTML        = function (const s: string): string;
    TTrimBadChars_file = function (const s: string): string;
    TTrimBadChars_dir  = function (const s: string): string;

  {-- Header Functions --}
    TCountWebheaders     = function : longword;
    TFetchWebHeaderName  = function (index: longword): string;
    TFetchWebHeaderValue = function (index: longword): string;
    TGetWebHeader        = function (const s: string): string;
    TIsWebHeader         = function (const s: string): boolean;
    TSetWebHeader        = function (const s, value: string): boolean;
    TUnsetWebHeader      = function (const s: string): boolean;
    TPutWebHeader        = function (const header: string): boolean;
    TGetMimeType         = function (const mfile: string): String;

  {-- Output/Write Out Functions/Procedures --}
    TWebWrite           = procedure (const s: string);
    TWebWriteF          = procedure (const s: string);
    TWebWriteFF         = procedure (const s: string);
    TWebWriteF_Fi       = procedure (const s: string; const HTMLFilter: boolean);
    TWebWriteLn         = procedure (const s: string);
    TWebWriteLnF        = procedure (const s: string);
    TWebWriteLnFF       = procedure (const s: string);
    TWebWriteLnF_Fi     = procedure (const s: string; const HTMLFilter: boolean );
    TWebFileOut         = function (const fname: string): errcode;
 
    TWebResourceOut     = function (const fname: string): errcode;
    TWebBufferOut       = procedure (const buff; bufflength : longword);
    TWebTemplateOut     = function (const fname: string; const HTMLFilter: boolean): errcode;
    TWebTemplateRaw     = function (const fname: string): errcode;
    TWebFormat          = function (const str: string): string;
    TWebFormatAndFilter = function (const str: string): string;
    TWebFormat_SF       = function (const str: string; const HTMLFilter: boolean; const FilterSecureLevel, TrimSecureLevel: integer): string;

  {-- RTI Functions --}
    TCountRTIVars  = function : longword;
    TFetchRTIName  = function (index: longword): string;
    TFetchRTIValue = function (index: longword): string;
    TGetRTI        = function (const s: string): string;
    TGetRTIAsFloat = function (const s: string): double;
    TGetRTIAsInt   = function (const s: string): longint;
    TIsRTI         = function (const s: string): boolean;

  {-- Session Functions --}
    TCountSessVars  = function : longword;
    TFetchSessName  = function (index: longword): string;
    TFetchSessValue = function (index: longword): string;
    TGetSess        = function (const s: string): string;
    TGetSessAsFloat = function (const s: string): double;
    TGetSessAsInt   = function (const s: string): longint;
    TIsSess         = function (const s: string): boolean;
    TSessDestroy    = function : boolean;
    TSetSess        = function (const s, value: string): boolean;
    TSetSessAsFloat = function (const s: string; value: double): boolean;
    TSetSessAsInt   = function (const s: string; value: longint): boolean;
    TUnsetSess      = function (const s: string): boolean;

  {-- Upload File Functions --}
    TFetchUpfileName = function (index: longword): string;
    TGetUpFileName   = function (const s: string): string;
    TGetUpFileSize   = function (const s: string): longint;
    TGetUpFileType   = function (const s: string): string;
    TCountUpFiles    = function : longword;
    TIsUpFile        = function (const s: string): boolean;
    TSaveUpFile      = function (const name, fname: string): boolean;

  {-- Web Variable Functions/Procedures --}
    TFetchWebVarName  = function (index: longword): string;
    TFetchWebVarValue = function (index: longword): string;
    TGetWebVar        = function (const s: string): string;
    TGetWebVar_S      = function (const s: string; const SecureLevel: integer): string;
    TGetWebVarAsFloat = function (const s: string): double;
    TGetWebVarAsInt   = function (const s: string): longint;
    TSetWebVar        = procedure (const s, value: string);
    TSetWebVarAsFloat = procedure (const s: string; value: double);
    TSetWebVarAsInt   = procedure (const s: string; value: longint);
    TIsWebVar         = function (const s: string): byte;
    TUnsetWebVar      = procedure (const s: string);

  {-- Utility/Tools Functions --}
    TLineEndToBR = function (const str: string): string;
    TRandomStr   = function (len: longint): string;
    TXORCrypt    = function (const str: string; key: byte): string;

  {-- Error Functions --}
    TThrowWebError = function (const message: string): boolean;

// END PUBLIC FUNCTION/PROCEDURE TYPE DECLARATIONS
{------------------------------------------------------------------------------}


{------------------------------------------------------------------------------}
{  PUBLIC PROCEDURE/FUNCTION VAR DECLARATIONS                                  }
{------------------------------------------------------------------------------}
(*
 {sdsMain}
  var
    ColumnFree         : TColumnFree          ;
    ColumnIndex        : TColumnIndex         ;
    ColumnInfo         : TColumnInfo          ;
    ColumnName         : TColumnName          ;
    ColumnType         : TColumnType          ;
    Escape             : TEscape              ;
    ExportCSV          : TExportCSV           ;
    ExportCSV_custom   : TExportCSV_custom    ;
    ExportSDS          : TExportSDS           ;
    ExportSQL          : TExportSQL           ;
    ExportXML          : TExportXML           ;
    FetchColumn        : TFetchColumn         ;
    FetchColumn_float  : TFetchColumn_float   ;
    FetchColumn_int    : TFetchColumn_int     ;
    FetchField         : TFetchField          ;
    FetchField_float   : TFetchField_float    ;
    FetchField_int     : TFetchField_int      ;
    FetchRow           : TFetchRow            ;
    FreeResult         : TFreeResult          ;
    FreeRow            : TFreeRow             ;
    ImportSQL          : TImportSQL           ;
    LastID             : TLastID              ;
    NumFields          : TNumFields           ;
    NumRows            : TNumRows             ;
    ResultCmd          : TResultCmd           ;
    ResultEOF          : TResultEOF           ;
    ResultError        : TResultError         ;
    ResultFields       : TResultFields        ;
    ResultPointer      : TResultPointer       ;
    ResultRewind       : TResultRewind        ;
    ResultRows         : TResultRows          ;
    ResultSeek         : TResultSeek          ;
    ResultTime         : TResultTime          ;
    TotalFields        : TTotalFields         ;
    Query              : TQuery               ;
*)

 {pwuMain}
  var
    CountCGIVars:                            TCountCGIVars                 ;
    GetCGIVar:                               function (const name: string): string; // two ways of doing it, this way or the TFunction way. The executable size is the same using both ways, so.. doesn't matter.
    GetCGIVar_S:                             TGetCGIVar_S                  ;        // the above line is actually a better way of declaring the functions because CodeCompletion works better when we have a true declartion of the procedure in IDE's
    GetCGIVarAsFloat:                        TGetCGIVarAsFloat             ;
    GetCGIVarAsInt:                          TGetCGIVarAsInt               ;
    GetCGIVar_SafeHTML:                      TGetCGIVar_SafeHTML           ;
    FetchCGIVarName:                         TFetchCGIVarName              ;
    FetchCGIVarValue:                        TFetchCGIVarValue             ;
    IsCGIVar:                                TIsCgiVar                     ;
    GetCGIVar_SF:                            TGetCGIVar_SF                 ;

    CountCookies:                            TCountCookies                 ;
    FetchCookieName:                         TFetchCookieName              ;
    FetchCookieValue:                        TFetchCookieValue             ;
    GetCookie:                               TGetCookie                    ;
    GetCookieAsFloat:                        TGetCookieAsFloat             ;
    GetCookieAsInt:                          TGetCookieAsInt               ;
    IsCookie:                                TIsCookie                     ;
    SetCookie:                               TSetCookie                    ;
    SetCookieAsFloat:                        TSetCookieAsFloat             ;
    SetCookieAsInt:                          TSetCookieAsInt               ;
    SetCookieEx:                             TSetCookieEx                  ;
    SetCookieAsFloatEx:                      TSetCookieAsFloatEx           ;
    SetCookieAsIntEx:                        TSetCookieAsIntEx             ;
    UnsetCookie:                             TUnsetCookie                  ;
    UnsetCookieEx:                           TUnsetCookieEx                ;

    CountWebConfigVars:                      TCountWebConfigVars           ;
    FetchWebConfigVarName:                   TFetchWebConfigVarName        ;
    FetchWebConfigVarValue:                  TFetchWebConfigVarValue       ;
    GetWebConfigVar:                         TGetWebConfigVar              ;
    IsWebConfigVar:                          TIsWebConfigVar               ;
    SetWebConfigVar:                         TSetWebConfigVar              ;

//    GetEnvVar:                               TGetEnvVar                    ; //MOVED TO PWUENVVAR.PAS
    IsEnvVar:                                TIsEnvVar                     ;

    FilterHTML:                              TFilterHTML                   ;
    FilterHTML_S:                            TFilterHTML_S                 ;
    TrimBadChars:                            TTrimBadChars                 ;
    TrimBadChars_file:                       TTrimBadChars_file            ;
    TrimBadChars_dir:                        TTrimBadChars_dir             ;
    TrimBadChars_S:                          TTrimBadChars_S               ;

    CountWebheaders:                         TCountWebheaders              ;
    FetchWebHeaderName:                      TFetchWebHeaderName           ;
    FetchWebHeaderValue:                     TFetchWebHeaderValue          ;
    GetWebHeader:                            TGetWebHeader                 ;
    IsWebHeader:                             TIsWebHeader                  ;
    SetWebHeader:                            TSetWebHeader                 ;
    UnsetWebHeader:                          TUnsetWebHeader               ;
    PutWebHeader:                            TPutWebHeader                 ;
    GetMimeType:                             TGetMimeType                  ;
    WebWrite:                                TWebWrite                     ;
    WebWriteA:                               procedure (args: array of const);
     
    WebWriteF:                               TWebWriteF                    ;
    WebWriteFF:                              TWebWriteFF                   ;
    WebWriteF_Fi:                            TWebWriteF_Fi                 ;
    WebWriteLn:                              TWebWriteLn                   ;
    WebWriteLnF:                             TWebWriteLnF                  ;
    WebWriteLnFF:                            TWebWriteLnFF                 ;
    WebWriteLnF_Fi:                          TWebWriteLnF_Fi               ;
    WebFileOut:                              TWebFileOut                   ;
    WebResourceOut:                          TWebResourceOut               ;
    WebBufferOut:                            TWebBufferOut                 ;
    WebTemplateOut:                          TWebTemplateOut               ;
    WebTemplateRaw:                          TWebTemplateRaw               ;
    WebFormat:                               TWebFormat                    ;
    WebFormatAndFilter:                      TWebFormatAndFilter           ;
    WebFormat_SF:                            TWebFormat_SF                 ;

    CountRTIVars:                            TCountRTIVars                 ;
    FetchRTIName:                            TFetchRTIName                 ;
    FetchRTIValue:                           TFetchRTIValue                ;
    GetRTI:                                  TGetRTI                       ;
    GetRTIAsFloat:                           TGetRTIAsFloat                ;
    GetRTIAsInt:                             TGetRTIAsInt                  ;
    IsRTI:                                   TIsRTI                        ;

    CountSessVars:                           TCountSessVars                ;
    FetchSessName:                           TFetchSessName                ;
    FetchSessValue:                          TFetchSessValue               ;
    GetSess:                                 TGetSess                      ;
    GetSessAsFloat:                          TGetSessAsFloat               ;
    GetSessAsInt:                            TGetSessAsInt                 ;
    IsSess:                                  TIsSess                       ;
    SessDestroy:                             TSessDestroy                  ;
    SetSess:                                 TSetSess                      ;
    SetSessAsFloat:                          TSetSessAsFloat               ;
    SetSessAsInt:                            TSetSessAsInt                 ;
    UnsetSess:                               TUnsetSess                    ;

    FetchUpfileName:                         TFetchUpfileName              ;
    GetUpFileName:                           TGetUpFileName                ;
    GetUpFileSize:                           TGetUpFileSize                ;
    GetUpFileType:                           TGetUpFileType                ;
    CountUpFiles:                            TCountUpFiles                 ;
    IsUpFile:                                TIsUpFile                     ;
    SaveUpFile:                              TSaveUpFile                   ;

    CountWebVars:                            TCountWebVars                 ;
    FetchWebVarName:                         TFetchWebVarName              ;
    FetchWebVarValue:                        TFetchWebVarValue             ;
    GetWebVar:                               TGetWebVar                    ;
    GetWebVar_S:                             TGetWebVar_S                  ;
    GetWebVarAsFloat:                        TGetWebVarAsFloat             ;
    GetWebVarAsInt:                          TGetWebVarAsInt               ;
    SetWebVar:                               TSetWebVar                    ;
    SetWebVarAsFloat:                        TSetWebVarAsFloat             ;
    SetWebVarAsInt:                          TSetWebVarAsInt               ;
    IsWebVar:                                TIsWebVar                     ;
    UnsetWebVar:                             TUnsetWebVar                  ;

    LineEndToBR:                             TLineEndToBR                  ;
    RandomStr:                               TRandomStr                    ;
    XORCrypt:                                TXORCrypt                     ;

    ThrowWebError:                           TThrowWebError                ;

// END PUBLIC FUNCTION/PROCEDURE VAR DECLARATIONS
{------------------------------------------------------------------------------}


implementation


uses
  substrings,
  pwuenvvar,
  pwuconfig,
  StrWrap1, // string functions
 {$ifdef fpc}DynLibs, {$endif} // getprocaddress, loadlibrary
 {$ifdef windows}windows{$endif}
 {$ifdef unix}baseunix{$endif} ;

var
  ProcName: string;
 {$ifdef fpc}
  MainLibHandle: TLibHandle;
 {$else}
  MainLibHandle: THandle; 
 {$endif}


{ Throw an error and display it in the web browser telling user exact problem }
procedure ThrowLibError(const ErrMessage: string);
begin
  writeln('Content-Type: text/html'); //must have a header since not init yet
  writeln;
  writeln( 'ERR ' + ErrMessage);
  halt;
end;



{ To save executable size, these are declared as variables instead of constants.
  Constants make the CGI program significantly larger if used plenty.}
var
  ProcErr: string;
  LibPath: string;
  CfgPath: string;  


initialization

 {$ifdef FORCE_DEBUG}
  WriteLn('Content-Type: text/html'); //must have a header since not init yet
  WriteLn;
  writeln('NOTE: CGI PROGRAM IS IN SPECIAL DEBUGGING MODE');
  writeln('<hr>');
 {$endif}


{----- Get config file data -----------------------------------------------}
  CfgPath:= pwuconfig.GetCfgPath;
  if CfgPath = '' then ThrowLibError('1B:see docs'); // config not found
  { config file must contain path to library on the first line #/path/library.so }
  LibPath:= GetLn1(CfgPath);
  if pos('#', LibPath) = 1 then delete(LibPath,1,1)   // delete pound sign 
  else 
  begin
  {$I inc\debug1.inc}                                                            // LUFDOC: ERROR# 0A: PWU config file incorrect, pound sign must be first character
  end;

  { check for VERSION (pwu-1.X.X.X) in PWU.conf on Line1. This stops incorrect 
    old 1.5.x config files or incompatible DLL's, i.e 1.7.x  }
  if (pos(PWU_VERSION, LibPath) = 0) or (LibPath = '') then ThrowLibError('0B:see docs');  // LUFDOC: ERROR# 0B: PWU config file incorrect, library path or pwu DLL is missing in path, or path is empty

  // replace any macros in config file library path  
  LibPath:= substrreplace(LibPath, '$DOCROOT', pwuenvvar.GetEnvVar('DOCUMENT_ROOT'));


{----- Load Lib ---------------------------------------------------------------}
  MainLibHandle:= dynlibs.LoadLibrary(LibPath);   //load lib before CGI program runs
  {$I inc\Debug_LoadLib.inc}

{----- Set up a special shared memory manager ---------------------------------}
  GetMemoryManager(OldMemMan); //store old memory manager
  {$I inc\Debug_MemMan.inc}
  pointer(GetMemMan):= (GetProcAddress(MainLibHandle, 'GetSharedMemMan'));
 { Get the shared memory manager which is stored in the library itself }
  GetMemMan(GottenMemMan);
                                                                               // FEB 12 memory issue below
 { Set gotten memory manager up before import *any* functions from library. }
  SetMemoryManager(GottenMemMan);
                                                                                 // FEB 12 memory issue above
{----- Grab each procedure/function from PSP/PWU API --------------------------}

  pointer(CountCGIVars)          := (GetProcAddress(MainLibHandle, 'CountCGIVars'));
  {$I inc\Debug_CountCGIVars.inc}
  pointer(GetCGIVar)             := (GetProcAddress(MainLibHandle, 'GetCGIVar'));
  //{$I Debug_GetCGIVar.inc} //todo
  pointer(GetCGIVar_S)           := (GetProcAddress(MainLibHandle, 'GetCGIVar_S'));
  //{$I Debug_GetCGIVar_S.inc} //todo
  pointer(GetCGIVarAsFloat)      := (GetProcAddress(MainLibHandle, 'GetCGIVarAsFloat'));
  //{$I Debug_GetCGIVarAsFloat.inc} //todo
  pointer(GetCGIVarAsInt)        := (GetProcAddress(MainLibHandle, 'GetCGIVarAsInt'));
  //{$I Debug_GetCGIVarAsInt.inc} //todo
  pointer(GetCGIVar_SafeHTML)    := (GetProcAddress(MainLibHandle, 'GetCGIVar_SafeHTML'));
  //{$I Debug_GetCGIVar_SafeHTML.inc} //todo
  pointer(FetchCGIVarName)       := (GetProcAddress(MainLibHandle, 'FetchCGIVarName'));
  //{$I Debug_FetchCGIVarName.inc} //todo
  pointer(FetchCGIVarValue)      := (GetProcAddress(MainLibHandle, 'FetchCGIVarValue'));
  //{$I Debug_FetchCGIVarValue.inc} //todo
  pointer(IsCgiVar)              := (GetProcAddress(MainLibHandle, 'IsCgiVar'));
  //{$I Debug_IsCgiVar.inc} //todo
  pointer(GetCGIVar_SF)          := (GetProcAddress(MainLibHandle, 'GetCGIVar_SF'));
  //{$I Debug_GetCGIVar_SF.inc} //todo
  pointer(CountCookies)          := (GetProcAddress(MainLibHandle, 'CountCookies')) ;
  //{$I Debug_CountCookies.inc} //todo
  pointer(FetchCookieName)       := (GetProcAddress(MainLibHandle, 'FetchCookieName'));
  //{$I Debug_FetchCookieName.inc} //todo
  pointer(FetchCookieValue)      := (GetProcAddress(MainLibHandle, 'FetchCookieValue'));
  //{$I Debug_FetchCookieValue.inc} //todo
  pointer(GetCookie)             := (GetProcAddress(MainLibHandle, 'GetCookie'));
  //{$I Debug_GetCookie.inc} //todo
  pointer(GetCookieAsFloat)      := (GetProcAddress(MainLibHandle, 'GetCookieAsFloat'));
  //{$I Debug_GetCookieAsFloat.inc} //todo
  pointer(GetCookieAsInt)        := (GetProcAddress(MainLibHandle, 'GetCookieAsInt'));
  //{$I Debug_GetCookieAsInt.inc} //todo                                  
  pointer(IsCookie)              := (GetProcAddress(MainLibHandle, 'IsCookie'));
  //{$I Debug_IsCookie.inc} //todo
  pointer(SetCookie)             := (GetProcAddress(MainLibHandle, 'SetCookie'));
  //{$I Debug_SetCookie.inc} //todo
  pointer(SetCookieAsFloat)      := (GetProcAddress(MainLibHandle, 'SetCookieAsFloat'));
  //{$I Debug_SetCookieAsFloat.inc} //todo
  pointer(SetCookieAsInt)        := (GetProcAddress(MainLibHandle, 'SetCookieAsInt'));
  //{$I Debug_SetCookieAsInt.inc} //todo
  pointer(SetCookieEx)           := (GetProcAddress(MainLibHandle, 'SetCookieEx'));
  //{$I Debug_SetCookieEx.inc} //todo
  pointer(SetCookieAsFloatEx)    := (GetProcAddress(MainLibHandle, 'SetCookieAsFloatEx'));
  //{$I Debug_SetCookieAsFloatEx.inc} //todo
  pointer(SetCookieAsIntEx)      := (GetProcAddress(MainLibHandle, 'SetCookieAsIntEx'));
  //{$I Debug_SetCookieAsIntEx.inc} //todo
  pointer(UnsetCookie)           := (GetProcAddress(MainLibHandle, 'UnsetCookie'));
  //{$I Debug_UnsetCookie.inc} //todo
  pointer(UnsetCookieEx)         := (GetProcAddress(MainLibHandle, 'UnsetCookieEx'));
  //{$I Debug_UnsetCookieEx.inc} //todo
  pointer(CountWebConfigVars)    := (GetProcAddress(MainLibHandle, 'CountWebConfigVars'));
  //{$I Debug_CountWebConfigVars.inc} //todo
  pointer(FetchWebConfigVarName) := (GetProcAddress(MainLibHandle, 'FetchWebConfigVarName'));
  //{$I Debug_FetchWebConfigVarName.inc} //todo
  pointer(FetchWebConfigVarValue) := (GetProcAddress(MainLibHandle, 'FetchWebConfigVarValue'));
  //{$I Debug_FetchWebConfigVarValue.inc} //todo
  pointer(GetWebConfigVar)       := (GetProcAddress(MainLibHandle, 'GetWebConfigVar'));
  //{$I Debug_GetWebConfigVar.inc} //todo
  pointer(IsWebConfigVar)        := (GetProcAddress(MainLibHandle, 'IsWebConfigVar'));
  //{$I Debug_IsWebConfigVar.inc} //todo
  pointer(SetWebConfigVar)       := (GetProcAddress(MainLibHandle, 'SetWebConfigVar'));
  //{$I Debug_SetWebConfigVar.inc} //todo
//  CountEnvVars          := TCountEnvVars(GetProcAddress(MainLibHandle, 'CountEnvVars'));
  //{$I Debug_CountEnvVars.inc} //todo
//  FetchEnvVarName       := TFetchEnvVarName(GetProcAddress(MainLibHandle, 'FetchEnvVarName'));
  //{$I Debug_FetchEnvVarName.inc} //todo
//  FetchEnvVarValue      := TFetchEnvVarValue(GetProcAddress(MainLibHandle, 'FetchEnvVarValue'));
  //{$I Debug_FetchEnvVarValue.inc} //todo

//  pointer(GetEnvVar)             := GetProcAddress(MainLibHandle, 'GetEnvVar'); //MOVED TO PWUENVVAR.PAS
  //{$I Debug_GetEnvVar.inc} //todo
  pointer(IsEnvVar)              := GetProcAddress(MainLibHandle, 'IsEnvVar');
  //{$I Debug_IsEnvVar.inc} //todo
  pointer(FilterHTML)            := GetProcAddress(MainLibHandle, 'FilterHTML');
  //{$I Debug_FilterHTML.inc} //todo
  pointer(FilterHTML_S)          := GetProcAddress(MainLibHandle, 'FilterHTML_S');
  //{$I Debug_FilterHTML_S.inc} //todo
  pointer(TrimBadChars)          := GetProcAddress(MainLibHandle, 'TrimBadChars');
  //{$I Debug_TrimBadChars.inc} //todo
  pointer(TrimBadChars_file)     := GetProcAddress(MainLibHandle, 'TrimBadChars_file');
  //{$I Debug_TrimBadChars_file.inc} //todo
  pointer(TrimBadChars_dir)      := GetProcAddress(MainLibHandle, 'TrimBadChars_dir');
  //{$I Debug_TrimBadChars_dir.inc} //todo
  pointer(TrimBadChars_S)        := GetProcAddress(MainLibHandle, 'TrimBadChars_S');
  //{$I Debug_TrimBadChars_S.inc} //todo
  pointer(CountWebheaders)       := GetProcAddress(MainLibHandle, 'CountWebheaders');
  //{$I Debug_CountWebheaders.inc} //todo
  pointer(FetchWebHeaderName)    := GetProcAddress(MainLibHandle, 'FetchWebHeaderName');
  //{$I Debug_FetchWebHeaderName.inc} //todo
  pointer(FetchWebHeaderValue)   := GetProcAddress(MainLibHandle, 'FetchWebHeaderValue');
  //{$I Debug_FetchWebHeaderValue.inc} //todo
  pointer(GetWebHeader)          := GetProcAddress(MainLibHandle, 'GetWebHeader');
  //{$I Debug_GetWebHeader.inc} //todo
  pointer(IsWebHeader)           := GetProcAddress(MainLibHandle, 'IsWebHeader');
  //{$I Debug_IsWebHeader.inc} //todo
  pointer(SetWebHeader)          := GetProcAddress(MainLibHandle, 'SetWebHeader');
  //{$I Debug_SetWebHeader.inc} //todo
  pointer(UnsetWebHeader)        := GetProcAddress(MainLibHandle, 'UnsetWebHeader');
  //{$I Debug_UnsetWebHeader.inc} //todo
  pointer(PutWebHeader)          := GetProcAddress(MainLibHandle, 'PutWebHeader');
  //{$I Debug_PutWebHeader.inc} //todo
  pointer(GetMimeType)           := GetProcAddress(MainLibHandle, 'GetMimeType');
  //{$I Debug_GetMimeType.inc} //todo
  pointer(WebWrite)              := GetProcAddress(MainLibHandle, 'WebWrite');
  //{$I Debug_WebWrite.inc} //todo
  pointer(WebWriteA)              := GetProcAddress(MainLibHandle, 'WebWriteA');
  //{$I Debug_WebWriteA.inc} //todo
  pointer(WebWriteF)             := GetProcAddress(MainLibHandle, 'WebWriteF');
  //{$I Debug_WebWriteF.inc} //todo
  pointer(WebWriteFF)            := GetProcAddress(MainLibHandle, 'WebWriteFF');
  //{$I Debug_WebWriteFF.inc} //todo
  pointer(WebWriteF_Fi)          := GetProcAddress(MainLibHandle, 'WebWriteF_Fi');
  //{$I Debug_WebWriteF_Fi.inc} //todo
  pointer(WebWriteLn)            := GetProcAddress(MainLibHandle, 'WebWriteLn');
  //{$I Debug_WebWriteLn.inc} //todo
  pointer(WebWriteLnF)           := GetProcAddress(MainLibHandle, 'WebWriteLnF');
  //{$I Debug_WebWriteLnF.inc} //todo
  pointer(WebWriteLnFF)          := GetProcAddress(MainLibHandle, 'WebWriteLnFF');
  //{$I Debug_WebWriteLnFF.inc} //todo
  pointer(WebWriteLnF_Fi)        := GetProcAddress(MainLibHandle, 'WebWriteLnF_Fi');
  //{$I Debug_WebWriteLnF_Fi.inc} //todo
  pointer(WebFileOut)            := GetProcAddress(MainLibHandle, 'WebFileOut');
  //{$I Debug_WebFileOut.inc} //todo
  pointer(WebBufferOut)          := GetProcAddress(MainLibHandle, 'WebBufferOut');
  //{$I Debug_WebBufferOut.inc} //todo
  pointer(WebResourceOut)        := GetProcAddress(MainLibHandle, 'WebResourceOut');
  //{$I Debug_WebResourceOut.inc} //todo
  pointer(WebTemplateOut)        := GetProcAddress(MainLibHandle, 'WebTemplateOut');
  //{$I Debug_WebTemplateOut.inc} //todo
  pointer(WebTemplateRaw)        := GetProcAddress(MainLibHandle, 'WebTemplateRaw');
  //{$I Debug_WebTemplateRaw.inc} //todo
  pointer(WebFormat)             := GetProcAddress(MainLibHandle, 'WebFormat');
  //{$I Debug_WebFormat.inc} //todo
  pointer(WebFormatAndFilter)    := GetProcAddress(MainLibHandle, 'WebFormatAndFilter');
  //{$I Debug_WebFormatAndFilter.inc} //todo
  pointer(WebFormat_SF)          := GetProcAddress(MainLibHandle, 'WebFormat_SF');
  //{$I Debug_WebFormat_SF.inc} //todo
  pointer(CountRTIVars)          := GetProcAddress(MainLibHandle, 'CountRTIVars');
  //{$I Debug_CountRTIVars.inc} //todo
  pointer(FetchRTIName)          := GetProcAddress(MainLibHandle, 'FetchRTIName');
  //{$I Debug_FetchRTIName.inc} //todo
  pointer(FetchRTIValue)         := GetProcAddress(MainLibHandle, 'FetchRTIValue');
  //{$I Debug_FetchRTIValue.inc} //todo
  pointer(GetRTI)                := GetProcAddress(MainLibHandle, 'GetRTI');
  //{$I Debug_GetRTI.inc} //todo
  pointer(GetRTIAsFloat)         := GetProcAddress(MainLibHandle, 'GetRTIAsFloat');
  //{$I Debug_GetRTIAsFloat.inc} //todo
  pointer(GetRTIAsInt)           := GetProcAddress(MainLibHandle, 'GetRTIAsInt');
  //{$I Debug_GetRTIAsInt.inc} //todo
  pointer(IsRTI)                 := GetProcAddress(MainLibHandle, 'IsRTI');
  //{$I Debug_IsRTI.inc} //todo
  pointer(CountSessVars)         := GetProcAddress(MainLibHandle, 'CountSessVars');
  //{$I Debug_CountSessVars.inc} //todo
  pointer(FetchSessName)         := GetProcAddress(MainLibHandle, 'FetchSessName');
  //{$I Debug_FetchSessName.inc} //todo
  pointer(FetchSessValue)        := GetProcAddress(MainLibHandle, 'FetchSessValue');
  //{$I Debug_FetchSessValue.inc} //todo
  pointer(GetSess)               := GetProcAddress(MainLibHandle, 'GetSess');
  //{$I Debug_GetSess.inc} //todo
  pointer(GetSessAsFloat)        := GetProcAddress(MainLibHandle, 'GetSessAsFloat');
  //{$I Debug_GetSessAsFloat.inc} //todo
  pointer(GetSessAsInt)          := GetProcAddress(MainLibHandle, 'GetSessAsInt');
  //{$I Debug_GetSessAsInt.inc} //todo
  pointer(IsSess)                := GetProcAddress(MainLibHandle, 'IsSess');
  //{$I Debug_IsSess.inc} //todo
  pointer(SessDestroy)           := GetProcAddress(MainLibHandle, 'SessDestroy');
  //{$I Debug_SessDestroy.inc} //todo
  pointer(SetSess)               := GetProcAddress(MainLibHandle, 'SetSess');
  //{$I Debug_SetSess.inc} //todo
  pointer(SetSessAsFloat)        := GetProcAddress(MainLibHandle, 'SetSessAsFloat');
  //{$I Debug_SetSessAsFloat.inc} //todo
  pointer(SetSessAsInt)          := GetProcAddress(MainLibHandle, 'SetSessAsInt');
  //{$I Debug_SetSessAsInt.inc} //todo
  pointer(UnsetSess)             := GetProcAddress(MainLibHandle, 'UnsetSess');
  //{$I Debug_UnsetSess.inc} //todo
  pointer(FetchUpfileName)       := GetProcAddress(MainLibHandle, 'FetchUpfileName');
  //{$I Debug_FetchUpfileName.inc} //todo
  pointer(GetUpFileName)         := GetProcAddress(MainLibHandle, 'GetUpFileName');
  //{$I Debug_GetUpFileName.inc} //todo
  pointer(GetUpFileSize)         := GetProcAddress(MainLibHandle, 'GetUpFileSize');
  //{$I Debug_GetUpFileSize.inc} //todo
  pointer(GetUpFileType)         := GetProcAddress(MainLibHandle, 'GetUpFileType');
  //{$I Debug_GetUpFileType.inc} //todo
  pointer(CountUpFiles)          := GetProcAddress(MainLibHandle, 'CountUpFiles');
  //{$I Debug_CountUpFiles.inc} //todo
  pointer(IsUpFile)              := GetProcAddress(MainLibHandle, 'IsUpFile');
  //{$I Debug_IsUpFile.inc} //todo
  pointer(SaveUpFile)            := GetProcAddress(MainLibHandle, 'SaveUpFile');
  //{$I Debug_SaveUpFile.inc} //todo
  pointer(CountWebVars)          := GetProcAddress(MainLibHandle, 'CountWebVars');
  //{$I Debug_CountWebVars.inc} //todo
  pointer(FetchWebVarName)       := GetProcAddress(MainLibHandle, 'FetchWebVarName');
  //{$I Debug_FetchWebVarName.inc} //todo
  pointer(FetchWebVarValue)      := GetProcAddress(MainLibHandle, 'FetchWebVarValue');
  //{$I Debug_FetchWebVarValue.inc} //todo
  pointer(GetWebVar)             := GetProcAddress(MainLibHandle, 'GetWebVar');
  //{$I Debug_GetWebVar.inc} //todo
  pointer(GetWebVar_S)           := GetProcAddress(MainLibHandle, 'GetWebVar_S');
  //{$I Debug_GetWebVar_S.inc} //todo
  pointer(GetWebVarAsFloat)      := GetProcAddress(MainLibHandle, 'GetWebVarAsFloat');
  //{$I Debug_GetWebVarAsFloat.inc} //todo
  pointer(GetWebVarAsInt)        := GetProcAddress(MainLibHandle, 'GetWebVarAsInt');
  //{$I Debug_GetWebVarAsInt.inc} //todo
  pointer(SetWebVar)             := GetProcAddress(MainLibHandle, 'SetWebVar');
  //{$I Debug_SetWebVar.inc} //todo
  pointer(SetWebVarAsFloat)      := GetProcAddress(MainLibHandle, 'SetWebVarAsFloat');
  //{$I Debug_SetWebVarAsFloat.inc} //todo
  pointer(SetWebVarAsInt)        := GetProcAddress(MainLibHandle, 'SetWebVarAsInt');
  //{$I Debug_SetWebVarAsInt.inc} //todo
  pointer(IsWebVar)              := GetProcAddress(MainLibHandle, 'IsWebVar');
  //{$I Debug_IsWebVar.inc} //todo
  pointer(UnsetWebVar)           := GetProcAddress(MainLibHandle, 'UnsetWebVar');
  //{$I Debug_UnsetWebVar.inc} //todo
  pointer(LineEndToBR)           := GetProcAddress(MainLibHandle, 'LineEndToBR');
  //{$I Debug_LineEndToBR.inc} //todo
  pointer(RandomStr)             := GetProcAddress(MainLibHandle, 'RandomStr');
  //{$I Debug_RandomStr.inc} //todo
  pointer(XORCrypt)              := GetProcAddress(MainLibHandle, 'XORCrypt');
  //{$I Debug_XORCrypt.inc} //todo
  pointer(ThrowWebError)         := GetProcAddress(MainLibHandle, 'ThrowWebError');
  //{$I Debug_ThrowWebError.inc} //todo


finalization
{------------------------- Unload PSP/PWU API ---------------------------------}
  if MainLibHandle <> NilHandle then   // free library before CGI program stops
  begin
    FreeLibrary(MainLibHandle)
   //{$I DebugFreeLib.inc} //todo
  end;
  
  SetMemoryManager(OldMemMan); // restore original memory manager

end.



