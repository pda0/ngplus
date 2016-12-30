{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Test.System.Helpers.UnicodeStringHelper;

{$I ngplus.inc}
{$IFDEF DELPHI_XE4_PLUS}{$LEGACYIFEND ON}{$ENDIF}

interface

uses
  {$IFDEF FPC}
  fpcunit, testregistry, System.Helpers,
  {$ELSE}
  TestFramework,
  {$ENDIF FPC}
  Classes, SysUtils;

{$IF DEFINED(FPC) OR DEFINED(DELPHI_XE3_PLUS)}
type
  TTestUnicodeStringHelper = class(TTestCase)
  {$IFDEF FPC_HAS_FEATURE_UNICODESTRINGS}
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
    {$IF DEFINED(FPC) OR DEFINED(DELPHI_XE8_PLUS)}
    procedure TInt64Empty;
    procedure TInt64ToBig;
    {$IFEND}
  public
    procedure TestCompare;
    procedure TestCompareOrdinal;
    procedure TestCompareText;
    procedure TestCompareTo;
    //procedure TestContains;
    //procedure TestCopy;
    procedure TestCopyTo;
    procedure TestCountChar;
    procedure TestDeQuotedString;
    procedure TestEnds;
    //procedure TestEquals;
    //procedure TestFormat;
    procedure TestIndexOf;
    procedure TestIndexOfAny;
    procedure TestInsert;
    procedure TestIsDelimiter;
    //procedure TestEmpty;
    procedure TestJoin;
    procedure TestLastDelimiter;
    procedure TestLastIndexOf;
    procedure TestLastIndexOfAny;
    procedure TestLowerCase;
    procedure TestPadding;
    procedure TestQuotedString;
    procedure TestRemove;
    procedure TestReplace;
    procedure TestSplit;
    procedure TestStartsWith;
    procedure TestSubstring;
    //procedure TestToBoolean;
    procedure TestToCharArray;
    //procedure TestToDouble;
    //procedure TestToExtended;
    //procedure TestToInteger;
    procedure TestToLower;
    //procedure TestToLowerInvariant;
    procedure TestToUpper;
    //procedure TestToUpperInvariant;
    //procedure TestTrim;
    //procedure TestTrimLeft;
    //procedure TestTrimRight;
    procedure TestUpperCase;
    //procedure TestChars;
    //procedure TestLength;
    //procedure TestParse;
    //procedure TestToInt64;
    procedure TestIndexOfAnyUnquoted;
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

    {$IF DEFINED(FPC) OR DEFINED(DELPHI_XE4_PLUS)}
    procedure TestParse;
    {$IFEND}
    {$IF DEFINED(FPC) OR DEFINED(DELPHI_XE8_PLUS)}
    procedure TestToInt64;
    //procedure TestIndexOfAnyUnquoted;
    {$IFEND}
    { Non Delphi }
    {$IFDEF FPC}
    procedure TestByteLength;
    procedure TestCPLength;
    procedure TestCodePoints;
    {$ENDIF FPC}
  {$ELSE}
  public
    procedure NotSupported;
  {$ENDIF !FPC_HAS_FEATURE_UNICODESTRINGS}
  end;
{$IFEND}

implementation

{$IF DEFINED(FPC) OR DEFINED(DELPHI_XE3_PLUS)}
{$IFDEF FPC_HAS_FEATURE_UNICODESTRINGS}
type
  TUChar = {$IFDEF FPC}UnicodeChar{$ELSE}WideChar{$ENDIF};

const
  TEST_STR: UnicodeString = 'This is a string.';
  TEST_INT64: Int64 = 3000000000;

  TEST_CP_LATIN_SMALL_LETTER_S = TUChar($0073);
  TEST_CP_COMBINING_DOT_BELOW = TUChar($0323);
  TEST_CP_COMBINING_DOT_ABOVE = TUChar($0307);
  TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE = TUChar($1e69);

  TEST_CPS: UnicodeString = TEST_CP_LATIN_SMALL_LETTER_S +
    TEST_CP_COMBINING_DOT_BELOW + TEST_CP_COMBINING_DOT_ABOVE +
    TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE;

{ TTestUnicodeStringHelper }

procedure TTestUnicodeStringHelper.TestCreate;
var
  Str: UnicodeString;
begin
  Str := UnicodeString.Create(TUChar('a'), 10);
  CheckEquals(UnicodeString('aaaaaaaaaa'), Str);

  Str := UnicodeString.Create([]);
  CheckEquals(UnicodeString(''), Str);

  Str := UnicodeString.Create(['1', '2', '3', '4', '5']);
  CheckEquals(UnicodeString('12345'), Str);

  Str := UnicodeString.Create(['1', '2', '3', '4', '5'], 1, 2);
  CheckEquals(UnicodeString('23'), Str);
end;

procedure TTestUnicodeStringHelper.TestCompare;
var
  Str1, Str2: UnicodeString;
begin
  Str1 := 'String A';
  Str2 := 'String B';
  CheckTrue(UnicodeString.Compare(Str1, Str2) < 0);
  CheckEquals(0, UnicodeString.Compare('String B', Str2));
  CheckFalse(UnicodeString.Compare('String B', 'String A') < 0);

  Str2 := 'String a';
  CheckNotEquals(0, UnicodeString.Compare(Str1, Str2));
  CheckEquals(0, UnicodeString.Compare(Str1, Str2, True));
  CheckNotEquals(0, UnicodeString.Compare(Str1, Str2, False));
end;

procedure TTestUnicodeStringHelper.TestCompareOrdinal;
var
  Str1, Str2: UnicodeString;
begin
  Str1 := 'String A';
  Str2 := 'String B';
  CheckEquals(0, UnicodeString.CompareOrdinal('String B', Str2));
  CheckEquals(-1, UnicodeString.CompareOrdinal(Str1, Str2));
  CheckEquals(1, UnicodeString.CompareOrdinal(Str2, Str1));

  CheckEquals(0, UnicodeString.CompareOrdinal(Str1, 0, Str2, 0, 7));
  CheckEquals(-1, UnicodeString.CompareOrdinal(Str1, 0, Str2, 0, 8));
  CheckEquals(-1, UnicodeString.CompareOrdinal(Str1, 6 + Low(Str1), Str2, 6 + Low(Str1), 1));
  CheckEquals(0, UnicodeString.CompareOrdinal(Str1, 6 + Low(Str1), Str2, 6 + Low(Str1), 0));

  CheckEquals(-1, UnicodeString.CompareOrdinal(Str1, 6 + Low(Str1), Str2, 6 + Low(Str2), 2));
  CheckEquals(0, UnicodeString.CompareOrdinal(Str1, 7 + Low(Str1), Str2, 7 + Low(Str2), 1));
  CheckEquals(0, UnicodeString.CompareOrdinal('', ''));
end;

procedure TTestUnicodeStringHelper.TestCompareText;
begin
  CheckEquals(0, UnicodeString.CompareText('', ''));
  CheckEquals(-1, UnicodeString.CompareText('1', '2'));
  CheckEquals(1, UnicodeString.CompareText('2', '1'));
  CheckEquals(0, UnicodeString.CompareText(
    UnicodeString('HeLlo 123'),
    UnicodeString('hello 123')
  ));
  CheckFalse(0 = UnicodeString.CompareText(
    UnicodeString('HeLlo ПрИвЕт aLlÔ 您好 123'),
    UnicodeString('hello привет allô 您好 123')
  ));
end;

procedure TTestUnicodeStringHelper.TestCompareTo;
var
  Str: UnicodeString;
begin
  Str := 'String A';
  CheckEquals(0, Str.CompareTo('String A'));
  CheckEquals(-1, Str.CompareTo('String B'));
  CheckEquals(-32, Str.CompareTo('String a'));
end;

procedure TTestUnicodeStringHelper.TestContains;
var
  Str: UnicodeString;
begin
  Str := TEST_STR;

  CheckTrue(Str.Contains('This'));
  CheckTrue(Str.Contains('str'));
  CheckFalse(Str.Contains('suxx'));
  CheckFalse(Str.Contains(''));

  Str := '';
  CheckFalse(Str.Contains(''));
end;

procedure TTestUnicodeStringHelper.TestCopy;
begin
  CheckEquals(TEST_STR, UnicodeString.Copy(TEST_STR));
end;

procedure TTestUnicodeStringHelper.TestCopyTo;
var
  Str1, Str2: UnicodeString;
begin
  Str1 := TEST_STR;
  Str2 := 'S';
  Str2.CopyTo(0, Str1[10 + Low(Str1)], 0, Str2.Length);

  CheckEquals(UnicodeString('This is a String.'), Str1);
end;

procedure TTestUnicodeStringHelper.TestCountChar;
var
  Str: UnicodeString;
begin
  Str := 'This string contains 5 occurrences of s';

  CheckEquals(5, Str.CountChar('s'));
end;

procedure TTestUnicodeStringHelper.TestDeQuotedString;
var
  Str1, Str2, Str3: UnicodeString;
begin
  Str1 := 'This function illustrates the functionality of the QuotedString method.';
  Str2 := '''This function illustrates the functionality of the QuotedString method.''';
  Str3 := 'fThis ffunction illustrates the ffunctionality off the QuotedString method.f';
  CheckEquals(Str1, Str2.DeQuotedString);
  CheckEquals(Str1, Str3.DeQuotedString('f'));
end;

procedure TTestUnicodeStringHelper.TestEnds;
var
  Str: UnicodeString;
begin
  Str := TEST_STR;

  CheckTrue(UnicodeString.EndsText('string.', Str));
  CheckTrue(Str.EndsWith('String.', True));
  CheckFalse(Str.EndsWith('String.', False));
  CheckTrue(Str.EndsWith('string.'));
  CheckFalse(Str.EndsWith('String.'));
  CheckFalse(Str.EndsWith('This is a string!!'));
end;

procedure TTestUnicodeStringHelper.TestEquals;
var
  Str1, Str2: UnicodeString;
begin
  Str1 := 'A';
  Str2 := 'A';

  CheckTrue(UnicodeString.Equals(Str1, Str1));
  CheckTrue(UnicodeString.Equals('B', 'B'));
  CheckFalse(UnicodeString.Equals('B', 'C'));
  CheckTrue(Str1.Equals(Str1));
  CheckTrue(Str1 = Str2);
  CheckFalse(Str1 <> Str2);
  CheckTrue(Str1 = 'A');
  CheckTrue('A' = Str1);
end;

procedure TTestUnicodeStringHelper.TestFormat;
var
  Str1, Str2: UnicodeString;
begin
  Str1 := 'This is a %s';
  Str2 := 'string.';

  CheckEquals(TEST_STR, UnicodeString.Format(Str1, ['string.']));
  CheckEquals(TEST_STR, UnicodeString.Format(Str1, [UnicodeString(Str2)]));
end;

procedure TTestUnicodeStringHelper.TestIndexOf;
var
  Str: UnicodeString;
begin
  Str := TEST_STR;

  CheckEquals(3, Str.IndexOf('s', 0, 5));
  CheckEquals(2, Str.IndexOf('is', 0));
  CheckEquals(16, Str.IndexOf('.'));
  CheckEquals(-1, Str.IndexOf('?'));
  CheckEquals(-1, Str.IndexOf(''));
  CheckEquals(-1, Str.IndexOf('s', 8, 2));
  CheckEquals(10, Str.IndexOf('s', 8, 3));
  CheckEquals(-1, Str.IndexOf('s', 8, 1));

  Str := '';
  CheckEquals(-1, Str.IndexOf('s'));
  CheckEquals(-1, Str.IndexOf('s', 0, 0));

  { Unicode combining test }
  Str := TEST_CPS + TEST_STR;
  CheckEquals(14, Str.IndexOf('s', 12, 3));
end;

procedure TTestUnicodeStringHelper.TestIndexOfAny;
var
  Str: UnicodeString;
begin
  Str := TEST_STR;

  CheckEquals(3, Str.IndexOfAny(['w', 's', 'a']));
  CheckEquals(6, Str.IndexOfAny(['w', 's', 'a'], 4));
  CheckEquals(-1, Str.IndexOfAny(['w', 's', 'a'], 4, 2));
  CheckEquals(6, Str.IndexOfAny(['w', 's', 'a'], 4, 3));
  CheckEquals(-1, Str.IndexOfAny([]));

  Str := '';
  CheckEquals(-1, Str.IndexOfAny(['w', 's', 'a']));
  CheckEquals(-1, Str.IndexOfAny(['T'], 0, 0));

  { Unicode combining test }
  Str := TEST_CPS + TEST_STR;
  CheckEquals(10, Str.IndexOfAny(['w', 's', 'a'], 8, 3));
end;

procedure TTestUnicodeStringHelper.TestInsert;
var
  Str1, Str2: UnicodeString;
begin
  Str1 := 'This a string.';
  Str2 := '';

  CheckEquals(TEST_STR, Str1.Insert(5, 'is '));
  CheckEquals(UnicodeString('Yes. This is a string.'), Str1.Insert(0, 'Yes. '));
  CheckEquals(UnicodeString('Yes. This is a string.!'), Str1.Insert(22, '!'));
  CheckEquals(UnicodeString('Yes. This is a string.!!'), Str1.Insert(100, '!'));

  CheckEquals(UnicodeString('@'), Str2.Insert(0, '@'));

  { Unicode combining test }
  Str1 := TEST_CPS + 'This a string.';
  CheckEquals(TEST_CPS + TEST_STR, Str1.Insert(9, 'is '));
end;

procedure TTestUnicodeStringHelper.TestIsDelimiter;
var
  Str: UnicodeString;
begin
  Str := '';
  CheckFalse(Str.IsDelimiter('is', 0));

  Str := TEST_STR;
  CheckTrue(Str.IsDelimiter('is', 5));
  CheckTrue(Str.IsDelimiter('is', 6));
  CheckFalse(Str.IsDelimiter('is', 7));
  CheckFalse(Str.IsDelimiter('is', 20));

  { Unicode combining test }
  Str := TEST_CPS + TEST_STR;
  CheckTrue(Str.IsDelimiter('is', 10));
end;

procedure TTestUnicodeStringHelper.TestEmpty;
var
  Str: UnicodeString;
begin
  Str := '';
  CheckTrue(Str.IsEmpty);
  CheckTrue(UnicodeString.IsNullOrEmpty(Str));
  CheckTrue(UnicodeString.IsNullOrWhiteSpace(Str));

  Str := #0;
  CheckFalse(Str.IsEmpty);
  CheckFalse(UnicodeString.IsNullOrEmpty(Str));
  CheckTrue(UnicodeString.IsNullOrWhiteSpace(Str));

  Str := TEST_STR;
  CheckFalse(Str.IsEmpty);
  CheckFalse(UnicodeString.IsNullOrEmpty(Str));
  CheckFalse(UnicodeString.IsNullOrWhiteSpace(Str));

  Str := #$00#$01#$02#$03#$04#$05#$06#$07#$08#$09#$0a#$0b#$0c#$0d#$0e#$0f#$10+
    #$11#$12#$13#$14#$5#$6#$7#$8#$9#$1a#$1b#$1c#$1d#$1e#$1f#$20;
  CheckTrue(UnicodeString.IsNullOrWhiteSpace(Str));
end;

procedure TTestUnicodeStringHelper.JoinOffRange;
begin
  UnicodeString.Join(',', ['String1', 'String2', 'String3'], 3, 2);
end;

procedure TTestUnicodeStringHelper.TestJoin;
var
  UStr: UnicodeString;
begin
  CheckEquals(UnicodeString(''),
    UnicodeString.Join(',', [], 0, 0));
  CheckEquals(UnicodeString('String1,String2,String3'),
    UnicodeString.Join(',', ['String1', 'String2', 'String3']));
  CheckEquals(UnicodeString('String1String2String3'),
    UnicodeString.Join('', ['String1', 'String2', 'String3']));
  CheckEquals(UnicodeString('String1->String2->String3'),
    UnicodeString.Join('->', ['String1', 'String2', 'String3']));
  CheckEquals(UnicodeString('String2,String3'),
    UnicodeString.Join(',', ['String1', 'String2', 'String3'], 1, 2));
  CheckException({$IFDEF FPC}@JoinOffRange{$ELSE}JoinOffRange{$ENDIF}, ERangeError);
  CheckEquals(UnicodeString('String1'),
    UnicodeString.Join(',', ['String1', 'String2', 'String3'], 0, 1));
  CheckEquals(UnicodeString(''),
    UnicodeString.Join(',', ['String1', 'String2', 'String3'], 0, 0));

  UStr := 'Строка';
  CheckEquals(
    UnicodeString('String,Строка,True,10,') + UnicodeString(SysUtils.FloatToStr(3.14)) + UnicodeString(',TTestUnicodeStringHelper'),
    UnicodeString.Join(',', ['String', UStr, True, 10, 3.14, Self])
  );
end;

procedure TTestUnicodeStringHelper.TestLastDelimiter;
var
  Str: UnicodeString;
begin
  Str := '';
  CheckEquals(-1, Str.LastDelimiter('is'));

  Str := TEST_STR;
  CheckEquals(13, Str.LastDelimiter('is'));

  { Unicode combining test }
  Str := TEST_CPS + TEST_STR;
  CheckEquals(17, Str.LastDelimiter('is'));
end;

procedure TTestUnicodeStringHelper.TestLastIndexOf;
var
  Str: UnicodeString;
begin
  Str := TEST_STR;

  CheckEquals(-1, Str.LastIndexOf(TUChar('s'), 16, 5));
  CheckEquals(16, Str.LastIndexOf(TUChar('.')));
  CheckEquals(-1, Str.LastIndexOf(TUChar('?')));
  CheckEquals(-1, Str.LastIndexOf(TUChar('s'), 8, 2));
  CheckEquals(6, Str.LastIndexOf(TUChar('s'), 8, 3));
  CheckEquals(-1, Str.LastIndexOf(TUChar('s'), 8, 1));

  CheckEquals(-1, Str.LastIndexOf(UnicodeString('s'), 16, 5));
  CheckEquals(5, Str.LastIndexOf(UnicodeString('is'), 16));
  CheckEquals(16, Str.LastIndexOf(UnicodeString('.')));
  CheckEquals(-1, Str.LastIndexOf(UnicodeString('?')));
  CheckEquals(-1, Str.LastIndexOf(UnicodeString('')));
  CheckEquals(-1, Str.LastIndexOf(UnicodeString('s'), 8, 2));
  CheckEquals(6, Str.LastIndexOf(UnicodeString('s'), 8, 3));
  CheckEquals(-1, Str.LastIndexOf(UnicodeString('s'), 8, 1));

  Str := '';
  CheckEquals(-1, Str.LastIndexOf(TUChar('s')));
  CheckEquals(-1, Str.LastIndexOf(TUChar('s'), 0, 0));

  CheckEquals(-1, Str.LastIndexOf(UnicodeString('s')));
  CheckEquals(-1, Str.LastIndexOf(UnicodeString('s'), 0, 0));

  { Unicode combining test }
  Str := TEST_CPS + TEST_STR;
  CheckEquals(3, Str.LastIndexOf(TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE));
  CheckEquals(10, Str.LastIndexOf(TUChar('s'), 12, 3));
end;

procedure TTestUnicodeStringHelper.TestLastIndexOfAny;
var
  Str: UnicodeString;
begin
  Str := TEST_STR;

  CheckEquals(0, Str.LastIndexOfAny(['T'], 0));
  CheckEquals(-1, Str.LastIndexOfAny(['T'], 0, 0));
  CheckEquals(0, Str.LastIndexOfAny(['T'], 0, 1));
  CheckEquals(10, Str.LastIndexOfAny(['w', 's', 'a']));
  CheckEquals(10, Str.LastIndexOfAny(['w', 's', 'a'], 11));
  CheckEquals(10, Str.LastIndexOfAny(['w', 's', 'a'], 11, 2));
  CheckEquals(-1, Str.LastIndexOfAny(['w', 's', 'a'], 11, 1));
  CheckEquals(3, Str.LastIndexOfAny(['w', 's', 'a'], 4, 2));
  CheckEquals(-1, Str.LastIndexOfAny(['w', 's', 'a'], 4, 1));
  CheckEquals(-1, Str.LastIndexOfAny(['w', 's', 'a'], 4, 0));
  CheckEquals(-1, Str.LastIndexOfAny([]));

  Str := '';
  CheckEquals(-1, Str.LastIndexOfAny(['w', 's', 'a']));
  CheckEquals(-1, Str.LastIndexOfAny(['T'], 0, 0));

  { Unicode combining test }
  Str := TEST_STR + TEST_CPS;
  CheckEquals(10, Str.LastIndexOfAny([TEST_CP_LATIN_SMALL_LETTER_S], 11));
end;

procedure TTestUnicodeStringHelper.TestLowerCase;
begin
  CheckEquals('testАБВГ', UnicodeString.LowerCase('TESTАБВГ', loInvariantLocale));
  CheckEquals('testабвг', UnicodeString.LowerCase('TESTАБВГ', loUserLocale));
end;

procedure TTestUnicodeStringHelper.TestPadding;
var
  Str1, Str2: UnicodeString;
begin
  Str1 := '';
  Str2 := '';
  CheckEquals(UnicodeString(''), Str1.PadLeft(0));
  CheckEquals(UnicodeString('  '), Str1.PadLeft(2));
  CheckEquals(UnicodeString(''), Str2.PadRight(0));
  CheckEquals(UnicodeString('  '), Str2.PadRight(2));

  Str1 := '12345';
  Str2 := '123';

  CheckEquals(UnicodeString('12345'), Str1.PadLeft(5));
  CheckEquals(UnicodeString('  123'), Str2.PadLeft(5));
  CheckEquals(UnicodeString('123'), Str2.PadLeft(0));

  CheckEquals(UnicodeString('12345'), Str1.PadRight(5));
  CheckEquals(UnicodeString('123  '), Str2.PadRight(5));
  CheckEquals(UnicodeString('123'), Str2.PadRight(0));
end;

procedure TTestUnicodeStringHelper.TestQuotedString;
var
  Str1: UnicodeString;
begin
  Str1 := 'This function illustrates the functionality of the QuotedString method.';
  CheckEquals(UnicodeString('''This function illustrates the functionality of the QuotedString method.'''), Str1.QuotedString);
  CheckEquals(UnicodeString('fThis ffunction illustrates the ffunctionality off the QuotedString method.f'), Str1.QuotedString(TUChar('f')));
end;

procedure TTestUnicodeStringHelper.TestRemove;
var
  Str: UnicodeString;
begin
  Str := TEST_STR;

  CheckEquals(UnicodeString('This'), Str.Remove(4));
  CheckEquals(UnicodeString('This string.'), Str.Remove(5, 5));

  { Unicode combining test }
  Str := 'This is ' + TEST_CPS + ' string.';
  CheckEquals(UnicodeString('This is string.'), Str.Remove(8, 5));
end;

procedure TTestUnicodeStringHelper.TestReplace;
var
  Str: UnicodeString;
begin
  Str := TEST_STR;

  CheckEquals(UnicodeString('This is one string.'), Str.Replace('a', 'one'));
  CheckEquals(UnicodeString('This is 1 string.'), Str.Replace(
    TUChar('a'),
    TUChar('1'))
  );
end;

procedure TTestUnicodeStringHelper.TestSplit;
var
  Str1: UnicodeString;
  ResList: {$IFDEF FPC}specialize{$ENDIF} TArray<UnicodeString>;
begin
  Str1 := 'one, two, and three., four';

  ResList := Str1.Split([#$2c{','}]);
  CheckEquals(4, Length(ResList));
  CheckEquals(UnicodeString('one'), ResList[0]);
  CheckEquals(UnicodeString(' two'), ResList[1]);
  CheckEquals(UnicodeString(' and three.'), ResList[2]);
  CheckEquals(UnicodeString(' four'), ResList[3]);

  ResList := Str1.Split([',']);
  CheckEquals(4, Length(ResList));
  CheckEquals(UnicodeString('one'), ResList[0]);
  CheckEquals(UnicodeString(' two'), ResList[1]);
  CheckEquals(UnicodeString(' and three.'), ResList[2]);
  CheckEquals(UnicodeString(' four'), ResList[3]);

  ResList := Str1.Split([#$2c{','}], 2);
  CheckEquals(2, Length(ResList));
  CheckEquals(UnicodeString('one'), ResList[0]);
  CheckEquals(UnicodeString(' two'), ResList[1]);

  ResList := Str1.Split([','], 2);
  CheckEquals(2, Length(ResList));
  CheckEquals(UnicodeString('one'), ResList[0]);
  CheckEquals(UnicodeString(' two'), ResList[1]);

  ResList := Str1.Split([#$2c{','}, #$2e{'.'}]);
  CheckEquals(5, Length(ResList));
  CheckEquals(UnicodeString('one'), ResList[0]);
  CheckEquals(UnicodeString(' two'), ResList[1]);
  CheckEquals(UnicodeString(' and three'), ResList[2]);
  CheckEquals(UnicodeString(''), ResList[3]);
  CheckEquals(UnicodeString(' four'), ResList[4]);

  ResList := Str1.Split([TUChar(#$2c){','}, TUChar(#$2e){'.'}], TStringSplitOptions.None);
  CheckEquals(5, Length(ResList));
  CheckEquals(UnicodeString('one'), ResList[0]);
  CheckEquals(UnicodeString(' two'), ResList[1]);
  CheckEquals(UnicodeString(' and three'), ResList[2]);
  CheckEquals(UnicodeString(''), ResList[3]);
  CheckEquals(UnicodeString(' four'), ResList[4]);

  ResList := Str1.Split([TUChar(#$2c){','}, TUChar(#$2e){'.'}], TStringSplitOptions.ExcludeEmpty);
  CheckEquals(4, Length(ResList));
  CheckEquals(UnicodeString('one'), ResList[0]);
  CheckEquals(UnicodeString(' two'), ResList[1]);
  CheckEquals(UnicodeString(' and three'), ResList[2]);
  CheckEquals(UnicodeString(' four'), ResList[3]);

  ResList := Str1.Split([UnicodeString(','), UnicodeString('.'), 'and'], TStringSplitOptions.ExcludeEmpty);
  CheckEquals(5, Length(ResList));
  CheckEquals(UnicodeString('one'), ResList[0]);
  CheckEquals(UnicodeString(' two'), ResList[1]);
  CheckEquals(UnicodeString(' '), ResList[2]);
  CheckEquals(UnicodeString(' three'), ResList[3]);
  CheckEquals(UnicodeString(' four'), ResList[4]);

  ResList := Str1.Split([UnicodeString(','), UnicodeString('.'), 'and'], 5, TStringSplitOptions.None);
  CheckEquals(5, Length(ResList));
  CheckEquals(UnicodeString('one'), ResList[0]);
  CheckEquals(UnicodeString(' two'), ResList[1]);
  CheckEquals(UnicodeString(' '), ResList[2]);
  CheckEquals(UnicodeString(' three'), ResList[3]);
  CheckEquals(UnicodeString(''), ResList[4]);

  Str1 := ',one, two, and three., four,';
  ResList := Str1.Split([#$2c{','}]);
  CheckEquals(5, Length(ResList));
  CheckEquals(UnicodeString(''), ResList[0]);
  CheckEquals(UnicodeString('one'), ResList[1]);
  CheckEquals(UnicodeString(' two'), ResList[2]);
  CheckEquals(UnicodeString(' and three.'), ResList[3]);
  CheckEquals(UnicodeString(' four'), ResList[4]);

  Str1 := '不one不 two不 and three.不 four不';
  ResList := Str1.Split([TUChar('不')]);
  CheckEquals(5, Length(ResList));
  CheckEquals(UnicodeString(''), ResList[0]);
  CheckEquals(UnicodeString('one'), ResList[1]);
  CheckEquals(UnicodeString(' two'), ResList[2]);
  CheckEquals(UnicodeString(' and three.'), ResList[3]);
  CheckEquals(UnicodeString(' four'), ResList[4]);
end;

procedure TTestUnicodeStringHelper.TestStartsWith;
var
  Str1: UnicodeString;
begin
  Str1 := TEST_STR;

  CheckTrue(Str1.StartsWith('This'));
  CheckFalse(Str1.StartsWith('THIS', False));
  CheckTrue(Str1.StartsWith('THIS', True));
end;

procedure TTestUnicodeStringHelper.TestSubstring;
var
  Str: UnicodeString;
begin
  Str := 'This is a string.';

  CheckEquals(UnicodeString('is a string.'), Str.Substring(5));
  CheckEquals(UnicodeString('is'), Str.Substring(5, 2));
  CheckEquals(UnicodeString('.'), Str.Substring(16));
  CheckEquals(UnicodeString(''), Str.Substring(17));
  CheckEquals(UnicodeString(''), Str.Substring(17, 10));
  CheckEquals(UnicodeString('This is a string.'), Str.Substring(0));

  { Unicode combining test }
  Str := 'This ' + TEST_CPS + 'is a string.';
  CheckEquals(UnicodeString('is a string.'), Str.Substring(9));
end;

procedure TTestUnicodeStringHelper.ToBooleanEmpty;
begin
  UnicodeString.ToBoolean('');
end;

procedure TTestUnicodeStringHelper.TestToBoolean;
var
  Str: UnicodeString;
begin
  Str := '0';
  CheckFalse(Str.ToBoolean);

  CheckFalse(UnicodeString.ToBoolean('0'));
  CheckFalse(UnicodeString.ToBoolean('000'));
  CheckFalse(UnicodeString.ToBoolean('0' + TUChar(FormatSettings.DecimalSeparator) + '0'));
  CheckFalse(UnicodeString.ToBoolean('-00' + TUChar(FormatSettings.DecimalSeparator) + '00'));
  CheckFalse(UnicodeString.ToBoolean('+00' + TUChar(FormatSettings.DecimalSeparator) + '00'));
  CheckFalse(UnicodeString.ToBoolean('00' + TUChar(FormatSettings.DecimalSeparator) + '00'));
  CheckTrue(UnicodeString.ToBoolean('-1'));
  CheckTrue(UnicodeString.ToBoolean('1'));
  CheckTrue(UnicodeString.ToBoolean('123'));
  CheckTrue(UnicodeString.ToBoolean('11' + TUChar(FormatSettings.DecimalSeparator) + '12'));
  CheckTrue(UnicodeString.ToBoolean(UnicodeString(SysUtils.TrueBoolStrs[0])));
  CheckFalse(UnicodeString.ToBoolean(UnicodeString(SysUtils.FalseBoolStrs[0])));
  CheckTrue(UnicodeString.ToBoolean('TRUE'));
  CheckException({$IFDEF FPC}@ToBooleanEmpty{$ELSE}ToBooleanEmpty{$ENDIF}, EConvertError);
end;

procedure TTestUnicodeStringHelper.TestToCharArray;
var
  Str: UnicodeString;
  CharList: {$IFDEF FPC}specialize{$ENDIF} TArray<TUChar>;
begin
  Str := '123';

  CharList := Str.ToCharArray;
  CheckEquals(3, Length(CharList));
  CheckEquals(TUChar('1'), CharList[0]);
  CheckEquals(TUChar('2'), CharList[1]);
  CheckEquals(TUChar('3'), CharList[2]);

  CharList := Str.ToCharArray(1, 2);
  CheckEquals(2, Length(CharList));
  CheckEquals(TUChar('2'), CharList[0]);
  CheckEquals(TUChar('3'), CharList[1]);

  CharList := Str.ToCharArray(0, 0);
  CheckEquals(0, Length(CharList));

  { Unicode combining test }
  CharList := TEST_CPS.ToCharArray;
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S, CharList[0]);
  CheckEquals(TEST_CP_COMBINING_DOT_BELOW, CharList[1]);
  CheckEquals(TEST_CP_COMBINING_DOT_ABOVE, CharList[2]);
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE, CharList[3]);
end;

{$IFNDEF FPUNONE}
{$IFDEF FPC_HAS_TYPE_DOUBLE}
procedure TTestUnicodeStringHelper.TDoubleEmpty;
begin
  UnicodeString.ToDouble('');
end;

procedure TTestUnicodeStringHelper.TestToDouble;
var
  Str, StrVal: UnicodeString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToDouble);

  StrVal := '1' + TUChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat({$IFDEF FPC}AnsiString({$ENDIF}StrVal{$IFDEF FPC}){$ENDIF}), UnicodeString.ToDouble(StrVal));
  StrVal := '-0' + TUChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat({$IFDEF FPC}AnsiString({$ENDIF}StrVal{$IFDEF FPC}){$ENDIF}), UnicodeString.ToDouble(StrVal));
  CheckException({$IFDEF FPC}@TDoubleEmpty{$ELSE}TDoubleEmpty{$ENDIF}, EConvertError);
end;
{$ELSE}
procedure TTestUnicodeStringHelper.TestToDouble;
begin
  Ignore('Double type is not supported.')
end;
{$ENDIF !FPC_HAS_TYPE_DOUBLE}
{$IF DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE)}
procedure TTestUnicodeStringHelper.TExtendedEmpty;
begin
  UnicodeString.ToExtended('');
end;

procedure TTestUnicodeStringHelper.TestToExtended;
var
  Str, StrVal: UnicodeString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToExtended);

  StrVal := '1' + TUChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat({$IFDEF FPC}AnsiString({$ENDIF}StrVal{$IFDEF FPC}){$ENDIF}), UnicodeString.ToExtended(StrVal));
  StrVal := '-0' + TUChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat({$IFDEF FPC}AnsiString({$ENDIF}StrVal{$IFDEF FPC}){$ENDIF}), UnicodeString.ToExtended(StrVal));
  CheckException({$IFDEF FPC}@TExtendedEmpty{$ELSE}TExtendedEmpty{$ENDIF}, EConvertError);
end;
{$ELSE}
procedure TTestUnicodeStringHelper.TestToExtended;
begin
  Ignore('Extended type is not supported.');
end;
{$IFEND !FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
{$IFDEF FPC_HAS_TYPE_SINGLE}
procedure TTestUnicodeStringHelper.TSingleEmpty;
begin
  UnicodeString.ToSingle('');
end;

procedure TTestUnicodeStringHelper.TestToSingle;
var
  Str, StrVal: UnicodeString;
begin
  Str := '1';
  CheckEquals(StrToFloat('1'), Str.ToSingle);

  StrVal := '1' + TUChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat({$IFDEF FPC}AnsiString({$ENDIF}StrVal{$IFDEF FPC}){$ENDIF}), UnicodeString.ToSingle(StrVal));
  StrVal := '-0' + TUChar(FormatSettings.DecimalSeparator) + '5';
  CheckEquals(StrToFloat({$IFDEF FPC}AnsiString({$ENDIF}StrVal{$IFDEF FPC}){$ENDIF}), UnicodeString.ToSingle(StrVal));
  CheckException({$IFDEF FPC}@TSingleEmpty{$ELSE}TSingleEmpty{$ENDIF}, EConvertError);
end;
{$ELSE}
procedure TTestUnicodeStringHelper.TestToSingle;
begin
  Ignore('Single type is not supported.');
end;
{$ENDIF !FPC_HAS_TYPE_SINGLE}
{$ENDIF !~FPUNONE}

procedure TTestUnicodeStringHelper.TIntegerEmpty;
begin
  UnicodeString.ToInteger('');
end;

procedure TTestUnicodeStringHelper.TIntegerToBig;
begin
  UnicodeString.ToInteger('3000000000');
end;

procedure TTestUnicodeStringHelper.TestToInteger;
var
  Str: UnicodeString;
begin
  Str := '1';
  CheckEquals(1, Str.ToInteger);

  CheckEquals(2, UnicodeString.ToInteger('2'));
  CheckEquals(-1, UnicodeString.ToInteger('-1'));
  CheckException({$IFDEF FPC}@TIntegerEmpty{$ELSE}TIntegerEmpty{$ENDIF}, EConvertError);
  CheckException({$IFDEF FPC}@TIntegerToBig{$ELSE}TIntegerToBig{$ENDIF}, EConvertError);
end;

procedure TTestUnicodeStringHelper.TestToLower;
var
  Str: UnicodeString;
begin
  Str := '123ONE';
  CheckEquals(UnicodeString('123one'), Str.ToLower);

  {$IFDEF WINDOWS}
  Str := 'ONEОДИН不怕当小白鼠';
  CheckEquals(UnicodeString('oneодин不怕当小白鼠'), Str.ToLower($0409)); { English - United States }
  CheckEquals(UnicodeString('oneодин不怕当小白鼠'), Str.ToLower($0419)); { Russian }

  { See http://lotusnotus.com/lotusnotus_en.nsf/dx/dotless-i-tolowercase-and-touppercase-functions-use-responsibly.htm }
  Str := 'TITLE';
  CheckEquals(UnicodeString('tıtle'), Str.ToLower($041f)); { Turkish }
  Str := 'TİTLE';
  CheckEquals(UnicodeString('title'), Str.ToLower($041f)); { Turkish }
  {$ENDIF !WINDOWS}
end;

procedure TTestUnicodeStringHelper.TestToLowerInvariant;
var
  Str: UnicodeString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(UnicodeString('hello привет allô 您好 123'), Str.ToLowerInvariant);
end;

procedure TTestUnicodeStringHelper.TestToUpper;
var
  Str: UnicodeString;
begin
  Str := '123one';
  CheckEquals(UnicodeString('123ONE'), Str.ToUpper);

  {$IFDEF WINDOWS}
  Str := 'oneодин不怕当小白鼠';
  CheckEquals(UnicodeString('ONEОДИН不怕当小白鼠'), Str.ToUpper($0409)); { English - United States }
  CheckEquals(UnicodeString('ONEОДИН不怕当小白鼠'), Str.ToUpper($0419)); { Russian }

  { See http://lotusnotus.com/lotusnotus_en.nsf/dx/dotless-i-tolowercase-and-touppercase-functions-use-responsibly.htm }
  Str := 'tıtle';
  CheckEquals(UnicodeString('TITLE'), Str.ToUpper($041f)); { Turkish }
  Str := 'title';
  CheckEquals(UnicodeString('TİTLE'), Str.ToUpper($041f)); { Turkish }
  {$ENDIF !WINDOWS}
end;

procedure TTestUnicodeStringHelper.TestToUpperInvariant;
var
  Str: UnicodeString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(UnicodeString('HELLO ПРИВЕТ ALLÔ 您好 123'), Str.ToUpperInvariant);
end;

procedure TTestUnicodeStringHelper.TestTrim;
var
  Str1, Str2, Str3: UnicodeString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals(UnicodeString(''), Str1.Trim);
  CheckEquals(UnicodeString('test'), Str2.Trim);
  CheckEquals(UnicodeString('test'), Str3.Trim);
  CheckEquals(UnicodeString('es'), Str2.Trim(['t']));
  CheckEquals(UnicodeString('s'), Str2.Trim(['t', 'e']));
  CheckEquals(UnicodeString(''), Str2.Trim(['t', 'e', 's', '@']));
  CheckEquals(UnicodeString('  test  '), Str3.Trim(['t', 'e', 's', '@']));
end;

procedure TTestUnicodeStringHelper.TestTrimLeft;
var
  Str1, Str2, Str3: UnicodeString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals(UnicodeString(''), Str1.TrimLeft);
  CheckEquals(UnicodeString('test'), Str2.TrimLeft);
  CheckEquals(UnicodeString('test  '), Str3.TrimLeft);
  CheckEquals(UnicodeString('est'), Str2.TrimLeft(['t']));
  CheckEquals(UnicodeString('st'), Str2.TrimLeft(['t', 'e']));
  CheckEquals(UnicodeString(''), Str2.TrimLeft(['t', 'e', 's', '@']));
  CheckEquals(UnicodeString('  test  '), Str3.TrimLeft(['t', 'e', 's', '@']));
end;

procedure TTestUnicodeStringHelper.TestTrimRight;
var
  Str1, Str2, Str3: UnicodeString;
begin
  Str1 := '';
  Str2 := 'test';
  Str3 := '  test  ';

  CheckEquals(UnicodeString(''), Str1.TrimRight);
  CheckEquals(UnicodeString('test'), Str2.TrimRight);
  CheckEquals(UnicodeString('  test'), Str3.TrimRight);
  CheckEquals(UnicodeString('tes'), Str2.TrimRight(['t']));
  CheckEquals(UnicodeString('te'), Str2.TrimRight(['t', 's']));
  CheckEquals(UnicodeString(''), Str2.TrimRight(['t', 'e', 's', '@']));
  CheckEquals(UnicodeString('  test  '), Str3.TrimRight(['t', 'e', 's', '@']));
end;

procedure TTestUnicodeStringHelper.TestUpperCase;
begin
  CheckEquals('TESTабвг', UnicodeString.UpperCase('testабвг', loInvariantLocale));
  CheckEquals('TESTАБВГ', UnicodeString.UpperCase('testабвг', loUserLocale));
end;

procedure TTestUnicodeStringHelper.TestChars;
var
  Str: UnicodeString;
begin
  Str := '不怕当小白鼠';

  CheckEquals(TUChar('不'), Str.Chars[0]);
  CheckEquals(TUChar('怕'), Str.Chars[1]);
  CheckEquals(TUChar('当'), Str.Chars[2]);
  CheckEquals(TUChar('小'), Str.Chars[3]);
  CheckEquals(TUChar('白'), Str.Chars[4]);
  CheckEquals(TUChar('鼠'), Str.Chars[5]);

  { Unicode combining test }
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S, TEST_CPS.Chars[0]);
  CheckEquals(TEST_CP_COMBINING_DOT_BELOW, TEST_CPS.Chars[1]);
  CheckEquals(TEST_CP_COMBINING_DOT_ABOVE, TEST_CPS.Chars[2]);
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE, TEST_CPS.Chars[3]);
end;

procedure TTestUnicodeStringHelper.TestLength;
var
  {$IFDEF FPC}
  AnsiStr: AnsiString;
  {$ENDIF !FPC}
  Str: UnicodeString;
begin
  {$IFDEF FPC}
  AnsiStr := 'hello';
  CheckEquals(5, AnsiStr.Length);
  {$ENDIF !FPC}

  Str := '不怕当小白鼠';
  CheckEquals(6, Str.Length);

  { Unicode combining test }
  CheckEquals(4, TEST_CPS.Length);
end;

{$IF DEFINED(FPC) OR DEFINED(DELPHI_XE4_PLUS)}
procedure TTestUnicodeStringHelper.TestParse;
begin
  CheckEquals(UnicodeString('-1'), UnicodeString.Parse(Integer(-1)));
  CheckEquals(UnicodeString('3000000000'), UnicodeString.Parse(TEST_INT64));
  CheckEquals(UnicodeString('-1'), UnicodeString.Parse(True));
  CheckEquals(UnicodeString('0'), UnicodeString.Parse(False));
  {$IF NOT DEFINED(FPUNONE) AND (DEFINED(FPC_HAS_TYPE_EXTENDED) OR DEFINED(FPC_HAS_TYPE_DOUBLE))}
  CheckEquals(UnicodeString(FloatToStr(1.5)), UnicodeString.Parse(1.5));
  {$ELSE}
  Ignore('Extended/Double type is not supported.');
  {$IFEND !~FPUNONE FPC_HAS_TYPE_EXTENDED FPC_HAS_TYPE_DOUBLE}
end;
{$IFEND !FPC DELPHI_XE4_PLUS}

{$IF DEFINED(FPC) OR DEFINED(DELPHI_XE8_PLUS)}
procedure TTestUnicodeStringHelper.TInt64Empty;
begin
  UnicodeString.ToInt64('');
end;

procedure TTestUnicodeStringHelper.TInt64ToBig;
begin
  UnicodeString.ToInt64('9223372036854775808');
end;

procedure TTestUnicodeStringHelper.TestToInt64;
var
  Str: UnicodeString;
begin
  Str := '3000000000';
  CheckTrue(TEST_INT64 = Str.ToInt64);

  CheckTrue(TEST_INT64 = UnicodeString.ToInt64('3000000000'));
  CheckTrue(-TEST_INT64 = UnicodeString.ToInt64('-3000000000'));
  CheckException({$IFDEF FPC}@TInt64Empty{$ELSE}TInt64Empty{$ENDIF}, EConvertError);
  CheckException({$IFDEF FPC}@TInt64ToBig{$ELSE}TInt64ToBig{$ENDIF}, EConvertError);
end;

procedure TTestUnicodeStringHelper.TestIndexOfAnyUnquoted;
var
  Str: UnicodeString;
begin
  Str := '"This" is it';
  CheckEquals(7, Str.IndexOfAnyUnquoted(['i'], '"', '"'));

  Str := '"This is it';
  CheckEquals(-1, Str.IndexOfAnyUnquoted(['i'], '"', '"'));

  Str := '"This" "is" "it"';
  CheckEquals(-1, Str.IndexOfAnyUnquoted(['i'], '"', '"'));

  Str := '<This <is>> it';
  CheckEquals(12, Str.IndexOfAnyUnquoted(['i'], '<', '>'));

  Str := '"This" is it';
  CheckEquals(3, Str.IndexOfAnyUnquoted(['i'], '"', '"', 1)); //!!! 2 in http://docwiki.embarcadero.com/Libraries/Seattle/en/System.SysUtils.TStringHelper.IndexOfAnyUnquoted

  Str := 'This" "is" "it';
  CheckEquals(-1, Str.IndexOfAnyUnquoted(['i'], '"', '"', 5));

  CheckEquals(-1, Str.IndexOfAnyUnquoted([], '"', '"'));

  Str := '';
  CheckEquals(-1, Str.IndexOfAnyUnquoted([], '"', '"'));
  CheckEquals(-1, Str.IndexOfAnyUnquoted(['w', 's', 'a'], '"', '"'));
  CheckEquals(-1, Str.IndexOfAnyUnquoted(['T'], '"', '"', 0, 0));

  { Unicode combining test }
  Str := '"This" ' + TEST_CPS + ' is it';
  CheckEquals(12, Str.IndexOfAnyUnquoted(['i'], '"', '"'));
end;
{$IFEND !FPC DELPHI_XE8_PLUS}

{$IFDEF FPC}
{ Non Delphi }

procedure TTestUnicodeStringHelper.TestByteLength;
var
  Str: UnicodeString;
begin
  Str := '不怕当小白鼠';

  CheckEquals(12, Str.ByteLength);
end;

procedure TTestUnicodeStringHelper.TestCPLength;
var
  Str: UnicodeString;
begin
  Str := '不怕当小白鼠';

  CheckEquals(6, Str.CPLength);

  { Unicode combining test }
  CheckEquals(4, TEST_CPS.CPLength);
end;

procedure TTestUnicodeStringHelper.TestCodePoints;
var
  Str: UnicodeString;
begin
  Str := '不怕当小白鼠';

  CheckEquals(TUChar('不'), Str.CodePoints[0]);
  CheckEquals(TUChar('怕'), Str.CodePoints[1]);
  CheckEquals(TUChar('当'), Str.CodePoints[2]);
  CheckEquals(TUChar('小'), Str.CodePoints[3]);
  CheckEquals(TUChar('白'), Str.CodePoints[4]);
  CheckEquals(TUChar('鼠'), Str.CodePoints[5]);

  { Unicode combining test }
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S, TEST_CPS.CodePoints[0]);
  CheckEquals(TEST_CP_COMBINING_DOT_BELOW, TEST_CPS.CodePoints[1]);
  CheckEquals(TEST_CP_COMBINING_DOT_ABOVE, TEST_CPS.CodePoints[2]);
  CheckEquals(TEST_CP_LATIN_SMALL_LETTER_S_WITH_DOT_BELOW_AND_DOT_ABOVE, TEST_CPS.CodePoints[3]);
end;
{$ENDIF !FPC}
{$ELSE}
procedure TTestUnicodeStringHelper.NotSupported;
begin
  Ignore('UnicodeString is not supported.');
end;
{$ENDIF !FPC_HAS_FEATURE_UNICODESTRINGS}

initialization
  { Initialization of TrueBoolStrs/FalseBoolStrs arrays }
  SysUtils.BoolToStr(True, True);
  RegisterTest('System.Helpers', TTestUnicodeStringHelper.Suite);
{$IFEND !FPC DELPHI_XE3_PLUS}

end.

