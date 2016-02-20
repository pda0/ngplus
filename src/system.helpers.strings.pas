{**********************************************************************
    Copyright(c) 2016 pda <pda2@yandex.ru>

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit System.Helpers.Strings;

{$I ngplus.inc}

interface

resourcestring
  { System.Helpers }
  SInvalidGuidArray = 'Byte array for GUID must be exactly %d bytes long';

  { System.Hash }
  SHashCanNotUpdateMD5 = 'MD5: Cannot update a finalized hash';
  SHashCanNotUpdateSHA1 = 'SHA1: Cannot update a finalized hash';
  SHashCanNotUpdateSHA2 = 'SHA2: Cannot update a finalized hash';

  { System.Hash.Helpers }
  SNTError = 'NT error, (Code %d):' + LineEnding + '%s';

implementation

end.

