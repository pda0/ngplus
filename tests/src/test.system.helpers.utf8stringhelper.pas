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
  {$IFDEF FPC_HAS_FEATURE_ANSISTRINGS}
  private

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

    procedure TestToLower;
  published
    procedure TestCreate;

    procedure TestContains;
    procedure TestCopy;

    procedure TestEquals;
    procedure TestFormat;

    procedure TestEmpty;

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
  TEST_STR: UTF8String = 'This is a string.';
  TEST_INT64: Int64 = 3000000000;

  TEST_CP_LATIN_SMALL_LETTER_S = AnsiChar($73);
  TEST_CP_COMBINING_DOT_BELOW = UTF8String(#$cc#$ae);
  TEST_CP_COMBINING_DOT_ABOVE = UTF8String(#$cc#$87);
  TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE = UTF8String(#$e1#$b9#$a9);

  TEST_CPS: UTF8String = TEST_CP_LATIN_SMALL_LETTER_S +
    TEST_CP_COMBINING_DOT_BELOW + TEST_CP_COMBINING_DOT_ABOVE +
    TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE;

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

procedure TTestUTF8StringHelper.TestContains;
var
  Str: UTF8String;
begin
  Str := TEST_STR;

  CheckTrue(Str.Contains('This'));
  CheckTrue(Str.Contains('str'));
  CheckFalse(Str.Contains('suxx'));
  CheckFalse(Str.Contains(''));

  Str := '';
  CheckFalse(Str.Contains(''));
end;

procedure TTestUTF8StringHelper.TestCopy;
begin
  CheckEquals(TEST_STR, UTF8String.Copy(TEST_STR));
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
  CheckTrue(UTF8String.IsNullOrWhiteSpace(Str));
end;

procedure TTestUTF8StringHelper.ToBooleanEmpty;
begin
  UTF8String.ToBoolean('');
end;

procedure TTestUTF8StringHelper.TestToBoolean;
var
  Str: UTF8String;
begin
  Str := '0';
  CheckFalse(Str.ToBoolean);

  CheckFalse(UTF8String.ToBoolean('0'));
  CheckFalse(UTF8String.ToBoolean('0' + AnsiChar(FormatSettings.DecimalSeparator) + '00'));
  CheckTrue(UTF8String.ToBoolean('-1'));
  CheckTrue(UTF8String.ToBoolean('1'));
  CheckTrue(UTF8String.ToBoolean('11' + AnsiChar(FormatSettings.DecimalSeparator) + '12'));
  CheckTrue(UTF8String.ToBoolean(UTF8String(SysUtils.TrueBoolStrs[0])));
  CheckFalse(UTF8String.ToBoolean(UTF8String(SysUtils.FalseBoolStrs[0])));
  CheckTrue(UTF8String.ToBoolean('TRUE'));
  CheckException(@ToBooleanEmpty, EConvertError);
end;

{$IFNDEF FPUNONE}
{$IFDEF FPC_HAS_TYPE_DOUBLE}
procedure TTestUTF8StringHelper.TDoubleEmpty;
begin
  UTF8String.ToDouble('');
end;

procedure TTestUTF8StringHelper.TestToDouble;
var
  Str, StrVal: UTF8String;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToDouble);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), UTF8String.ToDouble(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), UTF8String.ToDouble(StrVal));
  CheckException(@TDoubleEmpty, EConvertError);
end;
{$ELSE}
procedure TTestUTF8StringHelper.TestToDouble;
begin
  Ignore('Double type is not supported.')
end;
{$ENDIF !FPC_HAS_TYPE_DOUBLE}
{$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
procedure TTestUTF8StringHelper.TExtendedEmpty;
begin
  UTF8String.ToExtended('');
end;

procedure TTestUTF8StringHelper.TestToExtended;
var
  Str, StrVal: UTF8String;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToExtended);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), UTF8String.ToExtended(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), UTF8String.ToExtended(StrVal));
  CheckException(@TExtendedEmpty, EConvertError);
end;
{$ELSE}
procedure TTestUTF8StringHelper.TestToExtended;
begin
  Ignore('Extended type is not supported.');
end;
{$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
{$IFDEF FPC_HAS_TYPE_SINGLE}
procedure TTestUTF8StringHelper.TSingleEmpty;
begin
  UTF8String.ToSingle('');
end;

procedure TTestUTF8StringHelper.TestToSingle;
var
  Str, StrVal: UTF8String;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToSingle);

  StrVal := '1' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), UTF8String.ToSingle(StrVal));
  StrVal := '-0' + AnsiChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat(StrVal), UTF8String.ToSingle(StrVal));
  CheckException(@TSingleEmpty, EConvertError);
