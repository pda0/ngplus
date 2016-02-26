{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.UTF8StringHelper;

{$I ngplus.inc}

interface

uses
  fpcunit, testregistry, System.Helpers,
  Classes, SysUtils;

type
  TTestUTF8StringHelper = class(TTestCase)
  private
    procedure TIntegerEmpty;
    procedure TIntegerToBig;

    procedure TestToLower;

    procedure TInt64Empty;
    procedure TInt64ToBig;
  published
    procedure TestCreate;

    procedure TestEquals;
    procedure TestFormat;

    procedure TestEmpty;

    procedure TestToInteger;

    procedure TestToLowerInvariant;

    procedure TestToUpperInvariant;

    procedure TestToInt64;
  end;

implementation

const
  TEST_STR: UTF8String = 'This is a string.';
  TEST_INT64: Int64 = 3000000000;

{ TTestUTF8StringHelper }

procedure TTestUTF8StringHelper.TestCreate;
var
  Str: UTF8String;
begin
  Str := UTF8String.Create(WideChar('a'), 10);
  CheckEquals(UTF8String('aaaaaaaaaa'), Str);

  Str := UTF8String.Create([]);
  CheckEquals(UTF8String(''), Str);

  Str := UTF8String.Create(['1', '2', '3', '4', '5']);
  CheckEquals(UTF8String('12345'), Str);

  Str := UTF8String.Create(['1', '2', '3', '4', '5'], 1, 2);
  CheckEquals(UTF8String('23'), Str);
end;

procedure TTestUTF8StringHelper.TestEquals;
var
  Str1, Str2: UTF8String;
begin
  Str1 := 'A';
  Str2 := 'A';

  CheckTrue(UTF8String.Equals(Str1, Str1));
  CheckTrue(UTF8String.Equals('B', 'B'));
  CheckFalse(UTF8String.Equals('B', 'C'));
  CheckTrue(Str1.Equals(Str1));
  CheckTrue(Str1 = Str2);
  CheckFalse(Str1 <> Str2);
  CheckTrue(Str1 = 'A');
  CheckTrue('A' = Str1);
end;

procedure TTestUTF8StringHelper.TestFormat;
var
  Str1, Str2: UTF8String;
begin
  Str1 := 'This is a %s';
  Str2 := 'string.';

  CheckEquals(TEST_STR, UTF8String.Format(Str1, ['string.']));
  CheckEquals(TEST_STR, UTF8String.Format(Str1, [UTF8String(Str2)]));
end;

procedure TTestUTF8StringHelper.TestEmpty;
var
  Str: UTF8String;
begin
  Str := '';
  CheckTrue(Str.IsEmpty);
  CheckTrue(UTF8String.IsNullOrEmpty(Str));
  CheckTrue(UTF8String.IsNullOrWhiteSpace(Str));

  Str := #0;
  CheckFalse(Str.IsEmpty);
  CheckFalse(UTF8String.IsNullOrEmpty(Str));
  CheckTrue(UTF8String.IsNullOrWhiteSpace(Str));

  Str := TEST_STR;
  CheckFalse(Str.IsEmpty);
  CheckFalse(UTF8String.IsNullOrEmpty(Str));
  CheckFalse(UTF8String.IsNullOrWhiteSpace(Str));

  Str := #$00#$01#$02#$03#$04#$05#$06#$07#$08#$09#$0a#$0b#$0c#$0d#$0e#$0f#$10+
    #$11#$12#$13#$14#$5#$6#$7#$8#$9#$1a#$1b#$1c#$1d#$1e#$1f#$20;
  CheckTrue(WideString.IsNullOrWhiteSpace(Str));
end;

procedure TTestUTF8StringHelper.TIntegerEmpty;
begin
  UTF8String.ToInteger('');
end;

procedure TTestUTF8StringHelper.TIntegerToBig;
begin
  UTF8String.ToInteger('3000000000');
end;

procedure TTestUTF8StringHelper.TestToInteger;
var
  Str: UTF8String;
begin
  Str := '1';
  CheckEquals(StrToInt('1'), Str.ToInteger);

  CheckEquals(StrToInt('2'), UTF8String.ToInteger('2'));
  CheckEquals(StrToInt('-1'), UTF8String.ToInteger('-1'));
  CheckException(TIntegerEmpty, EConvertError);
  CheckException(TIntegerToBig, EConvertError);
end;

procedure TTestUTF8StringHelper.TestToLower;
begin

end;

procedure TTestUTF8StringHelper.TestToLowerInvariant;
var
  Str: UTF8String;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(UTF8String('hello привет allô 您好 123'), Str.ToLowerInvariant);
end;

procedure TTestUTF8StringHelper.TestToUpperInvariant;
var
  Str: UTF8String;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(UTF8String('HELLO ПРИВЕТ ALLÔ 您好 123'), Str.ToUpperInvariant);
end;

procedure TTestUTF8StringHelper.TInt64Empty;
begin
  UTF8String.ToInt64('');
end;

procedure TTestUTF8StringHelper.TInt64ToBig;
begin
  UTF8String.ToInt64('9223372036854775808');
end;

procedure TTestUTF8StringHelper.TestToInt64;
var
  Str: UTF8String;
begin
  Str := '3000000000';
  CheckTrue(TEST_INT64 = Str.ToInt64);

  CheckTrue(TEST_INT64 = UTF8String.ToInt64('3000000000'));
  CheckTrue(-TEST_INT64 = UTF8String.ToInt64('-3000000000'));
  CheckException(TInt64Empty, EConvertError);
  CheckException(TInt64ToBig, EConvertError);
end;

initialization
  RegisterTest('System.Helpers', TTestUTF8StringHelper.Suite);

end.

