program SampleApp;
// DEBUG only:  Step through code to see it in action there is now output to the screen

{$APPTYPE CONSOLE}

{$R *.res}

uses
  kdb,
  System.DateUtils,
  System.SysUtils;

const
  _Host = '127.0.0.1';
  _Port = 1234;

type
  // We are going to add more methods to the basic structure
  Tk0_Helper = record helper for Tk0
  public
    procedure NoError;
    procedure Release;
  end;

procedure Tk0_Helper.NoError;
begin
  if @Self = nil then
    raise Excpt.Create('NoError: Self is nil');
  if t = ktError then
    raise Excpt.CreateFmt('Error %s',[s]);
end;

procedure Tk0_Helper.Release;
begin
  r0(@Self);
end;

var
  r,v: pK;
  Session: Integer;

function k_(const Command: RawByteString): pK; overload; {$IFNDEF DEBUG} inline; {$ENDIF}
begin
  Result := k(Session,pAnsiChar(Command),nil);
end;

function k_(const Command: RawByteString; Param1: pK): pK; overload; {$IFNDEF DEBUG} inline; {$ENDIF}
begin
  Result := k(Session,pAnsiChar(Command),Param1,nil);
end;

begin
  try
    Session := khp(_Host,_Port);
    if(Session <=0) then
      raise Tk0.Excpt.CreateFmt('Connection error port host<%s> port <%d> make sure q.com has been run locally with "q -p 1234" command line',[_Host,_Port]);
    // First store 2 + 2 in x
    r := k_('x:2+2');
    if r^.t <> ktUnaryPrimitive then
      raise Tk0.Excpt.CreateFmt('Wrong Type %d',[Ord(r^.t)]);
    r^.Release;
    // get value of x
    r := k_('x');
    if r^.t <> ktLong then
      raise Tk0.Excpt.CreateFmt('Wrong Type %d',[Ord(r^.t)]);
    if r^.i <> 4 then
      raise Tk0.Excpt.CreateFmt('Wrong result 2+2 = %d',[r^.i]);
    r^.Release;

    // k parmaters
    // use k types (symbol)
    r := k_('.[`x;();:;]',ks('hello'));
    if r^.t <> ktSymbol then
      raise Tk0.Excpt.CreateFmt('Wrong Type %d',[Ord(r^.t)]);
    if r^.s  <> 'x' then
      raise Tk0.Excpt.CreateFmt('Wrong Result %s',[r^.s]);
    r^.Release;
    // get x
    r := k_('x');
    if r^.t <> ktSymbol then
      raise Tk0.Excpt.CreateFmt('Wrong Type %d',[Ord(r^.t)]);
    if r^.s <> 'hello' then
      raise Tk0.Excpt.CreateFmt('Wrong result 2+2 = %d',[r^.i]);
    r^.Release;

    // Date sample
    // Create kDate Type
    v := ktj(ktMonth,MonthsBetween(StrToDate('03/10/2017'),tk0._DateBase));
    v^.NoError;
    // Store Date in x
    r := k_('.[`x;();:;]',v);
    // v was released by the k function
    r^.NoError;
    r^.Release;
    // Get x value

    r := k_('x');
    if r^.t <> ktMonth then
      raise Tk0.Excpt.CreateFmt('Wrong Type %d',[Ord(r^.t)]);
    if r^.i <> 206 then
      raise Tk0.Excpt.CreateFmt('Month result Type %d',[Ord(r^.i)]);
    r^.Release;

    kclose(Session);
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