end;
{$ELSE}
procedure TTestUTF8StringHelper.TestToSingle;
begin
  Ignore('Single type is not supported.');
end;
{$ENDIF !FPC_HAS_TYPE_SINGLE}
{$ENDIF !~FPUNONE}

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
  CheckException(@TIntegerEmpty, EConvertError);
  CheckException(@TIntegerToBig, EConvertError);
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

procedure TTestUTF8StringHelper.TestTrim;
var
  Str1, Str2, Str3: UTF8String;
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

procedure TTestUTF8StringHelper.TestTrimLeft;
var
  Str1, Str2, Str3: UTF8String;
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

procedure TTestUTF8StringHelper.TestTrimRight;
var
  Str1, Str2, Str3: UTF8String;
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

procedure TTestUTF8StringHelper.TestChars;
var
  Str: UTF8String;
begin
  Str := 'привет';

  CheckEquals(AnsiChar(#$d0), Str.Chars[0]);  { п }
  CheckEquals(AnsiChar(#$bf), Str.Chars[1]);
  CheckEquals(AnsiChar(#$d1), Str.Chars[2]);  { р }
  CheckEquals(AnsiChar(#$80), Str.Chars[3]);
  CheckEquals(AnsiChar(#$d0), Str.Chars[4]);  { и }
  CheckEquals(AnsiChar(#$b8), Str.Chars[5]);
  CheckEquals(AnsiChar(#$d0), Str.Chars[6]);  { в }
  CheckEquals(AnsiChar(#$b2), Str.Chars[7]);
  CheckEquals(AnsiChar(#$d0), Str.Chars[8]);  { е }
  CheckEquals(AnsiChar(#$b5), Str.Chars[9]);
  CheckEquals(AnsiChar(#$d1), Str.Chars[10]); { т }
  CheckEquals(AnsiChar(#$82), Str.Chars[11]);
end;

procedure TTestUTF8StringHelper.TestLength;
var
  AnsiStr: UTF8String;
begin
  AnsiStr := 'hello';

  CheckEquals(5, AnsiStr.Length);
end;

procedure TTestUTF8StringHelper.TestParse;
begin
  CheckEquals('-1', UTF8String.Parse(Integer(-1)));
  CheckEquals('3000000000', UTF8String.Parse(TEST_INT64));
  CheckEquals('-1', UTF8String.Parse(True));
  CheckEquals('0', UTF8String.Parse(False));
  {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
  CheckEquals(FloatToStr(1.5), UTF8String.Parse(1.5));
  {$ELSE}
  Ignore('Extended/Double type is not supported.');
  {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
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
  CheckException(@TInt64Empty, EConvertError);
  CheckException(@TInt64ToBig, EConvertError);
end;

{ Non Delphi }

procedure TTestUTF8StringHelper.TestByteLength;
var
  Str: UTF8String;
begin
  Str := 'привет';

  CheckEquals(12, Str.ByteLength);
end;

procedure TTestUTF8StringHelper.TestCPLength;
var
  Str: UTF8String;
begin
  Str := 'привет';

  CheckEquals(6, Str.CPLength);

  { Unicode combining test }
  CheckEquals(4, TEST_CPS.CPLength);
end;

procedure TTestUTF8StringHelper.TestCodePoints;
var
  Str: UTF8String;
begin
  Str := '不怕当小白鼠';

  CheckEquals(UTF8String('不'), Str.CodePoints[0]);
  CheckEquals(UTF8String('怕'), Str.CodePoints[1]);
  CheckEquals(UTF8String('当'), Str.CodePoints[2]);
  CheckEquals(UTF8String('小'), Str.CodePoints[3]);
  CheckEquals(UTF8String('白'), Str.CodePoints[4]);
  CheckEquals(UTF8String('鼠'), Str.CodePoints[5]);

  { Unicode combining test }
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S, TEST_CPS.CodePoints[0]);
  CheckEquals(TEST_CP_COMBINING_DOT_BELOW, TEST_CPS.CodePoints[1]);
  CheckEquals(TEST_CP_COMBINING_DOT_ABOVE, TEST_CPS.CodePoints[2]);
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE, TEST_CPS.CodePoints[3]);
end;

{$ELSE}
procedure TTestUTF8StringHelper.NotSupported;
begin
  Ignore('AnsiString is not supported.');
end;
{$ENDIF !FPC_HAS_FEATURE_ANSISTRINGS}

initialization
  RegisterTest('System.Helpers', TTestUTF8StringHelper.Suite);

end.

