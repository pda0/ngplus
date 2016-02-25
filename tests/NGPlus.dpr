{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program NGPlus;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  test.system.helpers.tguidhelper in 'src\test.system.helpers.tguidhelper.pas',
  test.system.helpers.unicodestringhelper in 'src\test.system.helpers.unicodestringhelper.pas',
  test.system.hash.thash in 'src\test.system.hash.thash.pas',
  test.system.hash.thashmd5 in 'src\test.system.hash.thashmd5.pas',
  test.system.hash.thashsha1 in 'src\test.system.hash.thashsha1.pas',
  test.system.hash.thashsha2_224 in 'src\test.system.hash.thashsha2_224.pas',
  test.system.hash.thashsha2_256 in 'src\test.system.hash.thashsha2_256.pas',
  test.system.hash.thashsha2_384 in 'src\test.system.hash.thashsha2_384.pas',
  test.system.hash.thashsha2_512 in 'src\test.system.hash.thashsha2_512.pas',
  test.system.hash.thashsha2_512_224 in 'src\test.system.hash.thashsha2_512_224.pas',
  test.system.hash.thashsha2_512_256 in 'src\test.system.hash.thashsha2_512_256.pas',
  test.system.hash.thashbobjenkins in 'src\test.system.hash.thashbobjenkins.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

