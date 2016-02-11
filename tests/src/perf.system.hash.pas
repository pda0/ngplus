{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit Perf.System.Hash;

interface

uses
  SysUtils, System.Hash, Perf.Test;

type
  TDefaultHash = (
    MD5, SHA1, SHA2_224, SHA2_256, SHA2_384, SHA2_512, SHA2_512_224,
    SHA2_512_256, BobJenkins
  );

const
  HASH_NAMES: array [TDefaultHash] of string = (
    'THashMD5', 'THashSHA1', 'THashSHA2(SHA224)', 'THashSHA2(SHA256)',
    'THashSHA2(SHA384)', 'THashSHA2(SHA512)', 'THashSHA2(SHA512_224)',
    'THashSHA2(SHA512_256)', 'THashBobJenkins'
  );

type
  TAbstractHashPerfTest = class(TAbstractPerfTest)
  protected
    FHashData, FDummyDigest: TBytes;
  public
    procedure Setup(Seq: Integer); override;
  end;

  TMD5HashPerfTest = class(TAbstractHashPerfTest)
  private
    FHash: THashMD5;
  protected
    function GetName: string; override;
  public
    constructor Create;
    procedure Run; override;
  end;

  TSHA1HashPerfTest = class(TAbstractHashPerfTest)
  private
    FHash: THashSHA1;
  protected
    function GetName: string; override;
  public
    constructor Create;
    procedure Run; override;
  end;

  TSHA2HashPerfTest = class(TAbstractHashPerfTest)
  private
    FHash: THashSHA2;
    FHashType: TDefaultHash;
  protected
    function GetName: string; override;
  public
    constructor Create(AHash: TDefaultHash);
    procedure Run; override;
  end;

  TBobJenkinsHashPerfTest = class(TAbstractHashPerfTest)
  private
    FHash: THashBobJenkins;
  protected
    function GetName: string; override;
  public
    constructor Create;
    procedure Run; override;
  end;

procedure RunTests;

implementation

const
  { 10 .. 10000000 bytes }
  HASH_SIZE_SCALE = 6;
  { 10000 .. 10000000 counts }
  HASH_SCALE_END = 3;
  HASH_SCALE_START = 6;

{ TAbstractHashPerfTest }

procedure TAbstractHashPerfTest.Setup(Seq: Integer);
begin
  SetLength(FHashData, TPerfTestRunner.ScaleCount(Seq));
  FillChar(FHashData[Low(FHashData)], Length(FHashData), $ff);
end;

{ TMD5HashPerfTest }

constructor TMD5HashPerfTest.Create;
begin
   FHash := THashMD5.Create;
end;

function TMD5HashPerfTest.GetName: string;
begin
  Result := HASH_NAMES[MD5];
end;

procedure TMD5HashPerfTest.Run;
begin
  FHash.Reset;
  FHash.Update(FHashData);
  FDummyDigest := FHash.HashAsBytes;
end;

{ TSHA1HashPerfTest }

constructor TSHA1HashPerfTest.Create;
begin
  FHash := THashSHA1.Create;
end;

function TSHA1HashPerfTest.GetName: string;
begin
  Result := HASH_NAMES[SHA1];
end;

procedure TSHA1HashPerfTest.Run;
begin
  FHash.Reset;
  FHash.Update(FHashData);
  FDummyDigest := FHash.HashAsBytes;
end;

{ TSHA2HashPerfTest }

constructor TSHA2HashPerfTest.Create(AHash: TDefaultHash);
begin
  FHashType := AHash;
  case FHashType of
    SHA2_224:
      FHash := THashSHA2.Create(SHA224);
    SHA2_256:
      FHash := THashSHA2.Create(SHA256);
    SHA2_384:
      FHash := THashSHA2.Create(SHA384);
    SHA2_512:
      FHash := THashSHA2.Create(SHA512);
    SHA2_512_224:
      FHash := THashSHA2.Create(SHA512_224);
    SHA2_512_256:
      FHash := THashSHA2.Create(SHA512_256);
    else
      raise Exception.Create('Not a SHA-2 hash');
  end;
end;

function TSHA2HashPerfTest.GetName: string;
begin
  Result := HASH_NAMES[FHashType];
end;

procedure TSHA2HashPerfTest.Run;
begin
  FHash.Reset;
  FHash.Update(FHashData);
  FDummyDigest := FHash.HashAsBytes;
end;

{ TBobJenkinsHashPerfTest }

constructor TBobJenkinsHashPerfTest.Create;
begin
  FHash := THashBobJenkins.Create;
end;

function TBobJenkinsHashPerfTest.GetName: string;
begin
  Result := HASH_NAMES[BobJenkins];
end;

procedure TBobJenkinsHashPerfTest.Run;
begin
  FHash.Reset;
  FHash.Update(FHashData);
  FDummyDigest := FHash.HashAsBytes;
end;

procedure RunTests;
var
  HashTest: TAbstractPerfTest;
  MD5Res, SHA1Res, SHA2_224Res, SHA2_256Res, SHA2_384Res, SHA2_512Res,
  SHA2_512_224Res, SHA2_512_256Res, BobJenkinsRes: TPerfTestArray;
  i: Integer;
begin
  HashTest := nil;
  try
    HashTest := TMD5HashPerfTest.Create;
    MD5Res := TPerfTestRunner.RunTests(HashTest, HASH_SIZE_SCALE, HASH_SCALE_START, HASH_SCALE_END);

    FreeAndNil(HashTest);
    HashTest := TSHA1HashPerfTest.Create;
    SHA1Res := TPerfTestRunner.RunTests(HashTest, HASH_SIZE_SCALE, HASH_SCALE_START, HASH_SCALE_END);

    FreeAndNil(HashTest);
    HashTest := TSHA2HashPerfTest.Create(SHA2_224);
    SHA2_224Res := TPerfTestRunner.RunTests(HashTest, HASH_SIZE_SCALE, HASH_SCALE_START, HASH_SCALE_END);

    FreeAndNil(HashTest);
    HashTest := TSHA2HashPerfTest.Create(SHA2_256);
    SHA2_256Res := TPerfTestRunner.RunTests(HashTest, HASH_SIZE_SCALE, HASH_SCALE_START, HASH_SCALE_END);

    FreeAndNil(HashTest);
    HashTest := TSHA2HashPerfTest.Create(SHA2_384);
    SHA2_384Res := TPerfTestRunner.RunTests(HashTest, HASH_SIZE_SCALE, HASH_SCALE_START, HASH_SCALE_END);

    FreeAndNil(HashTest);
    HashTest := TSHA2HashPerfTest.Create(SHA2_512);
    SHA2_512Res := TPerfTestRunner.RunTests(HashTest, HASH_SIZE_SCALE, HASH_SCALE_START, HASH_SCALE_END);

    FreeAndNil(HashTest);
    HashTest := TSHA2HashPerfTest.Create(SHA2_512_224);
    SHA2_512_224Res := TPerfTestRunner.RunTests(HashTest, HASH_SIZE_SCALE, HASH_SCALE_START, HASH_SCALE_END);

    FreeAndNil(HashTest);
    HashTest := TSHA2HashPerfTest.Create(SHA2_512_256);
    SHA2_512_256Res := TPerfTestRunner.RunTests(HashTest, HASH_SIZE_SCALE, HASH_SCALE_START, HASH_SCALE_END);

    FreeAndNil(HashTest);
    HashTest := TBobJenkinsHashPerfTest.Create;
    BobJenkinsRes := TPerfTestRunner.RunTests(HashTest, HASH_SIZE_SCALE, HASH_SCALE_START, HASH_SCALE_END);

    Writeln(HASH_NAMES[TDefaultHash.MD5], ':');
    for i := Low(MD5Res) to High(MD5Res) do
      Writeln(Format('%10d %8.4f kHash/sec', [TPerfTestRunner.ScaleCount(i), MD5Res[i].CPS / 1000]));

    Writeln(HASH_NAMES[TDefaultHash.SHA1], ':');
    for i := Low(SHA1Res) to High(SHA1Res) do
      Writeln(Format('%10d %18.4f kHash/sec', [TPerfTestRunner.ScaleCount(i), SHA1Res[i].CPS / 1000]));

    Writeln(HASH_NAMES[TDefaultHash.SHA2_224], ':');
    for i := Low(SHA2_224Res) to High(SHA2_224Res) do
      Writeln(Format('%10d %8.4f kHash/sec', [TPerfTestRunner.ScaleCount(i), SHA2_224Res[i].CPS / 1000]));

    Writeln(HASH_NAMES[TDefaultHash.SHA2_256], ':');
    for i := Low(SHA2_256Res) to High(SHA2_256Res) do
      Writeln(Format('%10d %8.4f kHash/sec', [TPerfTestRunner.ScaleCount(i), SHA2_256Res[i].CPS / 1000]));

    Writeln(HASH_NAMES[TDefaultHash.SHA2_384], ':');
    for i := Low(SHA2_384Res) to High(SHA2_384Res) do
      Writeln(Format('%10d %8.4f kHash/sec', [TPerfTestRunner.ScaleCount(i), SHA2_384Res[i].CPS / 1000]));

    Writeln(HASH_NAMES[TDefaultHash.SHA2_512], ':');
    for i := Low(SHA2_512Res) to High(SHA2_512Res) do
      Writeln(Format('%10d %18.4f kHash/sec', [TPerfTestRunner.ScaleCount(i), SHA2_512Res[i].CPS / 1000]));

    Writeln(HASH_NAMES[TDefaultHash.SHA2_512_224], ':');
    for i := Low(SHA2_512_224Res) to High(SHA2_512_224Res) do
      Writeln(Format('%10d %8.4f kHash/sec', [TPerfTestRunner.ScaleCount(i), SHA2_512_224Res[i].CPS / 1000]));

    Writeln(HASH_NAMES[TDefaultHash.SHA2_512_256], ':');
    for i := Low(SHA2_512_256Res) to High(SHA2_512_256Res) do
      Writeln(Format('%10d %8.4f kHash/sec', [TPerfTestRunner.ScaleCount(i), SHA2_512_256Res[i].CPS / 1000]));

    Writeln(HASH_NAMES[TDefaultHash.BobJenkins], ':');
    for i := Low(BobJenkinsRes) to High(BobJenkinsRes) do
      Writeln(Format('%10d %8.4f kHash/sec', [TPerfTestRunner.ScaleCount(i), BobJenkinsRes[i].CPS / 1000]));
  finally
    FreeAndNil(HashTest);
  end;
end;

end.
