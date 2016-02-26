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

procedure TTestAnsiStringHelper.TestEquals;
var
  Str1, Str2: AnsiString;
begin
  Str1 := 'A';
  Str2 := 'A';

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

  CheckEquals(TEST_STR, AnsiString.Format(Str1, ['string.']));
  CheckEquals(TEST_STR, AnsiString.Format(Str1, [AnsiString(Str2)]));
end;

procedure TTestAnsiStringHelper.TestEmpty;
var
  Str: AnsiString;
begin
  Str := '';
  CheckTrue(Str.IsEmpty);
  CheckTrue(AnsiString.IsNullOrEmpty(Str));
  CheckTrue(AnsiString.IsNullOrWhiteSpace(Str));

  Str := #0;
  CheckFalse(Str.IsEmpty);
  CheckFalse(AnsiString.IsNullOrEmpty(Str));
  CheckTrue(AnsiString.IsNullOrWhiteSpace(Str));

  Str := TEST_STR;
  CheckFalse(Str.IsEmpty);
  CheckFalse(AnsiString.IsNullOrEmpty(Str));
  CheckFalse(AnsiString.IsNullOrWhiteSpace(Str));

  Str := #$00#$01#$02#$03#$04#$05#$06#$07#$08#$09#$0a#$0b#$0c#$0d#$0e#$0f#$10+
    #$11#$12#$13#$14#$5#$6#$7#$8#$9#$1a#$1b#$1c#$1d#$1e#$1f#$20;
  CheckTrue(AnsiString.IsNullOrWhiteSpace(Str));
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
  Str: AnsiString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(AnsiString('hello привет allô 您好 123'), Str.ToLowerInvariant);
end;

procedure TTestAnsiStringHelper.TestToUpperInvariant;
var
  Str: AnsiString;
begin
  Str := 'HeLlo ПрИвЕт aLlÔ 您好 123';
  CheckEquals(AnsiString('HELLO ПРИВЕТ ALLÔ 您好 123'), Str.ToUpperInvariant);
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
  CheckTrue(TEST_INT64 = Str.ToInt64);

  CheckTrue(TEST_INT64 = AnsiString.ToInt64('3000000000'));
  CheckTrue(-TEST_INT64 = AnsiString.ToInt64('-3000000000'));
  CheckException(TInt64Empty, EConvertError);
  CheckException(TInt64ToBig, EConvertError);
end;

initialization
  RegisterTest('System.Helpers', TTestAnsiStringHelper.Suite);

end.

