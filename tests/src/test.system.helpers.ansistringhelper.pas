{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.AnsiStringHelper;

{$I ngplus.inc}

interface

uses
  fpcunit, testregistry, System.Helpers,
  Classes, SysUtils;

type
  TTestAnsiStringHelper = class(TTestCase)
  private

    procedure TDoubleEmpty;
    procedure TExtendedEmpty;
    procedure TIntegerEmpty;
    procedure TIntegerToBig;
    procedure TSingleEmpty;
    procedure TInt64Empty;
    procedure TInt64ToBig;

    procedure TestToLower;
  published
    procedure TestCreate;

    procedure TestContains;
    procedure TestCopy;

    procedure TestEquals;
    procedure TestFormat;

    procedure TestEmpty;

    procedure TestToDouble;
    procedure TestToExtended;
    procedure TestToInteger;

    procedure TestToLowerInvariant;
    procedure TestToSingle;

    procedure TestToUpperInvariant;
    (* procedure TestTrim;
    procedure TestTrimLeft; *)
    procedure TestTrimRight;

    procedure TestChars;
    procedure TestLength;
    procedure TestParse;
    procedure TestToInt64;

    { Non Delphi }
    (* procedure TestByteLength;
    procedure TestCodePoints; *)
  end;

implementation

const
  TEST_STR: AnsiString = 'This is a string.';
  TEST_INT64: Int64 = 3000000000;

{ TTestAnsiStringHelper }

procedure TTestAnsiStringHelper.TestCreate;
var
  Str: AnsiString;
begin
  Str := AnsiString.Create(WideChar('a'), 10);
  CheckEquals(AnsiString('aaaaaaaaaa'), Str);

  Str := AnsiString.Create([]);
  CheckEquals(AnsiString(''), Str);

  Str := AnsiString.Create(['1', '2', '3', '4', '5']);
  CheckEquals(AnsiString('12345'), Str);

  Str := AnsiString.Create(['1', '2', '3', '4', '5'], 1, 2);
  CheckEquals(AnsiString('23'), Str);
end;

procedure TTestAnsiStringHelper.TestContains;
var
  Str: AnsiString;
begin
  Str := TEST_STR;
  SetCodePage(RawByteString(Str), 1251);

  CheckTrue(Str.Contains('This'));
  CheckTrue(Str.Contains('str'));
  CheckFalse(Str.Contains('suxx'));
  CheckFalse(Str.Contains(''));

  Str := '';
  SetCodePage(RawByteString(Str), 1251);
  CheckFalse(Str.Contains(''));
end;

procedure TTestAnsiStringHelper.TestCopy;
begin
  CheckEquals(TEST_STR, AnsiString.Copy(TEST_STR));
end;

procedure TTestAnsiStringHelper.TestEquals;
var
  Str1, Str2: AnsiString;
begin
  Str1 := 'A';
  Str2 := 'A';
  SetCodePage(RawByteString(Str1), 1251);
  SetCodePage(RawByteString(Str2), 1251);

  CheckTrue(AnsiString.Equals(Str1, Str1));
  CheckTrue(AnsiString.Equals('B', 'B'));
  CheckFalse(AnsiString.Equals('B', 'C'));
  CheckTrue(Str1.Equals(Str1));
  CheckTrue(Str1 = Str2);
  CheckFalse(Str1 <> Str2);
  CheckTrue(Str1 = 'A');
  CheckTrue('A' = Str1);
end;

procedure TTestAnsiStringHelper.TestFormat;
var
  Str1, Str2: AnsiString;
begin
  Str1 := 'This is a %s';
  Str2 := 'string.';
  SetCodePage(RawByteString(Str1), 1251);
  SetCodePage(RawByteString(Str2), 1251);

  CheckEquals(TEST_STR, AnsiString.Format(Str1, ['string.']));
  CheckEquals(TEST_STR, AnsiString.Format(Str1, [AnsiString(Str2)]));
end;

procedure TTestAnsiStringHelper.TestEmpty;
var
  Str: AnsiString;
begin
  Str := '';
  SetCodePage(RawByteString(Str), 1251);
  CheckTrue(Str.IsEmpty);
  CheckTrue(AnsiString.IsNullOrEmpty(Str));
  CheckTrue(AnsiString.IsNullOrWhiteSpace(Str));

  Str := #0;
  SetCodePage(RawByteString(Str), 1251);
  CheckFalse(Str.IsEmpty);
  CheckFalse(AnsiString.IsNullOrEmpty(Str));
  CheckTrue(AnsiString.IsNullOrWhiteSpace(Str));

  Str := TEST_STR;
  SetCodePage(RawByteString(Str), 1251);
  CheckFalse(Str.IsEmpty);
  CheckFalse(AnsiString.IsNullOrEmpty(Str));
  CheckFalse(AnsiString.IsNullOrWhiteSpace(Str));

  Str := #$00#$01#$02#$03#$04#$05#$06#$07#$08#$09#$0a#$0b#$0c#$0d#$0e#$0f#$10+
    #$11#$12#$13#$14#$5#$6#$7#$8#$9#$1a#$1b#$1c#$1d#$1e#$1f#$20;
  SetCodePage(RawByteString(Str), 1251);
  CheckTrue(AnsiString.IsNullOrWhiteSpace(Str));
end;

procedure TTestAnsiStringHelper.TDoubleEmpty;
begin
  AnsiString.ToDouble('');
end;

procedure TTestAnsiStringHelper.TestToDouble;
var
  Str, StrVal: AnsiString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToDouble);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), AnsiString.ToDouble(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), AnsiString.ToDouble(StrVal));
  CheckException(TDoubleEmpty, EConvertError);
