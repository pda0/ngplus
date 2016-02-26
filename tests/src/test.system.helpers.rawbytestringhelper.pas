{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.RawByteStringHelper;

{$I ngplus.inc}

interface

uses
  fpcunit, testregistry, System.Helpers,
  Classes, SysUtils;

type
  TTestRawByteStringHelper = class(TTestCase)
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
  TEST_STR: RawByteString = 'This is a string.';
  TEST_INT64: Int64 = 3000000000;

{ TTestRawByteStringHelper }

procedure TTestRawByteStringHelper.TestCreate;
var
  Str: RawByteString;
begin
  Str := RawByteString.Create(WideChar('a'), 10);
  CheckEquals(RawByteString('aaaaaaaaaa'), Str);

  Str := RawByteString.Create([]);
  CheckEquals(RawByteString(''), Str);

  Str := RawByteString.Create(['1', '2', '3', '4', '5']);
  CheckEquals(RawByteString('12345'), Str);

  Str := RawByteString.Create(['1', '2', '3', '4', '5'], 1, 2);
  CheckEquals(RawByteString('23'), Str);
end;

procedure TTestRawByteStringHelper.TestEquals;
var
  Str1, Str2: RawByteString;
begin
  Str1 := 'A';
  Str2 := 'A';

  CheckTrue(RawByteString.Equals(Str1, Str1));
  CheckTrue(RawByteString.Equals('B', 'B'));
  CheckFalse(RawByteString.Equals('B', 'C'));
  CheckTrue(Str1.Equals(Str1));
  CheckTrue(Str1 = Str2);
  CheckFalse(Str1 <> Str2);
  CheckTrue(Str1 = 'A');
  CheckTrue('A' = Str1);
end;

procedure TTestRawByteStringHelper.TestFormat;
var
  Str1, Str2: RawByteString;
begin
  Str1 := 'This is a %s';
  Str2 := 'string.';

  CheckEquals(TEST_STR, RawByteString.Format(Str1, ['string.']));
  CheckEquals(TEST_STR, RawByteString.Format(Str1, [RawByteString(Str2)]));
end;

procedure TTestRawByteStringHelper.TestEmpty;
var
  Str: RawByteString;
begin
  Str := '';
  CheckTrue(Str.IsEmpty);
  CheckTrue(RawByteString.IsNullOrEmpty(Str));
  CheckTrue(RawByteString.IsNullOrWhiteSpace(Str));

  Str := #0;
  CheckFalse(Str.IsEmpty);
  CheckFalse(RawByteString.IsNullOrEmpty(Str));
  CheckTrue(RawByteString.IsNullOrWhiteSpace(Str));

  Str := TEST_STR;
  CheckFalse(Str.IsEmpty);
  CheckFalse(RawByteString.IsNullOrEmpty(Str));
  CheckFalse(RawByteString.IsNullOrWhiteSpace(Str));

  Str := #$00#$01#$02#$03#$04#$05#$06#$07#$08#$09#$0a#$0b#$0c#$0d#$0e#$0f#$10+
    #$11#$12#$13#$14#$5#$6#$7#$8#$9#$1a#$1b#$1c#$1d#$1e#$1f#$20;
  CheckTrue(RawByteString.IsNullOrWhiteSpace(Str));
end;

procedure TTestRawByteStringHelper.TIntegerEmpty;
begin
  RawByteString.ToInteger('');
end;

procedure TTestRawByteStringHelper.TIntegerToBig;
begin
  RawByteString.ToInteger('3000000000');
end;

procedure TTestRawByteStringHelper.TestToInteger;
var
  Str: RawByteString;
begin
  Str := '1';
  CheckEquals(StrToInt('1'), Str.ToInteger);

  CheckEquals(StrToInt('2'), RawByteString.ToInteger('2'));
  CheckEquals(StrToInt('-1'), RawByteString.ToInteger('-1'));
  CheckException(TIntegerEmpty, EConvertError);
  CheckException(TIntegerToBig, EConvertError);
end;

procedure TTestRawByteStringHelper.TestToLower;
begin

end;

procedure TTestRawByteStringHelper.TestToLowerInvariant;
var
  Str: RawByteString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(RawByteString('hello привет allô 您好 123'), Str.ToLowerInvariant);
end;

procedure TTestRawByteStringHelper.TestToUpperInvariant;
var
  Str: RawByteString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(RawByteString('HELLO ПРИВЕТ ALLÔ 您好 123'), Str.ToUpperInvariant);
end;

procedure TTestRawByteStringHelper.TInt64Empty;
begin
  RawByteString.ToInt64('');
end;

procedure TTestRawByteStringHelper.TInt64ToBig;
begin
  RawByteString.ToInt64('9223372036854775808');
end;

procedure TTestRawByteStringHelper.TestToInt64;
var
  Str: RawByteString;
begin
  Str := '3000000000';
  CheckTrue(TEST_INT64 = Str.ToInt64);

  CheckTrue(TEST_INT64 = RawByteString.ToInt64('3000000000'));
  CheckTrue(-TEST_INT64 = RawByteString.ToInt64('-3000000000'));
  CheckException(TInt64Empty, EConvertError);
  CheckException(TInt64ToBig, EConvertError);
end;

initialization
  RegisterTest('System.Helpers', TTestRawByteStringHelper.Suite);

end.

