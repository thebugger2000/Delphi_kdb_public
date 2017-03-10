unit KDB;

Interface

uses Classes, System.SysUtils, Windows;
//put the delphi equivalent header guards around all of code if necessary
{$R *.res}
const DLLName = 'c.dll';
//{$LINK 'f:\documents\cobra\APIs\KDB\c.obj'}
{$DEFINE KVER30}
type
  kType = (
     ktError = -128  //-   char*   4 or 8   x->s
    ,ktMixedList = 0  //-   K   -   kK
    ,ktBoolean = -1  //KB   char   1   kG
    ,ktBooleanList = 1
    ,ktGuid = -2  //UU   U   16   kU
    ,ktGuidList = 2
    ,ktByte = -4  //KG   char   1   kG
    ,ktByteList = 4
    ,ktShort = -5  //KH   short   2   kH
    ,ktShortList = 5
    ,ktInt = -6  //KI   int   4   kI
    ,ktIntList = 6
    ,ktLong = -7  //KJ   int64_t   8   kJ
    ,ktLongList = 7
    ,ktReal = -8  //KE   float   4   kE
    ,ktRealList = 8
    ,ktFloat = -9  //KF   double   8   kF
    ,ktFloatList = 9
    ,ktChar = -10  //KC   char   1   kC
    ,ktCharList = 10
    ,ktSymbol = -11  //KS   char*   4 or 8   kS
    ,ktSymbolList = 11
    ,ktTimeStamp = -12  //KP   int64_t   8   kJ (nanoseconds from 2000.01.01)
    ,ktTimeStampList = 12
    ,ktMonth = -13  //KM   int   4   kI (months from 2000.01.01)
    ,ktMonthList = 13
    ,ktDate = -14
    ,ktDateList = 14 //KD   int   4   kI (days from 2000.01.01)
    ,ktDateTime = -15  //KZ   double   8   kF (days from 2000.01.01)
    ,ktDateTimeList = 15
    ,ktTimeSpan = -16  //KN   int64_t   8   kJ (nanoseconds)
    ,ktTimeSpanList = 16
    ,ktMinute = -17  //KU   int   4   kI
    ,ktMinuteList = 17
    ,ktSecond = -18  //KV   int   4   kI
    ,ktSecondList = 18
    ,ktTime = -19  //KT   int   4   kI (milliseconds)
    ,ktTimeList = 19
    ,ktTableFlip = 98  //XT   -   -   x->k
    ,ktDictTable = 99  //XD   -   -   kK(x)[0] for keys and kK(x)[1] for values
    ,ktLambda = 100
    ,ktUnaryPrimitive = 101
    ,ktBinaryPrimitive = 102
    ,ktTernaryOperator = 103
    ,ktProjection = 104
    ,ktComposition = 105
    ,kt106 = 106 //  f'
    ,kt107 = 107 // f/ 107
    ,kt108 = 108 // f\ 108
    ,kt109 = 109 // f': = 109
    ,kt110 = 110 // f/: = 110
    ,kt111 = 111 // f\: = 111
    ,kt112 = 112 // dynamic load 112
    );
  kTypeArray = TArray<kType>;

  TU = packed record
  public
    type
      P = ^TU;
  Public
    g: array[0..15] of Byte { unsigned char[16] };
    class var _Null: TU;
    class constructor Create;
    class operator Implicit(const Value: TU): TGUID;
    class operator Implicit(const Value: TGUID): TU;
    class operator Implicit(const Value: String): TU;
    class operator Implicit(const Value: TU): String;
    class operator Implicit(const Value: AnsiString): TU;
    class operator Implicit(const Value: pAnsiChar): TU;
    class operator Implicit(const Value: TU): AnsiString;
    class operator Equal(const V1,V2: TU): Boolean;
    class operator NotEqual(const V1,V2: TU): Boolean;
  public
    function IsNull: Boolean; {$IFNDEF DEBUG} inline; {$ENDIF}
    procedure SetNull; {$IFNDEF DEBUG} inline; {$ENDIF}
  end;

  Tk0 = packed record
  public
    type
      p = ^Tk0;
      TG = Byte { unsigned char };
      TH = Smallint { short };
      TI = Integer { int };
      TJ = Int64 { long long };
      TE = Single { float };
      TF = Double { double };
      TC = AnsiChar;
      TS = pAnsiChar { char* };
      TV = Pointer; { void* }
      // Mixed List
      pkKArr = ^tkKArr;
      tkKArr = array[0..$7FFFFFFF DIV Sizeof(p)-20] of p;

      // Guid LIst
      pkUArr = ^tkUArr;
      tkUArr = array[0..$7FFFFFFF DIV Sizeof(TU)-20] of TU;
      // Byte List
      pkGArr = ^tkGArr;
      tkGArr = array[0..$7FFFFFFF DIV Sizeof(Byte)-20] of TG;
      // Short List
      pkHArr = ^tkHArr;
      tkHArr = array[0..$7FFFFFFF DIV Sizeof(SmallInt)-20] of TH;
      // Int List
      pkIArr = ^tkIArr;
      tkIArr = array[0..$7FFFFFFF DIV Sizeof(Integer)-20] of TI;
      // Long List
      pkJArr = ^tkJArr;
      tkJArr = array[0..$7FFFFFFF DIV Sizeof(Int64)-20] of TJ;
      // Real List
      pkEArr = ^tkEArr;
      tkEArr = array[0..$7FFFFFFF DIV Sizeof(Single)-20] of TE;
      // Float List
      pkFArr = ^tkFArr;
      tkFArr = array[0..$7FFFFFFF DIV Sizeof(Double)-20] of TF;
      // Char List
      pkCArr = ^tkCArr;
      tkCArr = array[0..$7FFFFFFF DIV Sizeof(AnsiChar)-20] of TC;
      // Symbol LIst
      pkSArr = ^tkSArr;
      tkSArr = array[0..$7FFFFFFF DIV Sizeof(pAnsiChar)-20] of TS;

      Excpt = class(Exception);
    const _BinaryPrimitive: array[0..2] of AnsiChar = (':','+','-');
    const _DLLRName = 'KDBDLL';
    class var _DateBase: TDateTime;