end;

procedure TTestAnsiStringHelper.TExtendedEmpty;
begin
  AnsiString.ToExtended('');
end;

procedure TTestAnsiStringHelper.TestToExtended;
var
  Str, StrVal: AnsiString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToExtended);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), AnsiString.ToExtended(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), AnsiString.ToExtended(StrVal));
  CheckException(TExtendedEmpty, EConvertError);
end;

procedure TTestAnsiStringHelper.TIntegerEmpty;
begin
  AnsiString.ToInteger('');
end;

procedure TTestAnsiStringHelper.TIntegerToBig;
begin
  AnsiString.ToInteger('3000000000');
end;

procedure TTestAnsiStringHelper.TestToInteger;
var
  Str: AnsiString;
begin
  Str := '1';
  SetCodePage(RawByteString(Str), 1251);
  CheckEquals(StrToInt('1'), Str.ToInteger);

  CheckEquals(StrToInt('2'), AnsiString.ToInteger('2'));
  CheckEquals(StrToInt('-1'), AnsiString.ToInteger('-1'));
  CheckException(TIntegerEmpty, EConvertError);
  CheckException(TIntegerToBig, EConvertError);
end;

procedure TTestAnsiStringHelper.TestToLower;
begin

end;

procedure TTestAnsiStringHelper.TestToLowerInvariant;
var
  Str, StrRes: AnsiString;
begin
  Str := 'HeLlo ПрИвЕт 123';
  StrRes := 'hello привет 123';
  SetCodePage(RawByteString(Str), 1251);
  SetCodePage(RawByteString(StrRes), 1251);
  CheckEquals(StrRes, Str.ToLowerInvariant);
end;

procedure TTestAnsiStringHelper.TSingleEmpty;
begin
  AnsiString.ToSingle('');
end;

procedure TTestAnsiStringHelper.TestToSingle;
var
  Str, StrVal: AnsiString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToSingle);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), AnsiString.ToSingle(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), AnsiString.ToSingle(StrVal));
  CheckException(TSingleEmpty, EConvertError);
end;

procedure TTestAnsiStringHelper.TestToUpperInvariant;
var
  Str, StrRes: AnsiString;
begin
  Str := 'HeLlo ПрИвЕт 123';
  StrRes := 'HELLO ПРИВЕТ 123';
  SetCodePage(RawByteString(Str), 1251);
  SetCodePage(RawByteString(StrRes), 1251);
  CheckEquals(StrRes, Str.ToUpperInvariant);
end;

(* procedure TTestAnsiStringHelper.TestTrim;
var
  Str1, Str2, Str3: AnsiString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals('', Str1.Trim);
  CheckEquals('test', Str2.Trim);
  CheckEquals('test', Str3.Trim);
  CheckEquals('es', Str2.Trim(['t']));
  CheckEquals('s', Str2.Trim(['t', 'e']));
  CheckEquals('', Str2.Trim(['t', 'e', 's', '@']));
  CheckEquals('  test  ', Str3.Trim(['t', 'e', 's', '@']));
end;

procedure TTestAnsiStringHelper.TestTrimLeft;
var
  Str1, Str2, Str3: AnsiString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals('', Str1.TrimLeft);
  CheckEquals('test', Str2.TrimLeft);
  CheckEquals('test  ', Str3.TrimLeft);
  CheckEquals('est', Str2.TrimLeft(['t']));
  CheckEquals('st', Str2.TrimLeft(['t', 'e']));
  CheckEquals('', Str2.TrimLeft(['t', 'e', 's', '@']));
  CheckEquals('  test  ', Str3.TrimLeft(['t', 'e', 's', '@']));
end; *)

procedure TTestAnsiStringHelper.TestTrimRight;
var
  Str1, Str2, Str3: AnsiString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals('', Str1.TrimRight);
  CheckEquals('test', Str2.TrimRight);
  CheckEquals('  test', Str3.TrimRight);
  CheckEquals('tes', Str2.TrimRight(['t']));
  CheckEquals('te', Str2.TrimRight(['t', 's']));
  CheckEquals('', Str2.TrimRight(['t', 'e', 's', '@']));
  CheckEquals('  test  ', Str3.TrimRight(['t', 'e', 's', '@']));
