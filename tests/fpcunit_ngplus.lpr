{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program fpcunit_ngplus;

{$I fpc.inc}

uses
  {$IFDEF UNIX}
  cwstring,
  {$ENDIF UNIX}
  {$IFDEF CONSOLE_TESTRUNNER}
  Classes,
  ConsoleTestRunner,
  {$ELSE}
  Interfaces,
  Forms,
  GuiTestRunner,
  {$ENDIF CONSOLE_TESTRUNNER}
  {$IFNDEF _WITHOUT_OPENSSL}
  openssl,
  {$ENDIF}
  System.Helpers in '../src/system.helpers.pas',
  System.Helpers.Strings in '../src/system.helpers.strings.pas',
  //System.Hash.Helpers in '../src/system.hash.helpers.pas',
  //System.Hash in '../src/system.hash.pas',
  //Test.System.Helpers.TGuidHelper in '../src/test.system.helpers.tguidhelper.pas',
  //Test.System.Hash.THash in 'src/test.system.hash.thash.pas',
  //Test.System.Hash.THashMD5 in 'src/test.system.hash.thashmd5.pas',
  //Test.System.Hash.THashSHA1 in 'src/test.system.hash.thashsha1.pas',
  //Test.System.Hash.THashSHA2_224 in 'src/test.system.hash.thashsha2_224.pas',
  //Test.System.Hash.THashSHA2_256 in 'src/test.system.hash.thashsha2_256.pas',
  //Test.System.Hash.THashSHA2_384 in 'src/test.system.hash.thashsha2_384.pas',
  //Test.System.Hash.THashSHA2_512 in 'src/test.system.hash.thashsha2_512.pas',
  //Test.System.Hash.THashSHA2_512_224 in 'src/test.system.hash.thashsha2_512_224.pas',
  //Test.System.Hash.THashSHA2_512_256 in 'src/test.system.hash.thashsha2_512_256.pas',
  //Test.System.Hash.THashBobJenkins in 'src/test.system.hash.thashbobjenkins.pas',
  Test.System.Helpers.ShortStringHelper, Test.System.Helpers.AnsiStringHelper,
  Test.System.Helpers.RawByteStringHelper, Test.System.Helpers.UTF8StringHelper,
  Test.System.Helpers.WideStringHelper, Test.System.Helpers.UnicodeStringHelper;

{$IFDEF CONSOLE_TESTRUNNER}
var
  Application: TTestRunner;
{$ENDIF}

begin
  { Enable for test case }
  //DefaultSystemCodePage := CP_UTF8;
  DefaultSystemCodePage := 1251;

  {$IFNDEF _WITHOUT_OPENSSL}
  InitSSLInterface;
  {$ENDIF}
  {$IFDEF CONSOLE_TESTRUNNER}
  Application := TTestRunner.Create(nil);
  {$ENDIF}
  Application.Initialize;
  Application.Title:='FPCUnit NGPlus Test';
  Application.Run;
  {$IFDEF CONSOLE_TESTRUNNER}
  Application.Free;
  {$ENDIF}
end.
