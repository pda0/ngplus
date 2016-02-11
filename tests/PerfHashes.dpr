{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program PerfHashes;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Perf.Test in 'src\perf.test.pas',
  Perf.System.Hash in 'src\perf.system.hash.pas';

begin
  try
    TPerfTestRunner.Calibration;
    RunTests;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
