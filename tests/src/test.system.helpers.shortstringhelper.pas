{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.ShortStringHelper;

{$I ngplus.inc}

interface

uses
  fpcunit, testregistry, System.Helpers,
  Classes, SysUtils;

type
  TTestShortStringHelper = class(TTestCase)
  private
    procedure TIntegerEmpty;
    procedure TIntegerToBig;

    procedure TestToLower;

    procedure TInt64Empty;
    procedure TInt64ToBig;
  published
    procedure TestCreate;

    procedure TestEquals;

    procedure TestEmpty;
    procedure TestFormat;

    procedure TestToInteger;

    procedure TestToLowerInvariant;

    procedure TestToUpperInvariant;

    procedure TestToInt64;
  end;

implementation

const
  TEST_STR: ShortString = 'This is a string.';
  TEST_INT64: Int64 = 3000000000;

{ TTestShortStringHelper }

procedure TTestShortStringHelper.TestCreate;
var
  Str: ShortString;
begin
  Str := ShortString.Create(WideChar('a'), 10);
  CheckEquals(ShortString('aaaaaaaaaa'), Str);

  Str := ShortString.Create([]);
  CheckEquals(ShortString(''), Str);

  Str := ShortString.Create(['1', '2', '3', '4', '5']);
  CheckEquals(ShortString('12345'), Str);

  Str := ShortString.Create(['1', '2', '3', '4', '5'], 1, 2);
  CheckEquals(ShortString('23'), Str);
end;

procedure TTestShortStringHelper.TestEquals;
var
  Str1, Str2: ShortString;
begin
  Str1 := 'A';
  Str2 := 'A';

  CheckTrue(ShortString.Equals(Str1, Str1));
  CheckTrue(ShortString.Equals('B', 'B'));
  CheckFalse(ShortString.Equals('B', 'C'));
  CheckTrue(Str1.Equals(Str1));
  CheckTrue(Str1 = Str2);
  CheckFalse(Str1 <> Str2);
  CheckTrue(Str1 = 'A');
  CheckTrue('A' = Str1);
end;

procedure TTestShortStringHelper.TestFormat;
var
  Str1, Str2: ShortString;
begin
  Str1 := 'This is a %s';
  Str2 := 'string.';

  CheckEquals(TEST_STR, ShortString.Format(Str1, ['string.']));
  CheckEquals(TEST_STR, ShortString.Format(Str1, [ShortString(Str2)]));
end;

procedure TTestShortStringHelper.TestEmpty;
var
  Str: ShortString;
begin
  Str := '';
  CheckTrue(Str.IsEmpty);
  CheckTrue(ShortString.IsNullOrEmpty(Str));
  CheckTrue(ShortString.IsNullOrWhiteSpace(Str));

  Str := #0;
  CheckFalse(Str.IsEmpty);
  CheckFalse(ShortString.IsNullOrEmpty(Str));
  CheckTrue(ShortString.IsNullOrWhiteSpace(Str));

  Str := TEST_STR;
  CheckFalse(Str.IsEmpty);
  CheckFalse(ShortString.IsNullOrEmpty(Str));
  CheckFalse(ShortString.IsNullOrWhiteSpace(Str));

  Str := #$00#$01#$02#$03#$04#$05#$06#$07#$08#$09#$0a#$0b#$0c#$0d#$0e#$0f#$10+
    #$11#$12#$13#$14#$5#$6#$7#$8#$9#$1a#$1b#$1c#$1d#$1e#$1f#$20;
  CheckTrue(ShortString.IsNullOrWhiteSpace(Str));
end;

procedure TTestShortStringHelper.TIntegerEmpty;
begin
  ShortString.ToInteger('');
end;

procedure TTestShortStringHelper.TIntegerToBig;
begin
  ShortString.ToInteger('3000000000');
end;

procedure TTestShortStringHelper.TestToInteger;
var
  Str: ShortString;
begin
  Str := '1';
  CheckEquals(StrToInt('1'), Str.ToInteger);

  CheckEquals(StrToInt('2'), ShortString.ToInteger('2'));
  CheckEquals(StrToInt('-1'), ShortString.ToInteger('-1'));
  CheckException(TIntegerEmpty, EConvertError);
  CheckException(TIntegerToBig, EConvertError);
end;

procedure TTestShortStringHelper.TestToLower;
begin

end;

procedure TTestShortStringHelper.TestToLowerInvariant;
var
  Str: ShortString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(ShortString('hello привет allô 您好 123'), Str.ToLowerInvariant);
end;

procedure TTestShortStringHelper.TestToUpperInvariant;
var
  Str: ShortString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(ShortString('HELLO ПРИВЕТ ALLÔ 您好 123'), Str.ToUpperInvariant);
end;

procedure TTestShortStringHelper.TInt64Empty;
begin
  ShortString.ToInt64('');
end;

procedure TTestShortStringHelper.TInt64ToBig;
begin
  ShortString.ToInt64('9223372036854775808');
end;

procedure TTestShortStringHelper.TestToInt64;
var
  Str: ShortString;
begin
  Str := '3000000000';
  CheckTrue(TEST_INT64 = Str.ToInt64);

  CheckTrue(TEST_INT64 = ShortString.ToInt64('3000000000'));
  CheckTrue(-TEST_INT64 = ShortString.ToInt64('-3000000000'));
  CheckException(TInt64Empty, EConvertError);
  CheckException(TInt64ToBig, EConvertError);
end;

initialization
  RegisterTest('System.Helpers', TTestShortStringHelper.Suite);

end.

