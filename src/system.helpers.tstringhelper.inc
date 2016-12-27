{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{ TShortStringHelper, TAnsiStringHelper, TRawByteStringHelper,
  TUTF8StringHelper, TWideStringHelper, TUnicodeStringHelper }

class function TWideStringHelper.HaveChar(AChar: WideChar; const AList:
  array of WideChar): Boolean;
var
  i: TDynArrayIndex;
begin
  i := 0;
  Result := False;
  while (not Result) and (i <= High(AList)) do
  begin
    Result := AList[i] = AChar;
    Inc(i);
  end;
end;

class function TUnicodeStringHelper.HaveChar(AChar: UnicodeChar; const AList:
  array of UnicodeChar): Boolean;
var
  i: TDynArrayIndex;
begin
  i := 0;
  Result := False;
  while (not Result) and (i <= High(AList)) do
  begin
    Result := AList[i] = AChar;
    Inc(i);
  end;
end;

class function TShortStringHelper.Create(C: AnsiChar; Count: Integer):
  ShortString;
begin
  if Count > High(Result) then
    raise ERangeError.Create(SRangeError);

  Result := System.StringOfChar(C, Count);
end;

class function TShortStringHelper.Create(const Value: array of AnsiChar;
  StartIndex: Integer; Length: Integer): ShortString;
begin
  if Length > High(Result) then
    raise ERangeError.Create(SRangeError);

  System.SetLength(Result, Max(0, Length));
  if Length > 0 then
    Move(Value[StartIndex], Result[1{Low(Result)}], System.Length(Result) * SizeOf(AnsiChar));
end;

class function TShortStringHelper.Create(const Value: array of AnsiChar):
  ShortString;
begin
  Result := ShortString.Create(Value, Low(Value), System.Length(Value));
end;

class function TAnsiStringHelper.Create(C: AnsiChar; Count: Integer):
  AnsiString;
begin
  Result := System.StringOfChar(C, Count);
end;

class function TAnsiStringHelper.Create(const Value: array of AnsiChar;
  StartIndex: Integer; Length: Integer): AnsiString;
begin
  System.SetLength(Result, Max(0, Length));
  if Length > 0 then
    Move(Value[StartIndex], Result[Low(Result)], Length * SizeOf(AnsiChar));
end;

class function TAnsiStringHelper.Create(const Value: array of AnsiChar):
  AnsiString;
begin
  Result := AnsiString.Create(Value, Low(Value), System.Length(Value));
end;

class function TRawByteStringHelper.Create(C: AnsiChar; Count: Integer):
  RawByteString;
begin
  Result := System.StringOfChar(C, Count);
end;

class function TRawByteStringHelper.Create(const Value: array of AnsiChar;
  StartIndex: Integer; Length: Integer): RawByteString;
begin
  System.SetLength(Result, Max(0, Length));
  if Length > 0 then
    Move(Value[StartIndex], Result[Low(Result)], Length * SizeOf(AnsiChar));
end;

class function TRawByteStringHelper.Create(const Value: array of AnsiChar):
  RawByteString;
begin
  Result := RawByteString.Create(Value, Low(Value), System.Length(Value));
end;

class function TUTF8StringHelper.Create(C: AnsiChar; Count: Integer):
  UTF8String;
begin
  Result := System.StringOfChar(C, Count);
end;

class function TUTF8StringHelper.Create(const Value: array of AnsiChar;
  StartIndex: Integer; Length: Integer): UTF8String;
begin
  System.SetLength(Result, Max(0, Length));
  if Length > 0 then
    Move(Value[StartIndex], Result[Low(Result)], Length * SizeOf(AnsiChar));
end;

class function TUTF8StringHelper.Create(const Value: array of AnsiChar):
  UTF8String;
begin
  Result := UTF8String.Create(Value, Low(Value), System.Length(Value));
end;

class function TWideStringHelper.Create(C: WideChar; Count: Integer):
  WideString;
var
  i: TDynArrayIndex;
begin
  System.SetLength(Result, Max(0, Count));
  for i := Low(Result) to High(Result) do
    Result[i] := C;
end;

class function TWideStringHelper.Create(const Value: array of WideChar;
  StartIndex: Integer; Length: Integer): WideString;
begin
  System.SetLength(Result, Max(0, Length));
  if Length > 0 then
    Move(Value[StartIndex], Result[Low(Result)], Length * SizeOf(WideChar));
end;

class function TWideStringHelper.Create(const Value: array of WideChar):
  WideString;
begin
  Result := WideString.Create(Value, Low(Value), System.Length(Value));
end;

class function TUnicodeStringHelper.Create(C: UnicodeChar; Count: Integer):
  UnicodeString;
var
  i: TDynArrayIndex;
begin
  System.SetLength(Result, Max(0, Count));
  for i := Low(Result) to High(Result) do
    Result[i] := C;
end;

class function TUnicodeStringHelper.Create(const Value: array of UnicodeChar;
  StartIndex: Integer; Length: Integer): UnicodeString;
begin
  System.SetLength(Result, Max(0, Length));
  if Length > 0 then
    Move(Value[StartIndex], Result[Low(Result)], Length * SizeOf(UnicodeChar));
end;

class function TUnicodeStringHelper.Create(const Value: array of UnicodeChar):
  UnicodeString;
begin
  Result := UnicodeString.Create(Value, Low(Value), System.Length(Value));
end;

function TShortStringHelper.GetChars(Index: Integer): AnsiChar;
begin
  Result := Self[Index + 1{Low(Self)}];
end;

function TAnsiStringHelper.GetChars(Index: Integer): AnsiChar;
begin
  Result := Self[Index + Low(Self)];
end;

function TRawByteStringHelper.GetChars(Index: Integer): AnsiChar;
begin
  Result := Self[Index + Low(Self)];
end;

function TUTF8StringHelper.GetChars(Index: Integer): AnsiChar;
begin
  Result := Self[Index + Low(Self)];
end;

function TWideStringHelper.GetChars(Index: Integer): WideChar;
begin
  Result := Self[Index + Low(Self)];
end;

function TUnicodeStringHelper.GetChars(Index: Integer): UnicodeChar;
begin
  Result := Self[Index + Low(Self)];
end;

//TODO: Optimize for linear scan

function TShortStringHelper.GetCodePoints(Index: Integer): ShortString;
begin
  if DefaultSystemCodePage = CP_UTF8 then
    Result := UTF8Copy(Self, Index + 1{Low(Self)}, 1)
  else
    Result := Self[Index + 1{Low(Self)}];
end;

function TAnsiStringHelper.GetCodePoints(Index: Integer): AnsiString;
begin
  SetCodePage(RawByteString(Result), StringCodePage(Self), False);
  if StringCodePage(Self) = CP_UTF8 then
    Result := UTF8Copy(Self, Index + Low(Self), 1)
  else
    Result := Self[Index + Low(Self)];
end;

function TRawByteStringHelper.GetCodePoints(Index: Integer): RawByteString;
begin
  SetCodePage(Result, StringCodePage(Self), False);
  if StringCodePage(Self) = CP_UTF8 then
    Result := UTF8Copy(Self, Index + Low(Self), 1)
  else
    Result := Self[Index + Low(Self)];
end;

function TUTF8StringHelper.GetCodePoints(Index: Integer): UTF8String;
begin
  SetCodePage(RawByteString(Result), StringCodePage(Self), False);
  if StringCodePage(Self) = CP_UTF8 then
    Result := UTF8Copy(Self, Index + Low(Self), 1)
  else
    Result := Self[Index + Low(Self)];
end;

function TWideStringHelper.GetCodePoints(Index: Integer): WideString;
begin
  Result := Self[Index + Low(Self)];
end;

function TUnicodeStringHelper.GetCodePoints(Index: Integer): UnicodeString;
begin
  Result := Self[Index + Low(Self)];
end;

function TShortStringHelper.GetByteLength: Integer;
begin
  Result := System.Length(Self);
end;

function TAnsiStringHelper.GetByteLength: Integer;
begin
  Result := System.Length(Self);
end;

function TRawByteStringHelper.GetByteLength: Integer;
begin
  Result := System.Length(Self);
end;

function TUTF8StringHelper.GetByteLength: Integer;
begin
  Result := System.Length(Self);
end;

function TWideStringHelper.GetByteLength: Integer;
begin
  Result := System.Length(Self) * SizeOf(WideChar);
end;

function TUnicodeStringHelper.GetByteLength: Integer;
begin
  Result := SysUtils.ByteLength(Self);
end;

function TShortStringHelper.GetLength: Integer;
begin
  if System.Length(Self) > 0 then
  begin
    if DefaultSystemCodePage = CP_UTF8 then
      Result := UTF8Length(PAnsiChar(@Self[1]), System.Length(Self))
    else
      Result := System.Length(Self);
  end
  else
    Result := 0;
end;

function TAnsiStringHelper.GetLength: Integer;
begin
  if StringCodePage(Self) = CP_UTF8 then
    Result := UTF8Length(PAnsiChar(Self), System.Length(Self))
  else
    Result := System.Length(Self);
end;

function TRawByteStringHelper.GetLength: Integer;
begin
  if StringCodePage(Self) = CP_UTF8 then
    Result := UTF8Length(PAnsiChar(Self), System.Length(Self))
  else
    Result := System.Length(Self);
end;

function TUTF8StringHelper.GetLength: Integer;
begin
  if StringCodePage(Self) = CP_UTF8 then
    Result := UTF8Length(PAnsiChar(Self), System.Length(Self))
  else
    Result := System.Length(Self);
end;

function TWideStringHelper.GetLength: Integer;
begin
  Result := System.Length(Self);
end;

function TUnicodeStringHelper.GetLength: Integer;
begin
  Result := System.Length(Self);
end;

class function TShortStringHelper.Compare(const StrA: ShortString;
  const StrB: ShortString): Integer;
begin

end;

class function TShortStringHelper.Compare(const StrA: ShortString;
  const StrB: ShortString; LocaleID: TLocaleID): Integer;
begin

end;

class function TShortStringHelper.Compare(const StrA: ShortString;
  const StrB: ShortString; IgnoreCase: Boolean): Integer;
begin

end;

class function TShortStringHelper.Compare(const StrA: ShortString;
  const StrB: ShortString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TShortStringHelper.Compare(const StrA: ShortString;
  IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TShortStringHelper.Compare(const StrA: ShortString;
  IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer;
  LocaleID: TLocaleID): Integer;
begin

end;

class function TShortStringHelper.Compare(const StrA: ShortString;
  IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean): Integer;
begin

end;

class function TShortStringHelper.Compare(const StrA: ShortString;
  IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TAnsiStringHelper.Compare(const StrA: AnsiString;
  const StrB: AnsiString): Integer;
begin

end;

class function TAnsiStringHelper.Compare(const StrA: AnsiString;
  const StrB: AnsiString; LocaleID: TLocaleID): Integer;
begin

end;

class function TAnsiStringHelper.Compare(const StrA: AnsiString;
  const StrB: AnsiString; IgnoreCase: Boolean): Integer;
begin

end;

class function TAnsiStringHelper.Compare(const StrA: AnsiString;
  const StrB: AnsiString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TAnsiStringHelper.Compare(const StrA: AnsiString;
  IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TAnsiStringHelper.Compare(const StrA: AnsiString;
  IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer;
  LocaleID: TLocaleID): Integer;
begin

end;

class function TAnsiStringHelper.Compare(const StrA: AnsiString;
  IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean): Integer;
begin

end;

class function TAnsiStringHelper.Compare(const StrA: AnsiString;
  IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TRawByteStringHelper.Compare(const StrA: RawByteString;
  const StrB: RawByteString): Integer;
begin

end;

class function TRawByteStringHelper.Compare(const StrA: RawByteString;
  const StrB: RawByteString; LocaleID: TLocaleID): Integer;
begin

end;

class function TRawByteStringHelper.Compare(const StrA: RawByteString;
  const StrB: RawByteString; IgnoreCase: Boolean): Integer;
begin

end;

class function TRawByteStringHelper.Compare(const StrA: RawByteString;
  const StrB: RawByteString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TRawByteStringHelper.Compare(const StrA: RawByteString;
  IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TRawByteStringHelper.Compare(const StrA: RawByteString;
  IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer;
  LocaleID: TLocaleID): Integer;
begin

end;

class function TRawByteStringHelper.Compare(const StrA: RawByteString;
  IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean): Integer;
begin

end;

class function TRawByteStringHelper.Compare(const StrA: RawByteString;
  IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TUTF8StringHelper.Compare(const StrA: UTF8String;
  const StrB: UTF8String): Integer;
begin

end;

class function TUTF8StringHelper.Compare(const StrA: UTF8String;
  const StrB: UTF8String; LocaleID: TLocaleID): Integer;
begin

end;

class function TUTF8StringHelper.Compare(const StrA: UTF8String;
  const StrB: UTF8String; IgnoreCase: Boolean): Integer;
begin

end;

class function TUTF8StringHelper.Compare(const StrA: UTF8String;
  const StrB: UTF8String; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TUTF8StringHelper.Compare(const StrA: UTF8String;
  IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TUTF8StringHelper.Compare(const StrA: UTF8String;
  IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer;
  LocaleID: TLocaleID): Integer;
begin

end;

class function TUTF8StringHelper.Compare(const StrA: UTF8String;
  IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean): Integer;
begin

end;

class function TUTF8StringHelper.Compare(const StrA: UTF8String;
  IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TWideStringHelper.Compare(const StrA: WideString;
  const StrB: WideString): Integer;
begin

end;

class function TWideStringHelper.Compare(const StrA: WideString;
  const StrB: WideString; LocaleID: TLocaleID): Integer;
begin

end;

class function TWideStringHelper.Compare(const StrA: WideString;
  const StrB: WideString; IgnoreCase: Boolean): Integer;
begin

end;

class function TWideStringHelper.Compare(const StrA: WideString;
  const StrB: WideString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TWideStringHelper.Compare(const StrA: WideString;
  IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TWideStringHelper.Compare(const StrA: WideString;
  IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer;
  LocaleID: TLocaleID): Integer;
begin

end;

class function TWideStringHelper.Compare(const StrA: WideString;
  IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean): Integer;
begin

end;

class function TWideStringHelper.Compare(const StrA: WideString;
  IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TUnicodeStringHelper.Compare(const StrA: UnicodeString;
  const StrB: UnicodeString): Integer;
begin

end;

class function TUnicodeStringHelper.Compare(const StrA: UnicodeString;
  const StrB: UnicodeString; LocaleID: TLocaleID): Integer;
begin

end;

class function TUnicodeStringHelper.Compare(const StrA: UnicodeString;
  const StrB: UnicodeString; IgnoreCase: Boolean): Integer;
begin

end;

class function TUnicodeStringHelper.Compare(const StrA: UnicodeString;
  const StrB: UnicodeString; IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TUnicodeStringHelper.Compare(const StrA: UnicodeString;
  IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TUnicodeStringHelper.Compare(const StrA: UnicodeString;
  IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer;
  LocaleID: TLocaleID): Integer;
begin

end;

class function TUnicodeStringHelper.Compare(const StrA: UnicodeString;
  IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean): Integer;
begin

end;

class function TUnicodeStringHelper.Compare(const StrA: UnicodeString;
  IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer;
  IgnoreCase: Boolean; LocaleID: TLocaleID): Integer;
begin

end;

class function TShortStringHelper.CompareOrdinal(const StrA: ShortString;
  const StrB: ShortString): Integer;
begin

end;

class function TShortStringHelper.CompareOrdinal(const StrA: ShortString;
  IndexA: Integer; const StrB: ShortString; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TAnsiStringHelper.CompareOrdinal(const StrA: AnsiString;
  const StrB: AnsiString): Integer;
begin

end;

class function TAnsiStringHelper.CompareOrdinal(const StrA: AnsiString;
  IndexA: Integer; const StrB: AnsiString; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TRawByteStringHelper.CompareOrdinal(const StrA: RawByteString;
  const StrB: RawByteString): Integer;
begin

end;

class function TRawByteStringHelper.CompareOrdinal(const StrA: RawByteString;
  IndexA: Integer; const StrB: RawByteString; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TUTF8StringHelper.CompareOrdinal(const StrA: UTF8String;
  const StrB: UTF8String): Integer;
begin

end;

class function TUTF8StringHelper.CompareOrdinal(const StrA: UTF8String;
  IndexA: Integer; const StrB: UTF8String; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TWideStringHelper.CompareOrdinal(const StrA: WideString;
  const StrB: WideString): Integer;
begin

end;

class function TWideStringHelper.CompareOrdinal(const StrA: WideString;
  IndexA: Integer; const StrB: WideString; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TUnicodeStringHelper.CompareOrdinal(const StrA: UnicodeString;
  const StrB: UnicodeString): Integer;
begin

end;

class function TUnicodeStringHelper.CompareOrdinal(const StrA: UnicodeString;
  IndexA: Integer; const StrB: UnicodeString; IndexB: Integer; Length: Integer):
  Integer;
begin

end;

class function TShortStringHelper.CompareText(const StrA: ShortString;
  const StrB: ShortString): Integer;
begin

end;

class function TAnsiStringHelper.CompareText(const StrA: AnsiString;
  const StrB: AnsiString): Integer;
begin

end;

class function TRawByteStringHelper.CompareText(const StrA: RawByteString;
  const StrB: RawByteString): Integer;
begin

end;

class function TUTF8StringHelper.CompareText(const StrA: UTF8String;
  const StrB: UTF8String): Integer;
begin

end;

class function TWideStringHelper.CompareText(const StrA: WideString;
  const StrB: WideString): Integer;
begin

end;

class function TUnicodeStringHelper.CompareText(const StrA: UnicodeString;
  const StrB: UnicodeString): Integer;
begin

end;

function TShortStringHelper.CompareTo(const strB: ShortString): Integer;
begin

end;

function TAnsiStringHelper.CompareTo(const strB: AnsiString): Integer;
begin

end;

function TRawByteStringHelper.CompareTo(const strB: RawByteString): Integer;
begin

end;

function TUTF8StringHelper.CompareTo(const strB: UTF8String): Integer;
begin

end;

function TWideStringHelper.CompareTo(const strB: WideString): Integer;
begin

end;

function TUnicodeStringHelper.CompareTo(const strB: UnicodeString): Integer;
begin

end;

function TShortStringHelper.Contains(const Value: ShortString): Boolean;
begin
  Result := System.Pos(Value, Self) >= 1 {Low(Value)};
end;

function TAnsiStringHelper.Contains(const Value: AnsiString): Boolean;
begin
  Result := System.Pos(Value, Self) >= Low(Value);
end;

function TRawByteStringHelper.Contains(const Value: RawByteString): Boolean;
begin
  Result := System.Pos(Value, Self) >= Low(Value);
end;

function TUTF8StringHelper.Contains(const Value: UTF8String): Boolean;
begin
  Result := System.Pos(Value, Self) >= Low(Value);
end;

function TWideStringHelper.Contains(const Value: WideString): Boolean;
begin
  Result := System.Pos(Value, Self) >= Low(Value);
end;

function TUnicodeStringHelper.Contains(const Value: UnicodeString): Boolean;
begin
  Result := System.Pos(Value, Self) >= Low(Value);
end;

class function TShortStringHelper.Copy(const Str: ShortString):
  ShortString;
begin
  Result := Str;
end;

class function TAnsiStringHelper.Copy(const Str: AnsiString):
  AnsiString;
begin
  Result := Str;
end;

class function TRawByteStringHelper.Copy(const Str: RawByteString):
  RawByteString;
begin
  Result := Str;
end;

class function TUTF8StringHelper.Copy(const Str: UTF8String):
  UTF8String;
begin
  Result := Str;
end;

class function TWideStringHelper.Copy(const Str: WideString):
  WideString;
begin
  Result := Str;
end;

class function TUnicodeStringHelper.Copy(const Str: UnicodeString):
  UnicodeString;
begin
  Result := Str;
end;

procedure TShortStringHelper.CopyTo(SourceIndex: Integer; var Destination:
  array of AnsiChar; DestinationIndex: Integer; Count: Integer);
begin

end;

procedure TAnsiStringHelper.CopyTo(SourceIndex: Integer; var Destination:
  array of AnsiChar; DestinationIndex: Integer; Count: Integer);
begin

end;

procedure TRawByteStringHelper.CopyTo(SourceIndex: Integer; var Destination:
  array of AnsiChar; DestinationIndex: Integer; Count: Integer);
begin

end;

procedure TUTF8StringHelper.CopyTo(SourceIndex: Integer; var Destination:
  array of AnsiChar; DestinationIndex: Integer; Count: Integer);
begin

end;

procedure TWideStringHelper.CopyTo(SourceIndex: Integer; var Destination:
  array of WideChar; DestinationIndex: Integer; Count: Integer);
begin

end;

procedure TUnicodeStringHelper.CopyTo(SourceIndex: Integer; var Destination:
  array of UnicodeChar; DestinationIndex: Integer; Count: Integer);
begin

end;

function TShortStringHelper.CountChar(const C: AnsiChar): Integer;
begin

end;

function TAnsiStringHelper.CountChar(const C: AnsiChar): Integer;
begin

end;

function TRawByteStringHelper.CountChar(const C: AnsiChar): Integer;
begin

end;

function TUTF8StringHelper.CountChar(const C: AnsiChar): Integer;
begin

end;

function TWideStringHelper.CountChar(const C: WideChar): Integer;
begin

end;

function TUnicodeStringHelper.CountChar(const C: UnicodeChar): Integer;
begin

end;

function TShortStringHelper.DeQuotedString: ShortString;
begin

end;

function TShortStringHelper.DeQuotedString(const QuoteChar: AnsiChar):
  ShortString;
begin

end;

function TAnsiStringHelper.DeQuotedString: AnsiString;
begin

end;

function TAnsiStringHelper.DeQuotedString(const QuoteChar: AnsiChar):
  AnsiString;
begin

end;

function TRawByteStringHelper.DeQuotedString: RawByteString;
begin

end;

function TRawByteStringHelper.DeQuotedString(const QuoteChar: AnsiChar):
  RawByteString;
begin

end;

function TUTF8StringHelper.DeQuotedString: UTF8String;
begin

end;

function TUTF8StringHelper.DeQuotedString(const QuoteChar: AnsiChar):
  UTF8String;
begin

end;

function TWideStringHelper.DeQuotedString: WideString;
begin

end;

function TWideStringHelper.DeQuotedString(const QuoteChar: WideChar):
  WideString;
begin

end;


function TUnicodeStringHelper.DeQuotedString: UnicodeString;
begin

end;

function TUnicodeStringHelper.DeQuotedString(const QuoteChar: UnicodeChar):
  UnicodeString;
begin

end;

class function TShortStringHelper.EndsText(const ASubText, AText:
  ShortString): Boolean;
begin

end;

class function TAnsiStringHelper.EndsText(const ASubText, AText:
  AnsiString): Boolean;
begin

end;

class function TRawByteStringHelper.EndsText(const ASubText, AText:
  RawByteString): Boolean;
begin

end;

class function TUTF8StringHelper.EndsText(const ASubText, AText:
  UTF8String): Boolean;
begin

end;

class function TWideStringHelper.EndsText(const ASubText, AText:
  WideString): Boolean;
begin

end;

class function TUnicodeStringHelper.EndsText(const ASubText, AText:
  UnicodeString): Boolean;
begin

end;

function TShortStringHelper.EndsWith(const Value: ShortString): Boolean;
begin

end;

function TShortStringHelper.EndsWith(const Value: ShortString;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TAnsiStringHelper.EndsWith(const Value: AnsiString): Boolean;
begin

end;

function TAnsiStringHelper.EndsWith(const Value: AnsiString;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TRawByteStringHelper.EndsWith(const Value: RawByteString): Boolean;
begin

end;

function TRawByteStringHelper.EndsWith(const Value: RawByteString;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TUTF8StringHelper.EndsWith(const Value: UTF8String): Boolean;
begin

end;

function TUTF8StringHelper.EndsWith(const Value: UTF8String;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TWideStringHelper.EndsWith(const Value: WideString): Boolean;
begin

end;

function TWideStringHelper.EndsWith(const Value: WideString;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TUnicodeStringHelper.EndsWith(const Value: UnicodeString): Boolean;
begin

end;

function TUnicodeStringHelper.EndsWith(const Value: UnicodeString;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TShortStringHelper.Equals(const Value: ShortString): Boolean;
begin
  Result := Self = Value;
end;

class function TShortStringHelper.Equals(const Left: ShortString;
  const Right: ShortString): Boolean;
begin
  Result := Left = Right;
end;

function TAnsiStringHelper.Equals(const Value: AnsiString): Boolean;
begin
  Result := Self = Value;
end;

class function TAnsiStringHelper.Equals(const Left: AnsiString;
  const Right: AnsiString): Boolean;
begin
  Result := Left = Right;
end;

function TRawByteStringHelper.Equals(const Value: RawByteString): Boolean;
begin
  Result := Self = Value;
end;

class function TRawByteStringHelper.Equals(const Left: RawByteString;
  const Right: RawByteString): Boolean;
begin
  Result := Left = Right;
end;

function TUTF8StringHelper.Equals(const Value: UTF8String): Boolean;
begin
  Result := Self = Value;
end;

class function TUTF8StringHelper.Equals(const Left: UTF8String;
  const Right: UTF8String): Boolean;
begin
  Result := Left = Right;
end;

function TWideStringHelper.Equals(const Value: WideString): Boolean;
begin
  Result := Self = Value;
end;

class function TWideStringHelper.Equals(const Left: WideString;
  const Right: WideString): Boolean;
begin
  Result := Left = Right;
end;

function TUnicodeStringHelper.Equals(const Value: UnicodeString): Boolean;
begin
  Result := Self = Value;
end;

class function TUnicodeStringHelper.Equals(const Left: UnicodeString;
  const Right: UnicodeString): Boolean;
begin
  Result := Left = Right;
end;

class function TShortStringHelper.Format(const Format: ShortString;
  const Args: array of const): ShortString;
begin
  Result := SysUtils.Format(Format, Args);
end;

class function TAnsiStringHelper.Format(const Format: AnsiString;
  const Args: array of const): AnsiString;
begin
  Result := SysUtils.Format(Format, Args);
end;

class function TRawByteStringHelper.Format(const Format: RawByteString;
  const Args: array of const): RawByteString;
begin
  Result := SysUtils.Format(Format, Args);
end;

class function TUTF8StringHelper.Format(const Format: UTF8String;
  const Args: array of const): UTF8String;
begin
  Result := SysUtils.Format(Format, Args);
end;

class function TWideStringHelper.Format(const Format: WideString;
  const Args: array of const): WideString;
begin
  Result := SysUtils.WideFormat(Format, Args);
end;

class function TUnicodeStringHelper.Format(const Format: UnicodeString;
  const Args: array of const): UnicodeString;
begin
  Result := SysUtils.UnicodeFormat(Format, Args);
end;

function TShortStringHelper.IndexOf(value: AnsiChar): Integer;
begin

end;

function TShortStringHelper.IndexOf(const Value: ShortString): Integer;
begin

end;

function TShortStringHelper.IndexOf(Value: AnsiChar; StartIndex: Integer):
  Integer;
begin

end;

function TShortStringHelper.IndexOf(const Value: ShortString;
  StartIndex: Integer): Integer;
begin

end;

function TShortStringHelper.IndexOf(Value: AnsiChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TShortStringHelper.IndexOf(const Value: ShortString;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TAnsiStringHelper.IndexOf(value: AnsiChar): Integer;
begin

end;

function TAnsiStringHelper.IndexOf(const Value: AnsiString): Integer;
begin

end;

function TAnsiStringHelper.IndexOf(Value: AnsiChar; StartIndex: Integer):
  Integer;
begin

end;

function TAnsiStringHelper.IndexOf(const Value: AnsiString;
  StartIndex: Integer): Integer;
begin

end;

function TAnsiStringHelper.IndexOf(Value: AnsiChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TAnsiStringHelper.IndexOf(const Value: AnsiString;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TRawByteStringHelper.IndexOf(value: AnsiChar): Integer;
begin

end;

function TRawByteStringHelper.IndexOf(const Value: RawByteString): Integer;
begin

end;

function TRawByteStringHelper.IndexOf(Value: AnsiChar; StartIndex: Integer):
  Integer;
begin

end;

function TRawByteStringHelper.IndexOf(const Value: RawByteString;
  StartIndex: Integer): Integer;
begin

end;

function TRawByteStringHelper.IndexOf(Value: AnsiChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TRawByteStringHelper.IndexOf(const Value: RawByteString;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TUTF8StringHelper.IndexOf(value: AnsiChar): Integer;
begin

end;

function TUTF8StringHelper.IndexOf(const Value: UTF8String): Integer;
begin

end;

function TUTF8StringHelper.IndexOf(Value: AnsiChar; StartIndex: Integer):
  Integer;
begin

end;

function TUTF8StringHelper.IndexOf(const Value: UTF8String;
  StartIndex: Integer): Integer;
begin

end;

function TUTF8StringHelper.IndexOf(Value: AnsiChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TUTF8StringHelper.IndexOf(const Value: UTF8String;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TWideStringHelper.IndexOf(value: WideChar): Integer;
begin

end;

function TWideStringHelper.IndexOf(const Value: WideString): Integer;
begin

end;

function TWideStringHelper.IndexOf(Value: WideChar; StartIndex: Integer):
  Integer;
begin

end;

function TWideStringHelper.IndexOf(const Value: WideString;
  StartIndex: Integer): Integer;
begin

end;

function TWideStringHelper.IndexOf(Value: WideChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TWideStringHelper.IndexOf(const Value: WideString;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TUnicodeStringHelper.IndexOf(value: UnicodeChar): Integer;
begin

end;

function TUnicodeStringHelper.IndexOf(const Value: UnicodeString): Integer;
begin

end;

function TUnicodeStringHelper.IndexOf(Value: UnicodeChar; StartIndex: Integer):
  Integer;
begin

end;

function TUnicodeStringHelper.IndexOf(const Value: UnicodeString;
  StartIndex: Integer): Integer;
begin

end;

function TUnicodeStringHelper.IndexOf(Value: UnicodeChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TUnicodeStringHelper.IndexOf(const Value: UnicodeString;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TShortStringHelper.IndexOfAny(const AnyOf: array of AnsiChar):
  Integer;
begin

end;

function TShortStringHelper.IndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TShortStringHelper.IndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TAnsiStringHelper.IndexOfAny(const AnyOf: array of AnsiChar):
  Integer;
begin

end;

function TAnsiStringHelper.IndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TAnsiStringHelper.IndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TRawByteStringHelper.IndexOfAny(const AnyOf: array of AnsiChar):
  Integer;
begin

end;

function TRawByteStringHelper.IndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TRawByteStringHelper.IndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TUTF8StringHelper.IndexOfAny(const AnyOf: array of AnsiChar):
  Integer;
begin

end;

function TUTF8StringHelper.IndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TUTF8StringHelper.IndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TWideStringHelper.IndexOfAny(const AnyOf: array of WideChar):
  Integer;
begin

end;

function TWideStringHelper.IndexOfAny(const AnyOf: array of WideChar;
  StartIndex: Integer): Integer;
begin

end;

function TWideStringHelper.IndexOfAny(const AnyOf: array of WideChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TUnicodeStringHelper.IndexOfAny(const AnyOf: array of UnicodeChar):
  Integer;
begin

end;

function TUnicodeStringHelper.IndexOfAny(const AnyOf: array of UnicodeChar;
  StartIndex: Integer): Integer;
begin

end;

function TUnicodeStringHelper.IndexOfAny(const AnyOf: array of UnicodeChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TShortStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar): Integer;
begin

end;

function TShortStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer): Integer;
begin

end;

function TShortStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TAnsiStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar): Integer;
begin

end;

function TAnsiStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer): Integer;
begin

end;

function TAnsiStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TRawByteStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar): Integer;
begin

end;

function TRawByteStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer): Integer;
begin

end;

function TRawByteStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TUTF8StringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar): Integer;
begin

end;

function TUTF8StringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer): Integer;
begin

end;

function TUTF8StringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  AnsiChar; StartQuote, EndQuote: AnsiChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TWideStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  WideChar; StartQuote, EndQuote: WideChar): Integer;
begin

end;

function TWideStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  WideChar; StartQuote, EndQuote: WideChar; StartIndex: Integer): Integer;
begin

end;

function TWideStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  WideChar; StartQuote, EndQuote: WideChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TUnicodeStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  UnicodeChar; StartQuote, EndQuote: UnicodeChar): Integer;
begin

end;

function TUnicodeStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  UnicodeChar; StartQuote, EndQuote: UnicodeChar; StartIndex: Integer): Integer;
begin

end;

function TUnicodeStringHelper.IndexOfAnyUnquoted(const AnyOf: array of
  UnicodeChar; StartQuote, EndQuote: UnicodeChar; StartIndex: Integer;
  Count: Integer): Integer;
begin

end;

function TShortStringHelper.Insert(StartIndex: Integer; const Value:
  ShortString): ShortString;
begin

end;

function TAnsiStringHelper.Insert(StartIndex: Integer; const Value:
  AnsiString): AnsiString;
begin

end;

function TRawByteStringHelper.Insert(StartIndex: Integer; const Value:
  RawByteString): RawByteString;
begin

end;

function TUTF8StringHelper.Insert(StartIndex: Integer; const Value:
  UTF8String): UTF8String;
begin

end;

function TWideStringHelper.Insert(StartIndex: Integer; const Value:
  WideString): WideString;
begin

end;

function TUnicodeStringHelper.Insert(StartIndex: Integer; const Value:
  UnicodeString): UnicodeString;
begin

end;

function TShortStringHelper.IsDelimiter(const Delimiters: ShortString;
  Index: Integer): Boolean;
begin

end;

function TAnsiStringHelper.IsDelimiter(const Delimiters: AnsiString;
  Index: Integer): Boolean;
begin

end;

function TRawByteStringHelper.IsDelimiter(const Delimiters: RawByteString;
  Index: Integer): Boolean;
begin

end;

function TUTF8StringHelper.IsDelimiter(const Delimiters: UTF8String;
  Index: Integer): Boolean;
begin

end;

function TWideStringHelper.IsDelimiter(const Delimiters: WideString;
  Index: Integer): Boolean;
begin

end;

function TUnicodeStringHelper.IsDelimiter(const Delimiters: UnicodeString;
  Index: Integer): Boolean;
begin

end;

function TShortStringHelper.IsEmpty: Boolean;
begin
  Result := Self = Self.Empty;
end;

function TAnsiStringHelper.IsEmpty: Boolean;
begin
  Result := Self = Self.Empty;
end;

function TRawByteStringHelper.IsEmpty: Boolean;
begin
  Result := Self = Self.Empty;
end;

function TUTF8StringHelper.IsEmpty: Boolean;
begin
  Result := Self = Self.Empty;
end;

function TWideStringHelper.IsEmpty: Boolean;
begin
  Result := Self = Self.Empty;
end;

function TUnicodeStringHelper.IsEmpty: Boolean;
begin
  Result := Self = Self.Empty;
end;

class function TShortStringHelper.IsNullOrEmpty(const Value: ShortString):
  Boolean;
begin
  Result := Value = ShortString.Empty;
end;

class function TAnsiStringHelper.IsNullOrEmpty(const Value: AnsiString):
  Boolean;
begin
  Result := Value = AnsiString.Empty;
end;

class function TRawByteStringHelper.IsNullOrEmpty(const Value: RawByteString):
  Boolean;
begin
  Result := Value = RawByteString.Empty;
end;

class function TUTF8StringHelper.IsNullOrEmpty(const Value: UTF8String):
  Boolean;
begin
  Result := Value = UTF8String.Empty;
end;

class function TWideStringHelper.IsNullOrEmpty(const Value: WideString):
  Boolean;
begin
  Result := Value = WideString.Empty;
end;

class function TUnicodeStringHelper.IsNullOrEmpty(const Value: UnicodeString):
  Boolean;
begin
  Result := Value = UnicodeString.Empty;
end;

class function TShortStringHelper.IsNullOrWhiteSpace(const Value:
  ShortString): Boolean;
begin
  Result := System.Length(SysUtils.Trim(Value)) = 0;
end;

class function TAnsiStringHelper.IsNullOrWhiteSpace(const Value:
  AnsiString): Boolean;
begin
  Result := System.Length(SysUtils.Trim(Value)) = 0;
end;

class function TRawByteStringHelper.IsNullOrWhiteSpace(const Value:
  RawByteString): Boolean;
begin
  Result := System.Length(SysUtils.Trim(Value)) = 0;
end;

class function TUTF8StringHelper.IsNullOrWhiteSpace(const Value:
  UTF8String): Boolean;
begin
  Result := System.Length(SysUtils.Trim(Value)) = 0;
end;

class function TWideStringHelper.IsNullOrWhiteSpace(const Value:
  WideString): Boolean;
begin
  Result := System.Length(SysUtils.Trim(Value)) = 0;
end;

class function TUnicodeStringHelper.IsNullOrWhiteSpace(const Value:
  UnicodeString): Boolean;
begin
  Result := System.Length(SysUtils.Trim(Value)) = 0;
end;

class function TShortStringHelper.Join(const Separator: ShortString;
  const Values: array of const): ShortString;
begin

end;

class function TShortStringHelper.Join(const Separator: ShortString;
  const Values: array of ShortString): ShortString;
begin

end;

class function TShortStringHelper.Join(const Separator: ShortString;
  const Values: IEnumerator<ShortString>): ShortString;
begin

end;

class function TShortStringHelper.Join(const Separator: ShortString;
  const Values: IEnumerable<ShortString>): ShortString;
begin

end;

class function TShortStringHelper.Join(const Separator: ShortString;
  const Value: array of ShortString; StartIndex: Integer; Count: Integer):
  ShortString;
begin

end;

class function TAnsiStringHelper.Join(const Separator: AnsiString;
  const Values: array of const): AnsiString;
begin

end;

class function TAnsiStringHelper.Join(const Separator: AnsiString;
  const Values: array of AnsiString): AnsiString;
begin

end;

class function TAnsiStringHelper.Join(const Separator: AnsiString;
  const Values: IEnumerator<AnsiString>): AnsiString;
begin

end;

class function TAnsiStringHelper.Join(const Separator: AnsiString;
  const Values: IEnumerable<AnsiString>): AnsiString;
begin

end;

class function TAnsiStringHelper.Join(const Separator: AnsiString;
  const Value: array of AnsiString; StartIndex: Integer; Count: Integer):
  AnsiString;
begin

end;

class function TRawByteStringHelper.Join(const Separator: RawByteString;
  const Values: array of const): RawByteString;
begin

end;

class function TRawByteStringHelper.Join(const Separator: RawByteString;
  const Values: array of RawByteString): RawByteString;
begin

end;

class function TRawByteStringHelper.Join(const Separator: RawByteString;
  const Values: IEnumerator<RawByteString>): RawByteString;
begin

end;

class function TRawByteStringHelper.Join(const Separator: RawByteString;
  const Values: IEnumerable<RawByteString>): RawByteString;
begin

end;

class function TRawByteStringHelper.Join(const Separator: RawByteString;
  const Value: array of RawByteString; StartIndex: Integer; Count: Integer):
  RawByteString;
begin

end;

class function TUTF8StringHelper.Join(const Separator: UTF8String;
  const Values: array of const): UTF8String;
begin

end;

class function TUTF8StringHelper.Join(const Separator: UTF8String;
  const Values: array of UTF8String): UTF8String;
begin

end;

class function TUTF8StringHelper.Join(const Separator: UTF8String;
  const Values: IEnumerator<UTF8String>): UTF8String;
begin

end;

class function TUTF8StringHelper.Join(const Separator: UTF8String;
  const Values: IEnumerable<UTF8String>): UTF8String;
begin

end;

class function TUTF8StringHelper.Join(const Separator: UTF8String;
  const Value: array of UTF8String; StartIndex: Integer; Count: Integer):
  UTF8String;
begin

end;

class function TWideStringHelper.Join(const Separator: WideString;
  const Values: array of const): WideString;
begin

end;

class function TWideStringHelper.Join(const Separator: WideString;
  const Values: array of WideString): WideString;
begin

end;

class function TWideStringHelper.Join(const Separator: WideString;
  const Values: IEnumerator<WideString>): WideString;
begin

end;

class function TWideStringHelper.Join(const Separator: WideString;
  const Values: IEnumerable<WideString>): WideString;
begin

end;

class function TWideStringHelper.Join(const Separator: WideString;
  const Value: array of WideString; StartIndex: Integer; Count: Integer):
  WideString;
begin

end;

class function TUnicodeStringHelper.Join(const Separator: UnicodeString;
  const Values: array of const): UnicodeString;
begin

end;

class function TUnicodeStringHelper.Join(const Separator: UnicodeString;
  const Values: array of UnicodeString): UnicodeString;
begin

end;

class function TUnicodeStringHelper.Join(const Separator: UnicodeString;
  const Values: IEnumerator<UnicodeString>): UnicodeString;
begin

end;

class function TUnicodeStringHelper.Join(const Separator: UnicodeString;
  const Values: IEnumerable<UnicodeString>): UnicodeString;
begin

end;

class function TUnicodeStringHelper.Join(const Separator: UnicodeString;
  const Value: array of UnicodeString; StartIndex: Integer; Count: Integer):
  UnicodeString;
begin

end;

function TShortStringHelper.LastDelimiter(const Delims: ShortString):
  Integer;
begin

end;

function TAnsiStringHelper.LastDelimiter(const Delims: AnsiString):
  Integer;
begin

end;

function TRawByteStringHelper.LastDelimiter(const Delims: RawByteString):
  Integer;
begin

end;

function TUTF8StringHelper.LastDelimiter(const Delims: UTF8String):
  Integer;
begin

end;

function TWideStringHelper.LastDelimiter(const Delims: WideString):
  Integer;
begin

end;

function TUnicodeStringHelper.LastDelimiter(const Delims: UnicodeString):
  Integer;
begin

end;

function TShortStringHelper.LastIndexOf(Value: AnsiChar): Integer;
begin

end;

function TShortStringHelper.LastIndexOf(const Value: ShortString): Integer;
begin

end;

function TShortStringHelper.LastIndexOf(Value: AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TShortStringHelper.LastIndexOf(const Value: ShortString;
  StartIndex: Integer): Integer;
begin

end;

function TShortStringHelper.LastIndexOf(Value: AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TShortStringHelper.LastIndexOf(const Value: ShortString;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TAnsiStringHelper.LastIndexOf(Value: AnsiChar): Integer;
begin

end;

function TAnsiStringHelper.LastIndexOf(const Value: AnsiString): Integer;
begin

end;

function TAnsiStringHelper.LastIndexOf(Value: AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TAnsiStringHelper.LastIndexOf(const Value: AnsiString;
  StartIndex: Integer): Integer;
begin

end;

function TAnsiStringHelper.LastIndexOf(Value: AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TAnsiStringHelper.LastIndexOf(const Value: AnsiString;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TRawByteStringHelper.LastIndexOf(Value: AnsiChar): Integer;
begin

end;

function TRawByteStringHelper.LastIndexOf(const Value: RawByteString): Integer;
begin

end;

function TRawByteStringHelper.LastIndexOf(Value: AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TRawByteStringHelper.LastIndexOf(const Value: RawByteString;
  StartIndex: Integer): Integer;
begin

end;

function TRawByteStringHelper.LastIndexOf(Value: AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TRawByteStringHelper.LastIndexOf(const Value: RawByteString;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TUTF8StringHelper.LastIndexOf(Value: AnsiChar): Integer;
begin

end;

function TUTF8StringHelper.LastIndexOf(const Value: UTF8String): Integer;
begin

end;

function TUTF8StringHelper.LastIndexOf(Value: AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TUTF8StringHelper.LastIndexOf(const Value: UTF8String;
  StartIndex: Integer): Integer;
begin

end;

function TUTF8StringHelper.LastIndexOf(Value: AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TUTF8StringHelper.LastIndexOf(const Value: UTF8String;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TWideStringHelper.LastIndexOf(Value: WideChar): Integer;
begin

end;

function TWideStringHelper.LastIndexOf(const Value: WideString): Integer;
begin

end;

function TWideStringHelper.LastIndexOf(Value: WideChar;
  StartIndex: Integer): Integer;
begin

end;

function TWideStringHelper.LastIndexOf(const Value: WideString;
  StartIndex: Integer): Integer;
begin

end;

function TWideStringHelper.LastIndexOf(Value: WideChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TWideStringHelper.LastIndexOf(const Value: WideString;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TUnicodeStringHelper.LastIndexOf(Value: UnicodeChar): Integer;
begin

end;

function TUnicodeStringHelper.LastIndexOf(const Value: UnicodeString): Integer;
begin

end;

function TUnicodeStringHelper.LastIndexOf(Value: UnicodeChar;
  StartIndex: Integer): Integer;
begin

end;

function TUnicodeStringHelper.LastIndexOf(const Value: UnicodeString;
  StartIndex: Integer): Integer;
begin

end;

function TUnicodeStringHelper.LastIndexOf(Value: UnicodeChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TUnicodeStringHelper.LastIndexOf(const Value: UnicodeString;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TShortStringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar):
  Integer;
begin

end;

function TShortStringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TShortStringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TAnsiStringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar):
  Integer;
begin

end;

function TAnsiStringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TAnsiStringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TRawByteStringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar):
  Integer;
begin

end;

function TRawByteStringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TRawByteStringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TUTF8StringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar):
  Integer;
begin

end;

function TUTF8StringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer): Integer;
begin

end;

function TUTF8StringHelper.LastIndexOfAny(const AnyOf: array of AnsiChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TWideStringHelper.LastIndexOfAny(const AnyOf: array of WideChar):
  Integer;
begin

end;

function TWideStringHelper.LastIndexOfAny(const AnyOf: array of WideChar;
  StartIndex: Integer): Integer;
begin

end;

function TWideStringHelper.LastIndexOfAny(const AnyOf: array of WideChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

function TUnicodeStringHelper.LastIndexOfAny(const AnyOf: array of UnicodeChar):
  Integer;
begin

end;

function TUnicodeStringHelper.LastIndexOfAny(const AnyOf: array of UnicodeChar;
  StartIndex: Integer): Integer;
begin

end;

function TUnicodeStringHelper.LastIndexOfAny(const AnyOf: array of UnicodeChar;
  StartIndex: Integer; Count: Integer): Integer;
begin

end;

class function TShortStringHelper.LowerCase(const S: ShortString):
  ShortString;
begin

end;

class function TShortStringHelper.LowerCase(const S: ShortString;
  LocaleOptions: TLocaleOptions): ShortString;
begin

end;

class function TAnsiStringHelper.LowerCase(const S: AnsiString):
  AnsiString;
begin

end;

class function TAnsiStringHelper.LowerCase(const S: AnsiString;
  LocaleOptions: TLocaleOptions): AnsiString;
begin

end;

class function TRawByteStringHelper.LowerCase(const S: RawByteString):
  RawByteString;
begin

end;

class function TRawByteStringHelper.LowerCase(const S: RawByteString;
  LocaleOptions: TLocaleOptions): RawByteString;
begin

end;

class function TUTF8StringHelper.LowerCase(const S: UTF8String):
  UTF8String;
begin

end;

class function TUTF8StringHelper.LowerCase(const S: UTF8String;
  LocaleOptions: TLocaleOptions): UTF8String;
begin

end;

class function TWideStringHelper.LowerCase(const S: WideString):
  WideString;
begin

end;

class function TWideStringHelper.LowerCase(const S: WideString;
  LocaleOptions: TLocaleOptions): WideString;
begin

end;

class function TUnicodeStringHelper.LowerCase(const S: UnicodeString):
  UnicodeString;
begin

end;

class function TUnicodeStringHelper.LowerCase(const S: UnicodeString;
  LocaleOptions: TLocaleOptions): UnicodeString;
begin

end;

function TShortStringHelper.PadLeft(TotalWidth: Integer): ShortString;
begin

end;

function TShortStringHelper.PadLeft(TotalWidth: Integer;
  PaddingChar: AnsiChar): ShortString;
begin

end;

function TAnsiStringHelper.PadLeft(TotalWidth: Integer): AnsiString;
begin

end;

function TAnsiStringHelper.PadLeft(TotalWidth: Integer;
  PaddingChar: AnsiChar): AnsiString;
begin

end;

function TRawByteStringHelper.PadLeft(TotalWidth: Integer): RawByteString;
begin

end;

function TRawByteStringHelper.PadLeft(TotalWidth: Integer;
  PaddingChar: AnsiChar): RawByteString;
begin

end;

function TUTF8StringHelper.PadLeft(TotalWidth: Integer): UTF8String;
begin

end;

function TUTF8StringHelper.PadLeft(TotalWidth: Integer;
  PaddingChar: AnsiChar): UTF8String;
begin

end;

function TWideStringHelper.PadLeft(TotalWidth: Integer): WideString;
begin

end;

function TWideStringHelper.PadLeft(TotalWidth: Integer;
  PaddingChar: WideChar): WideString;
begin

end;

function TUnicodeStringHelper.PadLeft(TotalWidth: Integer): UnicodeString;
begin

end;

function TUnicodeStringHelper.PadLeft(TotalWidth: Integer;
  PaddingChar: UnicodeChar): UnicodeString;
begin

end;

function TShortStringHelper.PadRight(TotalWidth: Integer): ShortString;
begin

end;

function TShortStringHelper.PadRight(TotalWidth: Integer;
  PaddingChar: AnsiChar): ShortString;
begin

end;

function TAnsiStringHelper.PadRight(TotalWidth: Integer): AnsiString;
begin

end;

function TAnsiStringHelper.PadRight(TotalWidth: Integer;
  PaddingChar: AnsiChar): AnsiString;
begin

end;

function TRawByteStringHelper.PadRight(TotalWidth: Integer): RawByteString;
begin

end;

function TRawByteStringHelper.PadRight(TotalWidth: Integer;
  PaddingChar: AnsiChar): RawByteString;
begin

end;

function TUTF8StringHelper.PadRight(TotalWidth: Integer): UTF8String;
begin

end;

function TUTF8StringHelper.PadRight(TotalWidth: Integer;
  PaddingChar: AnsiChar): UTF8String;
begin

end;

function TWideStringHelper.PadRight(TotalWidth: Integer): WideString;
begin

end;

function TWideStringHelper.PadRight(TotalWidth: Integer;
  PaddingChar: WideChar): WideString;
begin

end;

function TUnicodeStringHelper.PadRight(TotalWidth: Integer): UnicodeString;
begin

end;

function TUnicodeStringHelper.PadRight(TotalWidth: Integer;
  PaddingChar: UnicodeChar): UnicodeString;
begin

end;

{$PUSH}{$WARN IMPLICIT_STRING_CAST OFF}
class function TShortStringHelper.Parse(const Value: Integer): ShortString;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TShortStringHelper.Parse(const Value: Int64): ShortString;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TShortStringHelper.Parse(const Value: Boolean): ShortString;
begin
  Result := SysUtils.BoolToStr(Value);
end;

class function TShortStringHelper.Parse(const Value: Extended): ShortString;
begin
  Result := SysUtils.FloatToStr(Value);
end;

class function TAnsiStringHelper.Parse(const Value: Integer): AnsiString;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TAnsiStringHelper.Parse(const Value: Int64): AnsiString;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TAnsiStringHelper.Parse(const Value: Boolean): AnsiString;
begin
  Result := SysUtils.BoolToStr(Value);
end;

class function TAnsiStringHelper.Parse(const Value: Extended): AnsiString;
begin
  Result := SysUtils.FloatToStr(Value);
end;

class function TRawByteStringHelper.Parse(const Value: Integer): RawByteString;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TRawByteStringHelper.Parse(const Value: Int64): RawByteString;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TRawByteStringHelper.Parse(const Value: Boolean): RawByteString;
begin
  Result := SysUtils.BoolToStr(Value);
end;

class function TRawByteStringHelper.Parse(const Value: Extended): RawByteString;
begin
  Result := SysUtils.FloatToStr(Value);
end;

class function TUTF8StringHelper.Parse(const Value: Integer): UTF8String;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TUTF8StringHelper.Parse(const Value: Int64): UTF8String;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TUTF8StringHelper.Parse(const Value: Boolean): UTF8String;
begin
  Result := SysUtils.BoolToStr(Value);
end;

class function TUTF8StringHelper.Parse(const Value: Extended): UTF8String;
begin
  Result := SysUtils.FloatToStr(Value);
end;

class function TWideStringHelper.Parse(const Value: Integer): WideString;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TWideStringHelper.Parse(const Value: Int64): WideString;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TWideStringHelper.Parse(const Value: Boolean): WideString;
begin
  Result := SysUtils.BoolToStr(Value);
end;

class function TWideStringHelper.Parse(const Value: Extended): WideString;
begin
  Result := SysUtils.FloatToStr(Value);
end;

class function TUnicodeStringHelper.Parse(const Value: Integer): UnicodeString;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TUnicodeStringHelper.Parse(const Value: Int64): UnicodeString;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TUnicodeStringHelper.Parse(const Value: Boolean): UnicodeString;
begin
  Result := SysUtils.BoolToStr(Value);
end;

class function TUnicodeStringHelper.Parse(const Value: Extended): UnicodeString;
begin
  Result := SysUtils.FloatToStr(Value);
end;
{$POP}

function TShortStringHelper.QuotedString: ShortString;
begin

end;

function TShortStringHelper.QuotedString(const QuoteChar: AnsiChar):
  ShortString;
begin

end;

function TAnsiStringHelper.QuotedString: AnsiString;
begin

end;

function TAnsiStringHelper.QuotedString(const QuoteChar: AnsiChar):
  AnsiString;
begin

end;

function TRawByteStringHelper.QuotedString: RawByteString;
begin

end;

function TRawByteStringHelper.QuotedString(const QuoteChar: AnsiChar):
  RawByteString;
begin

end;

function TUTF8StringHelper.QuotedString: UTF8String;
begin

end;

function TUTF8StringHelper.QuotedString(const QuoteChar: AnsiChar):
  UTF8String;
begin

end;

function TWideStringHelper.QuotedString: WideString;
begin

end;

function TWideStringHelper.QuotedString(const QuoteChar: WideChar):
  WideString;
begin

end;

function TUnicodeStringHelper.QuotedString: UnicodeString;
begin

end;

function TUnicodeStringHelper.QuotedString(const QuoteChar: UnicodeChar):
  UnicodeString;
begin

end;

function TShortStringHelper.Remove(StartIndex: Integer): ShortString;
begin

end;

function TShortStringHelper.Remove(StartIndex: Integer; Count: Integer):
  ShortString;
begin

end;

function TAnsiStringHelper.Remove(StartIndex: Integer): AnsiString;
begin

end;

function TAnsiStringHelper.Remove(StartIndex: Integer; Count: Integer):
  AnsiString;
begin

end;

function TRawByteStringHelper.Remove(StartIndex: Integer): RawByteString;
begin

end;

function TRawByteStringHelper.Remove(StartIndex: Integer; Count: Integer):
  RawByteString;
begin

end;

function TUTF8StringHelper.Remove(StartIndex: Integer): UTF8String;
begin

end;

function TUTF8StringHelper.Remove(StartIndex: Integer; Count: Integer):
  UTF8String;
begin

end;

function TWideStringHelper.Remove(StartIndex: Integer): WideString;
begin

end;

function TWideStringHelper.Remove(StartIndex: Integer; Count: Integer):
  WideString;
begin

end;

function TUnicodeStringHelper.Remove(StartIndex: Integer): UnicodeString;
begin

end;

function TUnicodeStringHelper.Remove(StartIndex: Integer; Count: Integer):
  UnicodeString;
begin

end;

function TShortStringHelper.Replace(OldChar: AnsiChar;
  NewChar: AnsiChar): ShortString;
begin

end;

function TShortStringHelper.Replace(OldChar: AnsiChar;
  NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): ShortString;
begin

end;

function TShortStringHelper.Replace(const OldValue: ShortString;
  const NewValue: ShortString): ShortString;
begin

end;

function TShortStringHelper.Replace(const OldValue: ShortString;
  const NewValue: ShortString; ReplaceFlags: TReplaceFlags): ShortString;
begin

end;

function TAnsiStringHelper.Replace(OldChar: AnsiChar;
  NewChar: AnsiChar): AnsiString;
begin

end;

function TAnsiStringHelper.Replace(OldChar: AnsiChar;
  NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): AnsiString;
begin

end;

function TAnsiStringHelper.Replace(const OldValue: AnsiString;
  const NewValue: AnsiString): AnsiString;
begin

end;

function TAnsiStringHelper.Replace(const OldValue: AnsiString;
  const NewValue: AnsiString; ReplaceFlags: TReplaceFlags): AnsiString;
begin

end;

function TRawByteStringHelper.Replace(OldChar: AnsiChar;
  NewChar: AnsiChar): RawByteString;
begin

end;

function TRawByteStringHelper.Replace(OldChar: AnsiChar;
  NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): RawByteString;
begin

end;

function TRawByteStringHelper.Replace(const OldValue: RawByteString;
  const NewValue: RawByteString): RawByteString;
begin

end;

function TRawByteStringHelper.Replace(const OldValue: RawByteString;
  const NewValue: RawByteString; ReplaceFlags: TReplaceFlags): RawByteString;
begin

end;

function TUTF8StringHelper.Replace(OldChar: AnsiChar;
  NewChar: AnsiChar): UTF8String;
begin

end;

function TUTF8StringHelper.Replace(OldChar: AnsiChar;
  NewChar: AnsiChar; ReplaceFlags: TReplaceFlags): UTF8String;
begin

end;

function TUTF8StringHelper.Replace(const OldValue: UTF8String;
  const NewValue: UTF8String): UTF8String;
begin

end;

function TUTF8StringHelper.Replace(const OldValue: UTF8String;
  const NewValue: UTF8String; ReplaceFlags: TReplaceFlags): UTF8String;
begin

end;

function TWideStringHelper.Replace(OldChar: WideChar;
  NewChar: WideChar): WideString;
begin

end;

function TWideStringHelper.Replace(OldChar: WideChar;
  NewChar: WideChar; ReplaceFlags: TReplaceFlags): WideString;
begin

end;

function TWideStringHelper.Replace(const OldValue: WideString;
  const NewValue: WideString): WideString;
begin

end;

function TWideStringHelper.Replace(const OldValue: WideString;
  const NewValue: WideString; ReplaceFlags: TReplaceFlags): WideString;
begin

end;

function TUnicodeStringHelper.Replace(OldChar: UnicodeChar;
  NewChar: UnicodeChar): UnicodeString;
begin

end;

function TUnicodeStringHelper.Replace(OldChar: UnicodeChar;
  NewChar: UnicodeChar; ReplaceFlags: TReplaceFlags): UnicodeString;
begin

end;

function TUnicodeStringHelper.Replace(const OldValue: UnicodeString;
  const NewValue: UnicodeString): UnicodeString;
begin

end;

function TUnicodeStringHelper.Replace(const OldValue: UnicodeString;
  const NewValue: UnicodeString; ReplaceFlags: TReplaceFlags): UnicodeString;
begin

end;

function TShortStringHelper.Split(const Separator: array of AnsiChar):
  TArray<ShortString>;
begin

end;

function TShortStringHelper.Split(const Separator: array of AnsiChar;
  Count: Integer): TArray<ShortString>;
begin

end;

function TShortStringHelper.Split(const Separator: array of AnsiChar;
  Options: TStringSplitOptions): TArray<ShortString>;
begin

end;

function TShortStringHelper.Split(const Separator: array of ShortString;
  Options: TStringSplitOptions): TArray<ShortString>;
begin

end;

function TShortStringHelper.Split(const Separator: array of AnsiChar;
  Count: Integer; Options: TStringSplitOptions): TArray<ShortString>;
begin

end;

function TShortStringHelper.Split(const Separator: array of ShortString;
  Count: Integer; Options: TStringSplitOptions): TArray<ShortString>;
begin

end;

function TAnsiStringHelper.Split(const Separator: array of AnsiChar):
  TArray<AnsiString>;
begin

end;

function TAnsiStringHelper.Split(const Separator: array of AnsiChar;
  Count: Integer): TArray<AnsiString>;
begin

end;

function TAnsiStringHelper.Split(const Separator: array of AnsiChar;
  Options: TStringSplitOptions): TArray<AnsiString>;
begin

end;

function TAnsiStringHelper.Split(const Separator: array of AnsiString;
  Options: TStringSplitOptions): TArray<AnsiString>;
begin

end;

function TAnsiStringHelper.Split(const Separator: array of AnsiChar;
  Count: Integer; Options: TStringSplitOptions): TArray<AnsiString>;
begin

end;

function TAnsiStringHelper.Split(const Separator: array of AnsiString;
  Count: Integer; Options: TStringSplitOptions): TArray<AnsiString>;
begin

end;

function TRawByteStringHelper.Split(const Separator: array of AnsiChar):
  TArray<RawByteString>;
begin

end;

function TRawByteStringHelper.Split(const Separator: array of AnsiChar;
  Count: Integer): TArray<RawByteString>;
begin

end;

function TRawByteStringHelper.Split(const Separator: array of AnsiChar;
  Options: TStringSplitOptions): TArray<RawByteString>;
begin

end;

function TRawByteStringHelper.Split(const Separator: array of RawByteString;
  Options: TStringSplitOptions): TArray<RawByteString>;
begin

end;

function TRawByteStringHelper.Split(const Separator: array of AnsiChar;
  Count: Integer; Options: TStringSplitOptions): TArray<RawByteString>;
begin

end;

function TRawByteStringHelper.Split(const Separator: array of RawByteString;
  Count: Integer; Options: TStringSplitOptions): TArray<RawByteString>;
begin

end;

function TUTF8StringHelper.Split(const Separator: array of AnsiChar):
  TArray<UTF8String>;
begin

end;

function TUTF8StringHelper.Split(const Separator: array of AnsiChar;
  Count: Integer): TArray<UTF8String>;
begin

end;

function TUTF8StringHelper.Split(const Separator: array of AnsiChar;
  Options: TStringSplitOptions): TArray<UTF8String>;
begin

end;

function TUTF8StringHelper.Split(const Separator: array of UTF8String;
  Options: TStringSplitOptions): TArray<UTF8String>;
begin

end;

function TUTF8StringHelper.Split(const Separator: array of AnsiChar;
  Count: Integer; Options: TStringSplitOptions): TArray<UTF8String>;
begin

end;

function TUTF8StringHelper.Split(const Separator: array of UTF8String;
  Count: Integer; Options: TStringSplitOptions): TArray<UTF8String>;
begin

end;

function TWideStringHelper.Split(const Separator: array of WideChar):
  TArray<WideString>;
begin

end;

function TWideStringHelper.Split(const Separator: array of WideChar;
  Count: Integer): TArray<WideString>;
begin

end;

function TWideStringHelper.Split(const Separator: array of WideChar;
  Options: TStringSplitOptions): TArray<WideString>;
begin

end;

function TWideStringHelper.Split(const Separator: array of WideString;
  Options: TStringSplitOptions): TArray<WideString>;
begin

end;

function TWideStringHelper.Split(const Separator: array of WideChar;
  Count: Integer; Options: TStringSplitOptions): TArray<WideString>;
begin

end;

function TWideStringHelper.Split(const Separator: array of WideString;
  Count: Integer; Options: TStringSplitOptions): TArray<WideString>;
begin

end;

function TUnicodeStringHelper.Split(const Separator: array of UnicodeChar):
  TArray<UnicodeString>;
begin

end;

function TUnicodeStringHelper.Split(const Separator: array of UnicodeChar;
  Count: Integer): TArray<UnicodeString>;
begin

end;

function TUnicodeStringHelper.Split(const Separator: array of UnicodeChar;
  Options: TStringSplitOptions): TArray<UnicodeString>;
begin

end;

function TUnicodeStringHelper.Split(const Separator: array of UnicodeString;
  Options: TStringSplitOptions): TArray<UnicodeString>;
begin

end;

function TUnicodeStringHelper.Split(const Separator: array of UnicodeChar;
  Count: Integer; Options: TStringSplitOptions): TArray<UnicodeString>;
begin

end;

function TUnicodeStringHelper.Split(const Separator: array of UnicodeString;
  Count: Integer; Options: TStringSplitOptions): TArray<UnicodeString>;
begin

end;

function TShortStringHelper.StartsWith(const Value: ShortString): Boolean;
begin

end;

function TShortStringHelper.StartsWith(const Value: ShortString;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TAnsiStringHelper.StartsWith(const Value: AnsiString): Boolean;
begin

end;

function TAnsiStringHelper.StartsWith(const Value: AnsiString;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TRawByteStringHelper.StartsWith(const Value: RawByteString): Boolean;
begin

end;

function TRawByteStringHelper.StartsWith(const Value: RawByteString;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TUTF8StringHelper.StartsWith(const Value: UTF8String): Boolean;
begin

end;

function TUTF8StringHelper.StartsWith(const Value: UTF8String;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TWideStringHelper.StartsWith(const Value: WideString): Boolean;
begin

end;

function TWideStringHelper.StartsWith(const Value: WideString;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TUnicodeStringHelper.StartsWith(const Value: UnicodeString): Boolean;
begin

end;

function TUnicodeStringHelper.StartsWith(const Value: UnicodeString;
  IgnoreCase: Boolean): Boolean;
begin

end;

function TShortStringHelper.Substring(StartIndex: Integer): ShortString;
begin

end;

function TShortStringHelper.Substring(StartIndex: Integer; Length: Integer):
  ShortString;
begin

end;

function TAnsiStringHelper.Substring(StartIndex: Integer): AnsiString;
begin

end;

function TAnsiStringHelper.Substring(StartIndex: Integer; Length: Integer):
  AnsiString;
begin

end;

function TRawByteStringHelper.Substring(StartIndex: Integer): RawByteString;
begin

end;

function TRawByteStringHelper.Substring(StartIndex: Integer; Length: Integer):
  RawByteString;
begin

end;

function TUTF8StringHelper.Substring(StartIndex: Integer): UTF8String;
begin

end;

function TUTF8StringHelper.Substring(StartIndex: Integer; Length: Integer):
  UTF8String;
begin

end;

function TWideStringHelper.Substring(StartIndex: Integer): WideString;
begin

end;

function TWideStringHelper.Substring(StartIndex: Integer; Length: Integer):
  WideString;
begin

end;

function TUnicodeStringHelper.Substring(StartIndex: Integer): UnicodeString;
begin

end;

function TUnicodeStringHelper.Substring(StartIndex: Integer; Length: Integer):
  UnicodeString;
begin

end;

class function TShortStringHelper.ToBoolean(const S: ShortString): Boolean;
begin

end;

function TShortStringHelper.ToBoolean: Boolean;
begin

end;

class function TAnsiStringHelper.ToBoolean(const S: AnsiString): Boolean;
begin

end;

function TAnsiStringHelper.ToBoolean: Boolean;
begin

end;

class function TRawByteStringHelper.ToBoolean(const S: RawByteString): Boolean;
begin

end;

function TRawByteStringHelper.ToBoolean: Boolean;
begin

end;

class function TUTF8StringHelper.ToBoolean(const S: UTF8String): Boolean;
begin

end;

function TUTF8StringHelper.ToBoolean: Boolean;
begin

end;

class function TWideStringHelper.ToBoolean(const S: WideString): Boolean;
begin

end;

function TWideStringHelper.ToBoolean: Boolean;
begin

end;

class function TUnicodeStringHelper.ToBoolean(const S: UnicodeString): Boolean;
begin

end;

function TUnicodeStringHelper.ToBoolean: Boolean;
begin

end;

function TShortStringHelper.ToCharArray: TArray<AnsiChar>;
begin

end;

function TShortStringHelper.ToCharArray(StartIndex: Integer; Length: Integer):
  TArray<AnsiChar>;
begin

end;

function TAnsiStringHelper.ToCharArray: TArray<AnsiChar>;
begin

end;

function TAnsiStringHelper.ToCharArray(StartIndex: Integer; Length: Integer):
  TArray<AnsiChar>;
begin

end;

function TRawByteStringHelper.ToCharArray: TArray<AnsiChar>;
begin

end;

function TRawByteStringHelper.ToCharArray(StartIndex: Integer; Length: Integer):
  TArray<AnsiChar>;
begin

end;

function TUTF8StringHelper.ToCharArray: TArray<AnsiChar>;
begin

end;

function TUTF8StringHelper.ToCharArray(StartIndex: Integer; Length: Integer):
  TArray<AnsiChar>;
begin

end;

function TWideStringHelper.ToCharArray: TArray<WideChar>;
begin

end;

function TWideStringHelper.ToCharArray(StartIndex: Integer; Length: Integer):
  TArray<WideChar>;
begin

end;

function TUnicodeStringHelper.ToCharArray: TArray<UnicodeChar>;
begin

end;

function TUnicodeStringHelper.ToCharArray(StartIndex: Integer; Length: Integer):
  TArray<UnicodeChar>;
begin

end;

{$PUSH}{$WARN IMPLICIT_STRING_CAST OFF}{$WARN IMPLICIT_STRING_CAST_LOSS OFF}
class function TShortStringHelper.ToDouble(const S: ShortString): Double;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TShortStringHelper.ToDouble: Double;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TAnsiStringHelper.ToDouble(const S: AnsiString): Double;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TAnsiStringHelper.ToDouble: Double;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TRawByteStringHelper.ToDouble(const S: RawByteString): Double;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TRawByteStringHelper.ToDouble: Double;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TUTF8StringHelper.ToDouble(const S: UTF8String): Double;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TUTF8StringHelper.ToDouble: Double;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TWideStringHelper.ToDouble(const S: WideString): Double;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TWideStringHelper.ToDouble: Double;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TUnicodeStringHelper.ToDouble(const S: UnicodeString): Double;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TUnicodeStringHelper.ToDouble: Double;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TShortStringHelper.ToExtended(const S: ShortString):
  Extended;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TShortStringHelper.ToExtended: Extended;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TAnsiStringHelper.ToExtended(const S: AnsiString):
  Extended;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TAnsiStringHelper.ToExtended: Extended;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TRawByteStringHelper.ToExtended(const S: RawByteString):
  Extended;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TRawByteStringHelper.ToExtended: Extended;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TUTF8StringHelper.ToExtended(const S: UTF8String):
  Extended;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TUTF8StringHelper.ToExtended: Extended;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TWideStringHelper.ToExtended(const S: WideString):
  Extended;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TWideStringHelper.ToExtended: Extended;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TUnicodeStringHelper.ToExtended(const S: UnicodeString):
  Extended;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TUnicodeStringHelper.ToExtended: Extended;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TShortStringHelper.ToInt64(const S: ShortString): Int64;
begin
  Result := SysUtils.StrToInt64(S);
end;

function TShortStringHelper.ToInt64: Int64;
begin
  Result := SysUtils.StrToInt64(Self);
end;

class function TAnsiStringHelper.ToInt64(const S: AnsiString): Int64;
begin
  Result := SysUtils.StrToInt64(S);
end;

function TAnsiStringHelper.ToInt64: Int64;
begin
  Result := SysUtils.StrToInt64(Self);
end;

class function TRawByteStringHelper.ToInt64(const S: RawByteString): Int64;
begin
  Result := SysUtils.StrToInt64(S);
end;

function TRawByteStringHelper.ToInt64: Int64;
begin
  Result := SysUtils.StrToInt64(Self);
end;

class function TUTF8StringHelper.ToInt64(const S: UTF8String): Int64;
begin
  Result := SysUtils.StrToInt64(S);
end;

function TUTF8StringHelper.ToInt64: Int64;
begin
  Result := SysUtils.StrToInt64(Self);
end;

class function TWideStringHelper.ToInt64(const S: WideString): Int64;
begin
  Result := SysUtils.StrToInt64(S);
end;

function TWideStringHelper.ToInt64: Int64;
begin
  Result := SysUtils.StrToInt64(Self);
end;

class function TUnicodeStringHelper.ToInt64(const S: UnicodeString): Int64;
begin
  Result := SysUtils.StrToInt64(S);
end;

function TUnicodeStringHelper.ToInt64: Int64;
begin
  Result := SysUtils.StrToInt64(Self);
end;

class function TShortStringHelper.ToInteger(const S: ShortString): Integer;
{$IFDEF CPU64}
var
  Res64: Int64;
  Error: Word;
begin
  Val(S, Res64, Error);
  if (Error <> 0) or (Res64 < Low(Result)) or (Res64 > High(Result)) then
    raise EConvertError.CreateFmt(SInvalidInteger, [S]);

  Result := Integer(Res64);
{$ELSE}
begin
  Result := SysUtils.StrToInt(S);
{$IFEND}
end;

function TShortStringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

class function TAnsiStringHelper.ToInteger(const S: AnsiString): Integer;
{$IFDEF CPU64}
var
  Res64: Int64;
  Error: Word;
begin
  Val(S, Res64, Error);
  if (Error <> 0) or (Res64 < Low(Result)) or (Res64 > High(Result)) then
    raise EConvertError.CreateFmt(SInvalidInteger, [S]);

  Result := Integer(Res64);
{$ELSE}
begin
  Result := SysUtils.StrToInt(S);
{$IFEND}
end;

function TAnsiStringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

class function TRawByteStringHelper.ToInteger(const S: RawByteString): Integer;
{$IFDEF CPU64}
var
  Res64: Int64;
  Error: Word;
begin
  Val(S, Res64, Error);
  if (Error <> 0) or (Res64 < Low(Result)) or (Res64 > High(Result)) then
    raise EConvertError.CreateFmt(SInvalidInteger, [S]);

  Result := Integer(Res64);
{$ELSE}
begin
  Result := SysUtils.StrToInt(S);
{$IFEND}
end;

function TRawByteStringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

class function TUTF8StringHelper.ToInteger(const S: UTF8String): Integer;
{$IFDEF CPU64}
var
  Res64: Int64;
  Error: Word;
begin
  Val(S, Res64, Error);
  if (Error <> 0) or (Res64 < Low(Result)) or (Res64 > High(Result)) then
    raise EConvertError.CreateFmt(SInvalidInteger, [S]);

  Result := Integer(Res64);
{$ELSE}
begin
  Result := SysUtils.StrToInt(S);
{$IFEND}
end;

function TUTF8StringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

class function TWideStringHelper.ToInteger(const S: WideString): Integer;
{$IFDEF CPU64}
var
  Res64: Int64;
  Error: Word;
begin
  Val(S, Res64, Error);
  if (Error <> 0) or (Res64 < Low(Result)) or (Res64 > High(Result)) then
    raise EConvertError.CreateFmt(SInvalidInteger, [S]);

  Result := Integer(Res64);
{$ELSE}
begin
  Result := SysUtils.StrToInt(S);
{$IFEND}
end;

function TWideStringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;

class function TUnicodeStringHelper.ToInteger(const S: UnicodeString): Integer;
{$IFDEF CPU64}
var
  Res64: Int64;
  Error: Word;
begin
  Val(S, Res64, Error);
  if (Error <> 0) or (Res64 < Low(Result)) or (Res64 > High(Result)) then
    raise EConvertError.CreateFmt(SInvalidInteger, [S]);

  Result := Integer(Res64);
{$ELSE}
begin
  Result := SysUtils.StrToInt(S);
{$IFEND}
end;

function TUnicodeStringHelper.ToInteger: Integer;
begin
  Result := Self.ToInteger(Self);
end;
{$POP}

function TShortStringHelper.ToLower: ShortString;
begin

end;

function TShortStringHelper.ToLower(LocaleID: TLocaleID): ShortString;
begin

end;

function TAnsiStringHelper.ToLower: AnsiString;
begin

end;

function TAnsiStringHelper.ToLower(LocaleID: TLocaleID): AnsiString;
begin

end;

function TRawByteStringHelper.ToLower: RawByteString;
begin

end;

function TRawByteStringHelper.ToLower(LocaleID: TLocaleID): RawByteString;
begin

end;

function TUTF8StringHelper.ToLower: UTF8String;
begin

end;

function TUTF8StringHelper.ToLower(LocaleID: TLocaleID): UTF8String;
begin

end;

function TWideStringHelper.ToLower: WideString;
begin

end;

function TWideStringHelper.ToLower(LocaleID: TLocaleID): WideString;
begin

end;

function TUnicodeStringHelper.ToLower: UnicodeString;
begin

end;

function TUnicodeStringHelper.ToLower(LocaleID: TLocaleID): UnicodeString;
begin

end;

function TShortStringHelper.ToLowerInvariant: ShortString;
begin
  if DefaultSystemCodePage = CP_UTF8 then
    Result := UTF8Encode(WideLowerCase(UTF8Decode(Self)))
  else
    Result := RawByteString(WideLowerCase(WideString(Self)));
end;

function TAnsiStringHelper.ToLowerInvariant: AnsiString;
begin
  case StringCodePage(Self) of
    CP_UTF8:
      Result := UTF8Encode(WideLowerCase(UTF8Decode(Self)));
    CP_NONE:
      Result := System.LowerCase(Self);
    else begin
      Result := Self;
      SetCodePage(RawByteString(Result), CP_UTF8);
      Result := UTF8Encode(WideLowerCase(UTF8Decode(Result)));
      SetCodePage(RawByteString(Result), StringCodePage(Self));
    end;
  end;
end;

function TRawByteStringHelper.ToLowerInvariant: RawByteString;
begin
  case StringCodePage(Self) of
    CP_UTF8:
      Result := UTF8Encode(WideLowerCase(UTF8Decode(Self)));
    CP_NONE:
      Result := System.LowerCase(Self);
    else begin
      Result := Self;
      SetCodePage(RawByteString(Result), CP_UTF8);
      Result := UTF8Encode(WideLowerCase(UTF8Decode(Result)));
      SetCodePage(RawByteString(Result), StringCodePage(Self));
    end;
  end;
end;

function TUTF8StringHelper.ToLowerInvariant: UTF8String;
begin
  case StringCodePage(Self) of
    CP_UTF8:
      Result := UTF8Encode(WideLowerCase(UTF8Decode(Self)));
    CP_NONE:
      Result := System.LowerCase(Self);
    else begin
      Result := Self;
      SetCodePage(RawByteString(Result), CP_UTF8);
      Result := UTF8Encode(WideLowerCase(UTF8Decode(Result)));
      SetCodePage(RawByteString(Result), StringCodePage(Self));
    end;
  end;
end;

function TWideStringHelper.ToLowerInvariant: WideString;
begin
  Result := WideLowerCase(Self);
end;

function TUnicodeStringHelper.ToLowerInvariant: UnicodeString;
begin
  Result := WideLowerCase(Self);
end;

{$PUSH}{$WARN IMPLICIT_STRING_CAST OFF}{$WARN IMPLICIT_STRING_CAST_LOSS OFF}
class function TShortStringHelper.ToSingle(const S: ShortString): Single;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TShortStringHelper.ToSingle: Single;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TAnsiStringHelper.ToSingle(const S: AnsiString): Single;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TAnsiStringHelper.ToSingle: Single;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TRawByteStringHelper.ToSingle(const S: RawByteString): Single;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TRawByteStringHelper.ToSingle: Single;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TUTF8StringHelper.ToSingle(const S: UTF8String): Single;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TUTF8StringHelper.ToSingle: Single;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TWideStringHelper.ToSingle(const S: WideString): Single;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TWideStringHelper.ToSingle: Single;
begin
  Result := SysUtils.StrToFloat(Self);
end;

class function TUnicodeStringHelper.ToSingle(const S: UnicodeString): Single;
begin
  Result := SysUtils.StrToFloat(S);
end;

function TUnicodeStringHelper.ToSingle: Single;
begin
  Result := SysUtils.StrToFloat(Self);
end;
{$POP}

function TShortStringHelper.ToUpper: ShortString;
begin

end;

function TShortStringHelper.ToUpper(LocaleID: TLocaleID): ShortString;
begin

end;

function TAnsiStringHelper.ToUpper: AnsiString;
begin

end;

function TAnsiStringHelper.ToUpper(LocaleID: TLocaleID): AnsiString;
begin

end;

function TRawByteStringHelper.ToUpper: RawByteString;
begin

end;

function TRawByteStringHelper.ToUpper(LocaleID: TLocaleID): RawByteString;
begin

end;

function TUTF8StringHelper.ToUpper: UTF8String;
begin

end;

function TUTF8StringHelper.ToUpper(LocaleID: TLocaleID): UTF8String;
begin

end;

function TWideStringHelper.ToUpper: WideString;
begin

end;

function TWideStringHelper.ToUpper(LocaleID: TLocaleID): WideString;
begin

end;

function TUnicodeStringHelper.ToUpper: UnicodeString;
begin

end;

function TUnicodeStringHelper.ToUpper(LocaleID: TLocaleID): UnicodeString;
begin

end;

function TShortStringHelper.ToUpperInvariant: ShortString;
begin
  if DefaultSystemCodePage = CP_UTF8 then
    Result := UTF8Encode(WideUpperCase(UTF8Decode(Self)))
  else
    Result := RawByteString(WideUpperCase(WideString(Self)));
end;

function TAnsiStringHelper.ToUpperInvariant: AnsiString;
begin
  case StringCodePage(Self) of
    CP_UTF8:
      Result := UTF8Encode(WideUpperCase(UTF8Decode(Self)));
    CP_NONE:
      Result := System.UpCase(Self);
    else begin
      Result := Self;
      SetCodePage(RawByteString(Result), CP_UTF8);
      Result := UTF8Encode(WideUpperCase(UTF8Decode(Result)));
      SetCodePage(RawByteString(Result), StringCodePage(Self));
    end;
  end;
end;

function TRawByteStringHelper.ToUpperInvariant: RawByteString;
begin
  case StringCodePage(Self) of
    CP_UTF8:
      Result := UTF8Encode(WideUpperCase(UTF8Decode(Self)));
    CP_NONE:
      Result := System.UpCase(Self);
    else begin
      Result := Self;
      SetCodePage(RawByteString(Result), CP_UTF8);
      Result := UTF8Encode(WideUpperCase(UTF8Decode(Result)));
      SetCodePage(RawByteString(Result), StringCodePage(Self));
    end;
  end;
end;

function TUTF8StringHelper.ToUpperInvariant: UTF8String;
begin
  case StringCodePage(Self) of
    CP_UTF8:
      Result := UTF8Encode(WideUpperCase(UTF8Decode(Self)));
    CP_NONE:
      Result := System.UpCase(Self);
    else begin
      Result := Self;
      SetCodePage(RawByteString(Result), CP_UTF8);
      Result := UTF8Encode(WideUpperCase(UTF8Decode(Result)));
      SetCodePage(RawByteString(Result), StringCodePage(Self));
    end;
  end;
end;

function TWideStringHelper.ToUpperInvariant: WideString;
begin
  Result := WideUpperCase(Self);
end;

function TUnicodeStringHelper.ToUpperInvariant: UnicodeString;
begin
  Result := WideUpperCase(Self);
end;

function TShortStringHelper.Trim: ShortString;
begin
  Result := SysUtils.Trim(Self);
end;

function TShortStringHelper.Trim(const TrimChars: array of AnsiChar):
  ShortString;
begin
  Result := Self.TrimLeft(TrimChars).TrimRight(TrimChars);
end;

//function TAnsiStringHelper.Trim: AnsiString;
//begin
//  Result := SysUtils.Trim(Self);
//end;

//function TAnsiStringHelper.Trim(const TrimChars: array of AnsiChar):
//  AnsiString;
//begin
//  Result := Self.TrimLeft(TrimChars).TrimRight(TrimChars);
//end;

//function TRawByteStringHelper.Trim: RawByteString;
//begin
//  Result := SysUtils.Trim(Self);
//end;

//function TRawByteStringHelper.Trim(const TrimChars: array of AnsiChar):
//  RawByteString;
//begin
//  Result := Self.TrimLeft(TrimChars).TrimRight(TrimChars);
//end;

(*function TUTF8StringHelper.Trim: UTF8String;
begin
  Result := SysUtils.Trim(Self);
end;

function TUTF8StringHelper.Trim(const TrimChars: array of AnsiChar):
  UTF8String;
begin
  Result := Self.TrimLeft(TrimChars).TrimRight(TrimChars);
end;

function TWideStringHelper.Trim: WideString;
begin
  Result := SysUtils.Trim(Self);
end;

function TWideStringHelper.Trim(const TrimChars: array of WideChar):
  WideString;
begin
  Result := Self.TrimLeft(TrimChars).TrimRight(TrimChars);
end;

function TUnicodeStringHelper.Trim: UnicodeString;
begin
  Result := SysUtils.Trim(Self);
end;

function TUnicodeStringHelper.Trim(const TrimChars: array of UnicodeChar):
  UnicodeString;
begin
  Result := Self.TrimLeft(TrimChars).TrimRight(TrimChars);
end; *)

function TShortStringHelper.TrimEnd(const TrimChars: array of AnsiChar):
  ShortString;
begin
  Result := Self.TrimRight(TrimChars);
end;

function TAnsiStringHelper.TrimEnd(const TrimChars: array of AnsiChar):
  AnsiString;
begin
  Result := Self.TrimRight(TrimChars);
end;

function TRawByteStringHelper.TrimEnd(const TrimChars: array of AnsiChar):
  RawByteString;
begin
  Result := Self.TrimRight(TrimChars);
end;

function TUTF8StringHelper.TrimEnd(const TrimChars: array of AnsiChar):
  UTF8String;
begin
  Result := Self.TrimRight(TrimChars);
end;

function TWideStringHelper.TrimEnd(const TrimChars: array of WideChar):
  WideString;
begin
  Result := Self.TrimRight(TrimChars);
end;

function TUnicodeStringHelper.TrimEnd(const TrimChars: array of UnicodeChar):
  UnicodeString;
begin
  Result := Self.TrimRight(TrimChars);
end;

function TShortStringHelper.TrimLeft: ShortString;
begin
  Result := SysUtils.TrimLeft(Self);
end;

function TShortStringHelper.TrimLeft(const TrimChars: array of AnsiChar):
  ShortString;
var
  TrimSet: set of AnsiChar;
  i, LastChar: Integer;
begin
  TrimSet := [];
  for i := Low(TrimChars) to High(TrimChars) do
    TrimSet := TrimSet + [TrimChars[i]];

  i := 1{Low(Self)};
  LastChar := Self.Length;
  while (i <= LastChar) and (Self[i] in TrimSet) do
    Inc(i);

  if i = 1 then
    Result := Self
  else if i > LastChar then
    Result := ''
  else
    Result := System.Copy(Self, i, LastChar - i + 1{Low(Self)});
end;

//function TAnsiStringHelper.TrimLeft: AnsiString;
//begin
//  Result := SysUtils.TrimLeft(Self);
//end;

//function TAnsiStringHelper.TrimLeft(const TrimChars: array of AnsiChar):
//  AnsiString;
//var
//  TrimSet: set of AnsiChar;
//  i, LastChar: Integer;
//begin
//  TrimSet := [];
//  for i := Low(TrimChars) to High(TrimChars) do
//    TrimSet := TrimSet + [TrimChars[i]];
//
//  i := Low(Self);
//  LastChar := High(Self);
//  while (i <= LastChar) and (Self[i] in TrimSet) do
//    Inc(i);

//  if i = 1 then
//    Result := Self
//  else if i > LastChar then
//    Result := ''
//  else
//    Result := System.Copy(Self, i, LastChar - i + Low(Self));
//end;

//function TRawByteStringHelper.TrimLeft: RawByteString;
//begin
//  Result := SysUtils.TrimLeft(Self);
//end;

(*function TRawByteStringHelper.TrimLeft(const TrimChars: array of AnsiChar):
  RawByteString;
var
  TrimSet: set of AnsiChar;
  i, LastChar: Integer;
begin
  TrimSet := [];
  for i := Low(TrimChars) to High(TrimChars) do
    TrimSet := TrimSet + [TrimChars[i]];

  i := Low(Self);
  LastChar := High(Self);
  while (i <= LastChar) and (Self[i] in TrimSet) do
    Inc(i);

  if i = 1 then
    Result := Self
  else if i > LastChar then
    Result := ''
  else
    Result := System.Copy(Self, i, LastChar - i + Low(Self));
end;

function TUTF8StringHelper.TrimLeft: UTF8String;
begin
  Result := SysUtils.TrimLeft(Self);
end;

function TUTF8StringHelper.TrimLeft(const TrimChars: array of AnsiChar):
  UTF8String;
var
  TrimSet: set of AnsiChar;
  i, LastChar: Integer;
begin
  TrimSet := [];
  for i := Low(TrimChars) to High(TrimChars) do
    TrimSet := TrimSet + [TrimChars[i]];

  i := Low(Self);
  LastChar := High(Self);
  while (i <= LastChar) and (Self[i] in TrimSet) do
    Inc(i);

  if i = 1 then
    Result := Self
  else if i > LastChar then
    Result := ''
  else
    Result := System.Copy(Self, i, LastChar - i + Low(Self));
end;

function TWideStringHelper.TrimLeft: WideString;
begin
  Result := SysUtils.TrimLeft(Self);
end;

function TWideStringHelper.TrimLeft(const TrimChars: array of WideChar):
  WideString;
var
  i, LastChar: Integer;
begin
  i := Low(Self);
  LastChar := High(Self);
  while (i <= LastChar) and HaveChar(Self[i], TrimChars) do
    Inc(i);

  if i = 1 then
    Result := Self
  else if i > LastChar then
    Result := ''
  else
    Result := System.Copy(Self, i, LastChar - i + Low(Self));
end;

function TUnicodeStringHelper.TrimLeft: UnicodeString;
begin
  Result := SysUtils.TrimLeft(Self);
end;

function TUnicodeStringHelper.TrimLeft(const TrimChars: array of UnicodeChar):
  UnicodeString;
var
  i, LastChar: Integer;
begin
  i := Low(Self);
  LastChar := High(Self);
  while (i <= LastChar) and HaveChar(Self[i], TrimChars) do
    Inc(i);

  if i = 1 then
    Result := Self
  else if i > LastChar then
    Result := ''
  else
    Result := System.Copy(Self, i, LastChar - i + Low(Self));
end; *)

function TShortStringHelper.TrimRight: ShortString;
begin
  Result := SysUtils.TrimRight(Self);
end;

function TShortStringHelper.TrimRight(const TrimChars: array of AnsiChar):
  ShortString;
var
  TrimSet: set of AnsiChar;
  i, LastChar: Integer;
begin
  TrimSet := [];
  for i := Low(TrimChars) to High(TrimChars) do
    TrimSet := TrimSet + [TrimChars[i]];

  LastChar := Self.Length;
  i := LastChar;
  while (i >= 1{Low(Self)}) and (Self[i] in TrimSet) do
    Dec(i);

  if i < 1 then
    Result := ''
  else if i = LastChar then
    Result := Self
  else
    Result := System.Copy(Self, 1{Low(Self)}, i);
end;

function TAnsiStringHelper.TrimRight: AnsiString;
begin
  Result := SysUtils.TrimRight(Self);
end;

function TAnsiStringHelper.TrimRight(const TrimChars: array of AnsiChar):
  AnsiString;
var
  TrimSet: set of AnsiChar;
  i, LastChar: Integer;
begin
  TrimSet := [];
  for i := Low(TrimChars) to High(TrimChars) do
    TrimSet := TrimSet + [TrimChars[i]];

  LastChar := High(Self);
  i := LastChar;
  while (i >= Low(Self)) and (Self[i] in TrimSet) do
    Dec(i);

  if i < 1 then
    Result := ''
  else if i = LastChar then
    Result := Self
  else
    Result := System.Copy(Self, Low(Self), i);
end;

function TRawByteStringHelper.TrimRight: RawByteString;
begin
  Result := SysUtils.TrimRight(Self);
end;

function TRawByteStringHelper.TrimRight(const TrimChars: array of AnsiChar):
  RawByteString;
var
  TrimSet: set of AnsiChar;
  i, LastChar: Integer;
begin
  TrimSet := [];
  for i := Low(TrimChars) to High(TrimChars) do
    TrimSet := TrimSet + [TrimChars[i]];

  LastChar := High(Self);
  i := LastChar;
  while (i >= Low(Self)) and (Self[i] in TrimSet) do
    Dec(i);

  if i < 1 then
    Result := ''
  else if i = LastChar then
    Result := Self
  else
    Result := System.Copy(Self, Low(Self), i);
end;

function TUTF8StringHelper.TrimRight: UTF8String;
begin
  Result := SysUtils.TrimRight(Self);
end;

function TUTF8StringHelper.TrimRight(const TrimChars: array of AnsiChar):
  UTF8String;
var
  TrimSet: set of AnsiChar;
  i, LastChar: Integer;
begin
  TrimSet := [];
  for i := Low(TrimChars) to High(TrimChars) do
    TrimSet := TrimSet + [TrimChars[i]];

  LastChar := High(Self);
  i := LastChar;
  while (i >= Low(Self)) and (Self[i] in TrimSet) do
    Dec(i);

  if i < 1 then
    Result := ''
  else if i = LastChar then
    Result := Self
  else
    Result := System.Copy(Self, Low(Self), i);
end;

function TWideStringHelper.TrimRight: WideString;
begin
  Result := SysUtils.TrimRight(Self);
end;

function TWideStringHelper.TrimRight(const TrimChars: array of WideChar):
  WideString;
var
  i, LastChar: Integer;
begin
  LastChar := High(Self);
  i := LastChar;
  while (i >= Low(Self)) and HaveChar(Self[i], TrimChars) do
    Dec(i);

  if i < 1 then
    Result := ''
  else if i = LastChar then
    Result := Self
  else
    Result := System.Copy(Self, Low(Self), i);
end;

function TUnicodeStringHelper.TrimRight: UnicodeString;
begin
  Result := SysUtils.TrimRight(Self);
end;

function TUnicodeStringHelper.TrimRight(const TrimChars: array of UnicodeChar):
  UnicodeString;
var
  i, LastChar: Integer;
begin
  LastChar := High(Self);
  i := LastChar;
  while (i >= Low(Self)) and HaveChar(Self[i], TrimChars) do
    Dec(i);

  if i < 1 then
    Result := ''
  else if i = LastChar then
    Result := Self
  else
    Result := System.Copy(Self, Low(Self), i);
end;

function TShortStringHelper.TrimStart(const TrimChars: array of AnsiChar):
  ShortString;
begin
  Result := Self.TrimLeft(TrimChars);
end;

(* function TAnsiStringHelper.TrimStart(const TrimChars: array of AnsiChar):
  AnsiString;
begin
  Result := Self.TrimLeft(TrimChars);
end;

function TRawByteStringHelper.TrimStart(const TrimChars: array of AnsiChar):
  RawByteString;
begin
  Result := Self.TrimLeft(TrimChars);
end;

function TUTF8StringHelper.TrimStart(const TrimChars: array of AnsiChar):
  UTF8String;
begin
  Result := Self.TrimLeft(TrimChars);
end;

function TWideStringHelper.TrimStart(const TrimChars: array of WideChar):
  WideString;
begin
  Result := Self.TrimLeft(TrimChars);
end;

function TUnicodeStringHelper.TrimStart(const TrimChars: array of UnicodeChar):
  UnicodeString;
begin
  Result := Self.TrimLeft(TrimChars);
end; *)

class function TShortStringHelper.UpperCase(const S: ShortString):
  ShortString;
begin

end;

class function TShortStringHelper.UpperCase(const S: ShortString;
  LocaleOptions: TLocaleOptions): ShortString;
begin

end;

class function TAnsiStringHelper.UpperCase(const S: AnsiString):
  AnsiString;
begin

end;

class function TAnsiStringHelper.UpperCase(const S: AnsiString;
  LocaleOptions: TLocaleOptions): AnsiString;
begin

end;

class function TRawByteStringHelper.UpperCase(const S: RawByteString):
  RawByteString;
begin

end;

class function TRawByteStringHelper.UpperCase(const S: RawByteString;
  LocaleOptions: TLocaleOptions): RawByteString;
begin

end;

class function TUTF8StringHelper.UpperCase(const S: UTF8String):
  UTF8String;
begin

end;

class function TUTF8StringHelper.UpperCase(const S: UTF8String;
  LocaleOptions: TLocaleOptions): UTF8String;
begin

end;

class function TWideStringHelper.UpperCase(const S: WideString):
  WideString;
begin

end;

class function TWideStringHelper.UpperCase(const S: WideString;
  LocaleOptions: TLocaleOptions): WideString;
begin

end;

class function TUnicodeStringHelper.UpperCase(const S: UnicodeString):
  UnicodeString;
begin

end;

class function TUnicodeStringHelper.UpperCase(const S: UnicodeString;
  LocaleOptions: TLocaleOptions): UnicodeString;
begin

end;

