{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.UTF8StringHelper;

{$I ../src/ngplus.inc}

interface

uses
  fpcunit, testregistry, System.Helpers,
  Classes, SysUtils;

type
  TTestUTF8StringHelper = class(TTestCase)
  strict private
    FStr: UTF8String;
  private
    procedure TIntegerEmpty;
  published

    procedure TestToInteger;
    procedure TestToLower;
    procedure TestToLowerInvariant;

  end;

implementation

{ TTestUTF8StringHelper }

procedure TTestUTF8StringHelper.TIntegerEmpty;
begin
  UTF8String.ToInteger('');
end;

procedure TTestUTF8StringHelper.TestToInteger;
begin
  FStr := '1';
  CheckEquals(StrToInt('1'), FStr.ToInteger);

  CheckEquals(StrToInt('2'), UTF8String.ToInteger('2'));
  CheckEquals(StrToInt('-1'), UTF8String.ToInteger('-1'));
  CheckException(TIntegerEmpty, EConvertError);
end;

procedure TTestUTF8StringHelper.TestToLower;
begin

end;

procedure TTestUTF8StringHelper.TestToLowerInvariant;
begin

end;

initialization
  RegisterTest('System.Helpers', TTestUTF8StringHelper.Suite);

end.

