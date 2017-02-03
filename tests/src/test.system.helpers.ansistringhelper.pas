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
  {$IFDEF FPC_HAS_FEATURE_ANSISTRINGS}
  private
    procedure JoinOffRange;
    procedure ToBooleanEmpty;
    {$IFNDEF FPUNONE}
    {$IFDEF FPC_HAS_TYPE_DOUBLE}
    procedure TDoubleEmpty;
    {$ENDIF !FPC_HAS_TYPE_DOUBLE}
    {$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
    procedure TExtendedEmpty;
    {$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
    {$IFDEF FPC_HAS_TYPE_SINGLE}
    procedure TSingleEmpty;
    {$ENDIF !FPC_HAS_TYPE_SINGLE}
    {$ENDIF !~FPUNONE}
    procedure TIntegerEmpty;
    procedure TIntegerToBig;
    procedure TInt64Empty;
    procedure TInt64ToBig;
  public
    procedure TestJoin;
    procedure TestToLower;
  published
    procedure TestCreate;

    procedure TestContains;
    procedure TestCopy;
    procedure TestCopyTo;
    procedure TestCountChar;
    procedure TestDeQuotedString;

    procedure TestEquals;
    procedure TestFormat;

    procedure TestEmpty;
    //procedure TestJoin;

    procedure TestToBoolean;

    procedure TestToDouble;
    procedure TestToExtended;
    procedure TestToSingle;
    procedure TestToInteger;

    procedure TestToLowerInvariant;

    procedure TestToUpperInvariant;
    procedure TestTrim;
    procedure TestTrimLeft;
    procedure TestTrimRight;

    procedure TestChars;
    procedure TestLength;
    procedure TestParse;
    procedure TestToInt64;

    { Non Delphi }
    procedure TestByteLength;
    procedure TestCPLength;
    procedure TestCodePoints;
  {$ELSE}
  public
    procedure NotSupported;
  {$ENDIF !FPC_HAS_FEATURE_ANSISTRINGS}
  end;

implementation

{$IFDEF FPC_HAS_FEATURE_ANSISTRINGS}
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

procedure TTestAnsiStringHelper.TestCopyTo;
var
  Str1, Str2: AnsiString;
begin
  Str1 := TEST_STR;
  Str2 := 'S';
  Str2.CopyTo(0, Str1[10 + Low(Str1)], 0, Str2.Length);

  CheckEquals(AnsiString('This is a String.'), Str1);
end;

procedure TTestAnsiStringHelper.TestCountChar;
var
  Str: AnsiString;
begin
  Str := 'This string contains 5 occurrences of s';

  CheckEquals(5, Str.CountChar('s'));
end;

procedure TTestAnsiStringHelper.TestDeQuotedString;
var
  Str1, Str2, Str3: AnsiString;
begin
  Str1 := 'This function illustrates the functionality of the QuotedString method.';
  Str2 := '''This function illustrates the functionality of the QuotedString method.''';
  Str3 := 'fThis ffunction illustrates the ffunctionality off the QuotedString method.f';
  CheckEquals(Str1, Str2.DeQuotedString);
  CheckEquals(Str1, Str3.DeQuotedString('f'));
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

procedure TTestAnsiStringHelper.JoinOffRange;
begin
  AnsiString.Join(',', ['String1', 'String2', 'String3'], 3, 2);
end;

procedure TTestAnsiStringHelper.TestJoin;
var
  AStr: AnsiString;
begin
  CheckEquals(AnsiString(''),
    AnsiString.Join(',', [], 0, 0));
  CheckEquals(AnsiString('String1,String2,String3'),
    AnsiString.Join(',', ['String1', 'String2', 'String3']));
  CheckEquals(AnsiString('String1String2String3'),
    AnsiString.Join('', ['String1', 'String2', 'String3']));
  CheckEquals(AnsiString('String1->String2->String3'),
    AnsiString.Join('->', ['String1', 'String2', 'String3']));
  CheckEquals(AnsiString('String2,String3'),
    AnsiString.Join(',', ['String1', 'String2', 'String3'], 1, 2));
  CheckException(@JoinOffRange, ERangeError);
  CheckEquals(AnsiString('String1'),
    AnsiString.Join(',', ['String1', 'String2', 'String3'], 0, 1));
  CheckEquals(AnsiString(''),
    AnsiString.Join(',', ['String1', 'String2', 'String3'], 0, 0));

  AStr := AnsiString('Строка');
  CheckEquals(
    AnsiString('String,Строка,True,10,') + AnsiString(SysUtils.FloatToStr(3.14)) + AnsiString(',TTestAnsiStringHelper'),
    AnsiString.Join(',', ['String', AStr, True, 10, 3.14, Self])
  );
end;

procedure TTestAnsiStringHelper.ToBooleanEmpty;
begin
  AnsiString.ToBoolean('');
end;

procedure TTestAnsiStringHelper.TestToBoolean;
var
  Str: AnsiString;
begin
  Str := '0';
  CheckFalse(Str.ToBoolean);

  CheckFalse(AnsiString.ToBoolean('0'));
  CheckFalse(AnsiString.ToBoolean('000'));
  CheckFalse(AnsiString.ToBoolean('0' + AnsiChar(FormatSettings.DecimalSeparator) + '0'));
  CheckFalse(AnsiString.ToBoolean('-00' + AnsiChar(FormatSettings.DecimalSeparator) + '00'));
  CheckFalse(AnsiString.ToBoolean('+00' + AnsiChar(FormatSettings.DecimalSeparator) + '00'));
  CheckFalse(AnsiString.ToBoolean('00' + AnsiChar(FormatSettings.DecimalSeparator) + '00'));
  CheckTrue(AnsiString.ToBoolean('-1'));
  CheckTrue(AnsiString.ToBoolean('1'));
  CheckTrue(AnsiString.ToBoolean('123'));
  CheckTrue(AnsiString.ToBoolean('11' + AnsiChar(FormatSettings.DecimalSeparator) + '12'));
  CheckTrue(AnsiString.ToBoolean(AnsiString(SysUtils.TrueBoolStrs[0])));
  CheckFalse(AnsiString.ToBoolean(AnsiString(SysUtils.FalseBoolStrs[0])));
  CheckTrue(AnsiString.ToBoolean('TRUE'));
  CheckException(@ToBooleanEmpty, EConvertError);
end;

{$IFNDEF FPUNONE}
{$IFDEF FPC_HAS_TYPE_DOUBLE}
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
  CheckException(@TDoubleEmpty, EConvertError);
end;
{$ELSE}
procedure TTestAnsiStringHelper.TestToDouble;
begin
  Ignore('Double type is not supported.')
end;
{$ENDIF !FPC_HAS_TYPE_DOUBLE}
{$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
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
  CheckException(@TExtendedEmpty, EConvertError);
end;
{$ELSE}
procedure TTestAnsiStringHelper.TestToExtended;
begin
  Ignore('Extended type is not supported.');
end;
{$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
{$IFDEF FPC_HAS_TYPE_SINGLE}
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
  CheckException(@TSingleEmpty, EConvertError);
end;
{$ELSE}
procedure TTestAnsiStringHelper.TestToSingle;
begin
  Ignore('Single type is not supported.');
end;
{$ENDIF !FPC_HAS_TYPE_SINGLE}
{$ENDIF !~FPUNONE}

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
  CheckException(@TIntegerEmpty, EConvertError);
  CheckException(@TIntegerToBig, EConvertError);
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

procedure TTestAnsiStringHelper.TestTrim;
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
end;

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
  {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
  CheckEquals(FloatToStr(1.5), AnsiString.Parse(1.5));
  {$ELSE}
  Ignore('Extended/Double type is not supported.');
  {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
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
  CheckException(@TInt64Empty, EConvertError);
  CheckException(@TInt64ToBig, EConvertError);
end;

{ Non Delphi }

procedure TTestAnsiStringHelper.TestByteLength;
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

procedure TTestAnsiStringHelper.TestCPLength;
var
  AnsiStr: AnsiString;
begin
  AnsiStr := 'hello';

  CheckEquals(5, AnsiStr.Length);
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
end;

{$ELSE}
procedure TTestAnsiStringHelper.NotSupported;
begin
  Ignore('AnsiString is not supported.');
end;
{$ENDIF !FPC_HAS_FEATURE_ANSISTRINGS}

initialization
  RegisterTest('System.Helpers', TTestAnsiStringHelper.Suite);

end.

