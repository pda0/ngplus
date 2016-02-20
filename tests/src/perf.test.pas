{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Perf.Test;

{$IFNDEF FPC}{$LEGACYIFEND ON}{$ENDIF FPC}

interface

type
  TAbstractPerfTest = class
  protected
    function GetName: string; virtual; abstract;
  public
    procedure Setup(Seq: Integer); virtual; abstract;
    procedure Run; virtual; abstract;
    property Name: string read GetName;
  end;

  TPerfTestResult = record
    CPS: Int64; { Calls per second }
    AvgTime: Double;
  end;

  TPerfTestArray = array of TPerfTestResult;

  TPerfTestRunner = class
  private
    class var FOverhead: Double;
    class procedure Init;
    class procedure BindThread;
    class procedure PrepareCore;
  public
    class procedure Calibration; static;
    class function ScaleCount(Scale: Integer): Int64; static;
    class function RunTests(const PerfTest: TAbstractPerfTest; Seq: Cardinal;
      ScaleStart, ScaleEnd: Int64): TPerfTestArray; static;
  end;

implementation

uses
  {$IF DEFINED(WINDOWS)}
  Windows,
  {$ELSEIF DEFINED(POSIX)}
  {$IFEND}
  Math, Classes, SysUtils;

type
  TCalibration = class(TAbstractPerfTest)
  protected
    function GetName: string; override;
  public
    procedure Setup(Seq: Integer); override;
    procedure Run; override;
  end;

{ TCalibration }

function TCalibration.GetName: string;
begin
  Result := 'Calibration';
end;

{$PUSH}
{$HINTS OFF}
procedure TCalibration.Setup(Seq: Integer);
begin
end;
{$POP}

procedure TCalibration.Run;
begin
end;

{ TPerfTestRunner }

class procedure TPerfTestRunner.Init;
begin
  FOverhead := -1;
  BindThread;
end;

class procedure TPerfTestRunner.BindThread;
begin
  {$IF DEFINED(WINDOWS)}
  SetThreadAffinityMask(GetCurrentThread, $00000001);
  {$ELSEIF DEFINED(POSIX)}
  //TODO:
  {$IFEND}
end;

{$IFOPT O+}
  {$DEFINE _OPT_ENABLED}
  {$OPTIMIZATION OFF}
{$ENDIF}
class procedure TPerfTestRunner.PrepareCore;
const
  BURN_TIME = 10000; { 10 sec to force CPU increase its frequency }
var
  EndTick: QWord;
  DummyInt, DummyRes: Int64;
  DummyFloat: Double;
begin
  DummyInt := 0;
  DummyFloat := 0;
  DummyRes := 1;

  EndTick := TThread.GetTickCount64 + BURN_TIME;
  while EndTick > TThread.GetTickCount64 do
  begin
    DummyFloat := DummyFloat + DummyRes;
    DummyInt := DummyInt + DummyRes;
    DummyRes := Round(DummyFloat / DummyInt);
  end;
end;
{$IFDEF _OPT_ENABLED}
  {$UNDEF _OPT_ENABLED}
  {$OPTIMIZATION ON}
{$ENDIF}

class function TPerfTestRunner.ScaleCount(Scale: Integer): Int64;
begin
  Result := Round(IntPower(10, Scale + 1));
end;

class procedure TPerfTestRunner.Calibration;
var
  CTest: TAbstractPerfTest;
  CResult: TPerfTestArray;
begin
  if FOverhead < 0 then
  begin
    CTest :=  TCalibration.Create;
    try
      FOverhead := 0;
      CResult := RunTests(CTest, 1, 5, 5);
      FOverhead := CResult[0].AvgTime;
    finally
      FreeAndNil(CTest);
    end;
  end;
end;

class function TPerfTestRunner.RunTests(const PerfTest: TAbstractPerfTest;
  Seq: Cardinal; ScaleStart, ScaleEnd: Int64): TPerfTestArray;
const
  NFO_TPL: string = '%s (%d/%d): %s     ';
var
  RunTime, k, b: Double;
  j, RepCount: Int64;
  StartTime, EndTime: QWord;
  TestName: string;
  i: Cardinal;
begin
  TestName := PerfTest.Name;
  SetLength(Result, Seq);

  if Seq = 1 then
  begin
    k := 0;
    b := ScaleStart;
  end
  else begin
    k := (ScaleEnd - ScaleStart) / (Seq - 1);
    b :=  ((Seq - 1) * ScaleStart) / (Seq - 1);
  end;

  Write(Format(NFO_TPL, [TestName, 0, Seq, 'BURNING']), #13);
  PrepareCore;

  for i := 0 to Seq - 1 do
  begin
    PerfTest.Setup(i);

      StartTime := TThread.GetTickCount64;

    Write(Format(NFO_TPL, [TestName, i + 1, Seq, 'RUNNING']), #13);
    j := 0;
    RepCount := ScaleCount(Round(k * i + b));
    while j < RepCount do
    begin
      PerfTest.Run;
      Inc(j);
    end;
    EndTime := TThread.GetTickCount64;

    RunTime := EndTime - StartTime - RepCount * FOverhead;
    if RunTime > 0 then
    begin
      Result[i].CPS := Round( (1000 * RepCount) / RunTime );
      Result[i].AvgTime := 1 / Result[i].CPS;
    end
    else begin
      Result[i].CPS := 0;
      Result[i].AvgTime := 0;
    end;
  end;

  Writeln(Format(NFO_TPL, [TestName, Seq, Seq, 'DONE']));
end;

initialization
  TPerfTestRunner.Init;

end.
