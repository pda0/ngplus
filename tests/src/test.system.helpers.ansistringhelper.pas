{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.AnsiStringHelper;

{$I ../src/ngplus.inc}

interface

uses
  fpcunit, testregistry, System.Helpers,
  Classes, SysUtils;

type
  TTestAnsiStringHelper = class(TTestCase)
  strict private
    FStr: AnsiString;
  private
    procedure TIntegerEmpty;
  published

    procedure TestToInteger;
    procedure TestToLower;
    procedure TestToLowerInvariant;

  end;

implementation

{ TTestAnsiStringHelper }

procedure TTestAnsiStringHelper.TIntegerEmpty;
begin
  AnsiString.ToInteger('');
end;

procedure TTestAnsiStringHelper.TestToInteger;
begin
  FStr := '1';
  CheckEquals(StrToInt('1'), FStr.ToInteger);

  CheckEquals(StrToInt('2'), AnsiString.ToInteger('2'));
  CheckEquals(StrToInt('-1'), AnsiString.ToInteger('-1'));
  CheckException(TIntegerEmpty, EConvertError);
end;

procedure TTestAnsiStringHelper.TestToLower;
begin

end;

procedure TTestAnsiStringHelper.TestToLowerInvariant;
begin

end;

initialization
  RegisterTest('System.Helpers', TTestAnsiStringHelper.Suite);

end.