//    class var _LOldNotifyHook, _LOldFailureHook: TDelayedLoadHook;
//    class var _DLL: PBTMemoryModule;
//    class var _pDLL: Pointer;
//    class var _hDLL: THandle;
//    class function MyDelayedLoadHook(dliNotify: dliNotification; pdli: PDelayLoadInfo): Pointer; stdcall; static;
    class constructor Create;
    class destructor Destroy;
  private
    function GetkUArr: pkUArr; {$IFNDEF DEBUG} inline; {$ENDIF}
    function GetkGArr: pkGArr; {$IFNDEF DEBUG} inline; {$ENDIF}
    function GetkHArr: pkHArr; {$IFNDEF DEBUG} inline; {$ENDIF}
    function GetkIArr: pkIArr; {$IFNDEF DEBUG} inline; {$ENDIF}
    function GetkJArr: pkJArr; {$IFNDEF DEBUG} inline; {$ENDIF}
    function GetkEArr: pkEArr; {$IFNDEF DEBUG} inline; {$ENDIF}
    function GetkFArr: pkFArr; {$IFNDEF DEBUG} inline; {$ENDIF}
    function GetkCArr: pkCArr; {$IFNDEF DEBUG} inline; {$ENDIF}
    function GetkSArr: pkSArr; {$IFNDEF DEBUG} inline; {$ENDIF}
    function GetkKArr: pkKArr; {$IFNDEF DEBUG} inline; {$ENDIF}
  public
    property kKArr: pkKArr read GetkKArr;
    property kUArr: pkUArr read GetkUArr;
    property kGArr: pkGArr read GetkGArr;
    property kHArr: pkHArr read GetkHArr;
    property kIArr: pkIArr read GetkIArr;
    property kJArr: pkJArr read GetkJArr;
    property kEArr: pkEArr read GetkEArr;
    property kFArr: pkFArr read GetkFArr;
    property kCArr: pkCArr read GetkCArr;
    property kSArr: pkSArr read GetkSArr;
  public
{$IFDEF KVER30}
    m: ShortInt { signed char };
    a: ShortInt { signed char };
    t: kType;//ShortInt { signed char };
    u: ShortInt { pAnsiChar { char* };
    r: Integer { int };
{$ELSE}
    r: Integer;
    t: kType;//ShortInt;
    u: SmallInt;
{$ENDIF}
    case byte of
      0:(g: TG;);
      1:(h: TH;);
      2:(i: TI;);
      3:(j: TJ;);
      4:(e: TE;);
      5:(f: TF;);
      6:(s: TS;);
      7:(k: p { struct* };);
      8:( { struct }
         n: Int64 { long long };
         case byte of
           0: (G0: array[0..0] of Byte { unsigned char[1] };);
           1: (UU: TU);
{          Generated Range Check Error when debuging
           1: (kKArr: tkKArr;);
           2: (kUArr: tkUArr;);
           3: (kGArr: tkGArr;);
           4: (kHArr: tkIArr;);
           5: (kIArr: tkIArr;);
           7: (kJArr: tkJArr;);
           8: (kEArr: tkEArr;);
           9: (kFArr: tkFArr;);
           10: (kCArr: tkCArr;);
           11: (kSArr: tkSArr;);
           12: (kVArr: tkVArr;);
}
         );
  end;
  pK = Tk0.p;


const nh = SmallInt($8000);
const wh = $7FFF;
const ni = Integer($80000000);
const wi = $7FFFFFFF;
const nj = $8000000000000000;
const wj = $7FFFFFFFFFFFFFFF;
const nf: Double = 0; // Must be re assigned
const wf: Double = 0; // Must be re assigned
const ne: Single = 0; // Must be re assigned
const we: Single = 0; // Must be re assigned


function ku(Param0: TU): pK; cdecl; external DLLName name 'ku' delayed;
function ktn(Param0: kType{ int }; Param1: Int64 { long long }): pK; cdecl; external DLLName name 'ktn' delayed;
function kpn(Param0: pAnsiChar { char* }; Param1: Int64 { long long }): pK; cdecl; external DLLName name 'kpn' delayed;

function setm(Param0: Integer { int }): Integer; cdecl; external DLLName name 'setm' delayed;

procedure m9; cdecl; external DLLName name 'm9' delayed;

function khpun(const Param0: pAnsiChar { char* }; Param1: Integer { int }; const Param2: pAnsiChar { char* }; Param3: Integer { int }): Integer; cdecl; external DLLName name 'khpun' delayed;
function khpu(const Param0: pAnsiChar { char* }; Param1: Integer { int }; const Param2: pAnsiChar { char* }): Integer; cdecl; external DLLName name 'khpu' delayed;
function khp(const Param0: pAnsiChar { char* }; Param1: Integer { int }): Integer; cdecl; external DLLName name 'khp' delayed;
function okx(Param0: pK): Integer; cdecl; external DLLName name 'okx' delayed;
function ymd(Param0: Integer { int }; Param1: Integer { int }; Param2: Integer { int }): Integer; cdecl; external DLLName name 'ymd' delayed;
function dj(Param0: Integer { int }): Integer; cdecl; external DLLName name 'dj' delayed;

procedure r0(Param0: pK); cdecl; external DLLName name 'r0' delayed;
//procedure sd0(Param0: Integer { int }); cdecl; external DLLName name 'sd0';
procedure kclose(Param0: Integer { int }); cdecl; external DLLName name 'kclose' delayed;

function sn(Param0: pAnsiChar { char* }; Param1: Integer { int }): pAnsiChar; cdecl; external DLLName name 'sn' delayed;
function ss(Param0: pAnsiChar { char* }): pAnsiChar; cdecl; external DLLName name 'ss' delayed;

function ktj(Param0: kType{ int }; Param1: Int64 { long long }): pK; cdecl; external DLLName name 'ktj' delayed;
function ka(Param0: Integer { int }): pK; cdecl; external DLLName name 'ka' delayed;
function kb(Param0: Integer { int }): pK; cdecl; external DLLName name 'kb' delayed;
function kg(Param0: Integer { int }): pK; cdecl; external DLLName name 'kg' delayed;
function kh(Param0: Integer { int } = nh): pK; cdecl; external DLLName name 'kh' delayed;
function ki(Param0: Integer { int } = ni): pK; cdecl; external DLLName name 'ki' delayed;
function kj(Param0: Int64 { long long } = nj): pK; cdecl; external DLLName name 'kj' delayed;
function ke(Param0: Double { double }): pK; cdecl; external DLLName name 'ke' delayed;
function kf(Param0: Double { double }): pK; cdecl; external DLLName name 'kf' delayed;
function kc(Param0: Integer { int }): pK; cdecl; external DLLName name 'kc' delayed;
function ks(Param0: pAnsiChar { char* }): pK; cdecl; external DLLName name 'ks' delayed;
function kd(Param0: Integer { int }): pK; cdecl; external DLLName name 'kd' delayed;
function kz(Param0: Double { double }): pK; cdecl; external DLLName name 'kz' delayed;
function kt(Param0: Integer { int }): pK; cdecl; external DLLName name 'kt' delayed;
function sd1(Param0: Integer { int }; Param1: pK; Param2: Pointer): pK; cdecl; external DLLName name 'sd1' delayed;
function dl(f: Pointer { void* }; Param1: Integer { int }): pK; cdecl; external DLLName name 'dl' delayed;
function knk(Param0: Integer { int }): pK; varargs {...}; cdecl; external DLLName name 'knk' delayed;
function kp(Param0: pAnsiChar { char* }): pK; cdecl; external DLLName name 'kp' delayed;
function ja(Param0: pK; Param1: Pointer { void* }): pK; cdecl; external DLLName name 'ja' delayed;
function js(Param0: pK; Param1: pAnsiChar { char* }): pK; cdecl; external DLLName name 'js' delayed;
function jk(Param0: pK; Param1: pK): pK; cdecl; external DLLName name 'jk' delayed;
function jv(k: pK; Param1: pK): pK; cdecl; external DLLName name 'jv' delayed;
function k(Param0: Integer { int }; const Param1: pAnsiChar { char* }): pK; varargs {...}; cdecl; external DLLName name 'k' delayed;
function xT(Param0: pK): pK; cdecl; external DLLName name 'xT' delayed;
function xD(Param0: pK; Param1: pK): pK; cdecl; external DLLName name 'xD' delayed;
function ktd(Param0: pK): pK; cdecl; external DLLName name 'ktd' delayed;
function r1(Param0: pK): pK; cdecl; external DLLName name 'r1' delayed;
function krr(const Param0: pAnsiChar { char* }): pK; cdecl; external DLLName name 'krr' delayed;
function orr(const Param0: pAnsiChar { char* }): pK; cdecl; external DLLName name 'orr' delayed;
function dot(Param0: pK; Param1: pK): pK; cdecl; external DLLName name 'dot' delayed;
function b9(Param0: Integer { int }; Param1: pK): pK; cdecl; external DLLName name 'b9' delayed;
function d9(Param0: pK): pK; cdecl; external DLLName name 'd9' delayed;
//function log(Param0: Double): Double; cdecl; external DLLName name 'log';
function kK(Param0: pK): Tk0.pkKArr; inline;

implementation
uses Math;

function SwapEndian32(Value: Cardinal): Cardinal; register;
asm
  bswap eax
end;

function SwapEndian16(Value: Word): Word; register;
asm
  xchg  al, ah
end;

function ImportName(const AProc: TDelayLoadProc): String;
begin
  if AProc.fImportByName then
    Result := AProc.szProcName
  else
    Result := '#' + IntToStr(AProc.dwOrdinal);
end;

function kK(Param0: pK): Tk0.pkKArr;
begin
  Result := @Param0.G0;
end;

{ TU }

class operator TU.Implicit(const Value: TU): TGUID;
begin
  Result := pGUID(@Value)^;

  Result.D1 := SwapEndian32(Result.D1);
  Result.D2 := SwapEndian16(Result.D2);
  Result.D3 := SwapEndian16(Result.D3);
end;

class operator TU.Implicit(const Value: TGUID): TU;
begin
  pGUID(@Result)^ := Value;
  with pGUID(@Result)^ do begin
    D1 := SwapEndian32(D1);
    D2 := SwapEndian16(D2);
    D3 := SwapEndian16(D3);
  end;
end;

class operator TU.Implicit(const Value: String): TU;
var
  AGuid: TGuid;
begin
  if Value = '' then Exit(TU._Null);
  if (Value[1] = '{') and (Value[Length(Value)] = '}') then
    AGuid := StringToGUID(Value)
  else
    AGuid := StringToGUID('{'+Value+'}');
  Result := AGuid;
end;

class operator TU.Implicit(const Value: TU): String;
begin
  if Value.IsNull then Exit('');
  Result := GUIDToString(Value);
  Result := Copy(Result,2,Length(Result)-2);
end;

class operator TU.Implicit(const Value: AnsiString): TU;
begin
 Result := StringToGuid(Value);

end;

class constructor TU.Create;
begin
  FillChar(_Null,Sizeof(_Null),0);
end;

class operator TU.Equal(const V1, V2: TU): Boolean;
begin
  Result := pGUID(@V1)^ = pGUID(@V2)^;
end;

class operator TU.Implicit(const Value: TU): AnsiString;
begin
 Result := GUIDToString(Value);
end;

class operator TU.Implicit(const Value: pAnsiChar): TU;
begin
  Result := StringToGUID(Value);
end;

function TU.IsNull: Boolean;
begin
  Result := Self = _Null;
end;

class operator TU.NotEqual(const V1, V2: TU): Boolean;
begin
  Result := pGUID(@V1)^ <> pGUID(@V2)^;
end;

procedure TU.SetNull;
begin
  Self := _Null;
end;

{ Tk0 }

class constructor Tk0.Create;
var
  RS: TResourceStream;
  FS: TFileStream;
  FileName: String;

begin
   // automaticly save the embeded dll to the local directory
  FileName := ExtractFilePath(ExpandFileName(ParamStr(0)))+DLLName;
  if not FileExists(FileName) then begin
    RS := TResourceStream.Create(HInstance,_DLLRName,RT_RCDATA);
    try
      RS.SaveToFile(FileName);
    finally
      RS.Free;
    end;
  end;
  // calculate the base date for DateTime Conversions once.
  _DateBase := EncodeDate(2000,1,1);
  // Initialize null floats
  pUInt64(@nf)^ := $FFF8000000000000;
  pCardinal(@ne)^ := $FFC00000;
end;

class destructor Tk0.Destroy;
begin
end;


function Tk0.GetkCArr: pkCArr;
begin
  Result := @G0;
end;

function Tk0.GetkEArr: pkEArr;
begin
  Result := @G0;
end;

function Tk0.GetkFArr: pkFArr;
begin
  Result := @G0;
end;

function Tk0.GetkGArr: pkGArr;
begin
  Result := @G0;
end;

function Tk0.GetkHArr: pkHArr;
begin
  Result := @G0;
end;

function Tk0.GetkIArr: pkIArr;
begin
  Result := @G0;
end;

function Tk0.GetkJArr: pkJArr;
begin
  Result := @G0;
end;

function Tk0.GetkKArr: pkKArr;
begin
  Result := @G0;
end;

function Tk0.GetkSArr: pkSArr;
begin
  Result := @G0;
end;

function Tk0.GetkUArr: pkUArr;
begin
  Result := @G0;
end;

end.