end;

procedure TTestAnsiStringHelper.TestChars;
var
  Str: AnsiString;
begin
  Str := 'hello';
  SetCodePage(RawByteString(Str), 1251);

  CheckEquals(AnsiChar('h'), Str.Chars[0]);
  CheckEquals(AnsiChar('e'), Str.Chars[1]);
  CheckEquals(AnsiChar('l'), Str.Chars[2]);
  CheckEquals(AnsiChar('l'), Str.Chars[3]);
  CheckEquals(AnsiChar('o'), Str.Chars[4]);
end;

procedure TTestAnsiStringHelper.TestLength;
var
  Str: AnsiString;
begin
  Str := 'привет';
  SetCodePage(RawByteString(Str), 1251);

  CheckEquals(6, Str.Length);
end;

procedure TTestAnsiStringHelper.TestParse;
begin
  CheckEquals('-1', AnsiString.Parse(Integer(-1)));
  CheckEquals('3000000000', AnsiString.Parse(TEST_INT64));
  CheckEquals('-1', AnsiString.Parse(True));
  CheckEquals('0', AnsiString.Parse(False));
  CheckEquals(FloatToStr(1.5), AnsiString.Parse(1.5));
end;

procedure TTestAnsiStringHelper.TInt64Empty;
begin
  AnsiString.ToInt64('');
end;

procedure TTestAnsiStringHelper.TInt64ToBig;
begin
  AnsiString.ToInt64('9223372036854775808');
end;

procedure TTestAnsiStringHelper.TestToInt64;
var
  Str: AnsiString;
begin
  Str := '3000000000';
  SetCodePage(RawByteString(Str), 1251);
  CheckTrue(TEST_INT64 = Str.ToInt64);

  CheckTrue(TEST_INT64 = AnsiString.ToInt64('3000000000'));
  CheckTrue(-TEST_INT64 = AnsiString.ToInt64('-3000000000'));
  CheckException(TInt64Empty, EConvertError);
  CheckException(TInt64ToBig, EConvertError);
end;

{ Non Delphi }

(* procedure TTestAnsiStringHelper.TestByteLength;
var
  StrAnsi, StrUtf8: AnsiString;
begin
  StrAnsi := 'привет';
  StrUtf8 := 'привет';
  SetCodePage(RawByteString(StrAnsi), 1251);
  SetCodePage(RawByteString(StrUtf8), CP_UTF8);

  CheckEquals(6, StrAnsi.ByteLength);
  CheckEquals(12, StrUtf8.ByteLength);
end;

procedure TTestAnsiStringHelper.TestCodePoints;
var
  StrAnsi, StrUtf8: AnsiString;
begin
  StrAnsi := 'привет';
  StrUtf8 := 'привет';
  SetCodePage(RawByteString(StrAnsi), 1251);
  SetCodePage(RawByteString(StrUtf8), CP_UTF8);

  CheckEquals(AnsiString(AnsiChar(#$ef)), StrAnsi.CodePoints[0]); { п }
  CheckEquals(AnsiString(AnsiChar(#$f0)), StrAnsi.CodePoints[1]); { р }
  CheckEquals(AnsiString(AnsiChar(#$e8)), StrAnsi.CodePoints[2]); { и }
  CheckEquals(AnsiString(AnsiChar(#$e2)), StrAnsi.CodePoints[3]); { в }
  CheckEquals(AnsiString(AnsiChar(#$e5)), StrAnsi.CodePoints[4]); { е }
  CheckEquals(AnsiString(AnsiChar(#$f2)), StrAnsi.CodePoints[5]); { т }

  CheckEquals(AnsiString(AnsiChar(#$d0) + AnsiChar(#$bf)), StrUtf8.CodePoints[0]); { п }
  CheckEquals(AnsiString(AnsiChar(#$d1) + AnsiChar(#$80)), StrUtf8.CodePoints[1]); { р }
  CheckEquals(AnsiString(AnsiChar(#$d0) + AnsiChar(#$b8)), StrUtf8.CodePoints[2]); { и }
  CheckEquals(AnsiString(AnsiChar(#$d0) + AnsiChar(#$b2)), StrUtf8.CodePoints[3]); { в }
  CheckEquals(AnsiString(AnsiChar(#$d0) + AnsiChar(#$b5)), StrUtf8.CodePoints[4]); { е }
  CheckEquals(AnsiString(AnsiChar(#$d1) + AnsiChar(#$82)), StrUtf8.CodePoints[5]); { т }
end;  *)

initialization
  RegisterTest('System.Helpers', TTestAnsiStringHelper.Suite);

end.

