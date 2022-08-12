{
  Copyright Martijn Coppoolse <https://sourceforge.net/u/vor0nwe>
  Revisions (c) 2022 Robert Di Pardo <dipardo.r@gmail.com>

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this file,
  You can obtain one at https://mozilla.org/MPL/2.0/.
}

unit VersionInfo;

{$IFDEF FPC}
{$codePage UTF8}
{$mode delphiunicode}
{$ENDIF}

interface

uses
  Windows, SysUtils;

type
  TFileVersionInfo = class
  private
    { Private declarations }
    FFilename         : string;
    FHasVersionInfo   : boolean;

    FCompanyName      : string;
    FFileDescription  : string;
    FFileVersion      : string;
    FInternalname     : string;
    FLegalCopyright   : string;
    FLegalTradeMarks  : string;
    FOriginalFilename : string;
    FProductName      : string;
    FProductVersion   : string;
    FComments         : string;
    FMajorVersion     : Word;
    FMinorVersion     : Word;
    FRevision         : Word;
    FBuild            : Word;
    FFlags            : Word;
    FFileDateTime     : TDateTime;

    procedure SetFileName(const AFileName: string);
    function  HasFlag(const Index: integer): boolean;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(const AFileName: string);
    destructor  Destroy; override;

    property FileName         : string    read FFileName           write SetFileName;
  public
    { Published declarations }
    property CompanyName      : string    read FCompanyName;
    property FileDescription  : string    read FFileDescription;
    property FileVersion      : string    read FFileVersion;
    property Internalname     : string    read FInternalname;
    property LegalCopyright   : string    read FLegalCopyright;
    property LegalTradeMarks  : string    read FLegalTradeMarks;
    property OriginalFilename : string    read FOriginalFilename;
    property ProductName      : string    read FProductName;
    property ProductVersion   : string    read FProductVersion;
    property Comments         : string    read FComments;
    property MajorVersion     : Word      read FMajorVersion;
    property MinorVersion     : Word      read FMinorVersion;
    property Revision         : Word      read FRevision;
    property Build            : Word      read FBuild;
    property Flags            : Word      read FFlags;
    property IsDebug          : boolean   index VS_FF_DEBUG         read HasFlag;
    property IsPreRelease     : boolean   index VS_FF_PRERELEASE    read HasFlag;
    property IsPatched        : boolean   index VS_FF_PATCHED       read HasFlag;
    property IsPrivateBuild   : boolean   index VS_FF_PRIVATEBUILD  read HasFlag;
    property IsInfoInferred   : boolean   index VS_FF_INFOINFERRED  read HasFlag;
    property IsSpecialBuild   : boolean   index VS_FF_SPECIALBUILD  read HasFlag;
    property FileDateTime     : TDateTime read FFileDateTime;
  end;

implementation

type
  TLangAndCP = record
    wLanguage : word;
    wCodePage : word;
  end;
  PLangAndCP = ^TLangAndCP;

constructor TFileVersionInfo.Create(const AFileName: string);
begin
  inherited Create;
  SetFileName(AFileName);
end;

destructor TFileVersionInfo.Destroy;
begin
  inherited Destroy;
end;

procedure TFileVersionInfo.SetFileName(const AFileName: string);
var
  Dummy     : UINT;
  BufferSize: DWORD;
  Buffer    : Pointer;
  PLang     : PLangAndCP;
  SubBlock  : string;
  SysTime: TSystemTime;
  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
  function QueryValue(const AName: string): string;
  var
    Value   : PChar;
    ValueStr: array[0..$7fff] of char;
  begin
    Value := @ValueStr;
    SubBlock := WideFormat('\\StringFileInfo\\%.4x%.4x\\%s', [PLang.wLanguage, PLang.wCodePage, AName]);
    VerQueryValueW(Buffer, PChar(SubBlock), Pointer(Value), Dummy);
    Result := string(Value);
  end;
  { - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
var
  PInfoBlock : PVSFixedFileInfo;
  FileTime   : TFileTime;
begin
  FFilename := AFileName;
{$IFDEF FPC}
  PLang := @(Default(TLangAndCP));
  PInfoBlock := @(Default(VS_FIXEDFILEINFO));
{$ENDIF}
  SysTime := Default(TSystemTime);
  BufferSize := GetFileVersionInfoSizeW(PChar(AFileName), Dummy);
  FHasVersionInfo := (Buffersize > 0);
  if FHasVersionInfo then begin
    Buffer := AllocMem(BufferSize);
    try
      GetFileVersionInfoW(PChar(AFileName), Dummy, BufferSize, Buffer);

      SubBlock := '\\VarFileInfo\\Translation';
      VerQueryValueW(Buffer, PChar(SubBlock), Pointer(PLang), Dummy);

      FCompanyName      := QueryValue('CompanyName');
      FFileDescription  := QueryValue('FileDescription');
      FFileVersion      := QueryValue('FileVersion');
      FInternalName     := QueryValue('InternalName');
      FLegalCopyright   := QueryValue('LegalCopyright');
      FLegalTradeMarks  := QueryValue('LegalTradeMarks');
      FOriginalFilename := QueryValue('OriginalFilename');
      FProductName      := QueryValue('ProductName');
      FProductVersion   := QueryValue('ProductVersion');
      FComments         := QueryValue('Comments');

      VerQueryValueW(Buffer, '\', Pointer(PInfoBlock), Dummy);
      FMajorVersion := PInfoBlock.dwFileVersionMS shr 16;
      FMinorVersion := PInfoBlock.dwFileVersionMS and 65535;
      FRevision     := PInfoBlock.dwFileVersionLS shr 16;
      FBuild        := PInfoBlock.dwFileVersionLS and 65535;
      FFlags        := PInfoBlock.dwFileFlags and PInfoBlock.dwFileFlagsMask;

      FileTime.dwLowDateTime  := PInfoBlock.dwFileDateLS;
      FileTime.dwHighDateTime := PInfoBlock.dwFileDateMS;
      if FileTimeToLocalFileTime(FileTime, FileTime) and FileTimeToSystemTime(FileTime, SysTime) and (SysTime.wYear > 1601) then
        FFileDateTime := SystemTimeToDateTime(SysTime);
    finally
      FreeMem(Buffer, BufferSize);
    end;
  end else begin
    FCompanyname      := '';
    FFileDescription  := '';
    FFileVersion      := '';
    FInternalname     := '';
    FLegalCopyright   := '';
    FLegalTradeMarks  := '';
    FOriginalFilename := '';
    FProductName      := '';
    FProductVersion   := '';
    FComments         := '';
    FMajorVersion     := 0;
    FMinorVersion     := 0;
    FRevision         := 0;
    FBuild            := 0;
  end;
end;

function TFileVersionInfo.HasFlag(const Index: integer): boolean;
begin
  Result := (FFlags and Index) <> 0;
end;

end.
