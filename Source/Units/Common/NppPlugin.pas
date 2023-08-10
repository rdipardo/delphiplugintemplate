{
  This file is part of DBGP Plugin for Notepad++
  Copyright (C) 2007  Damjan Zobo Cvetko

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along
  with this program; if not, write to the Free Software Foundation, Inc.,
  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
}

unit nppplugin;

{$IFDEF FPC}
{$mode delphiunicode}
{$ENDIF}

interface

uses
  Classes, SysUtils, Windows, Messages,
{$IFNDEF FPC}
  Vcl.Forms
{$ELSE}
  LCLIntf, LCLType, LMessages, Forms
{$ENDIF};

{$I '..\..\Include\Scintilla.inc'}
{$I '..\..\Include\Npp.inc'}
{$I '..\..\Include\DarkMode.inc'}

  TNppPlugin = class(TObject)
  private
    FuncArray: array of _TFuncItem;
    FClosingBufferID: THandle;
    function GetCurrentScintilla: HWND;
  protected
    PluginName: nppString;
    function SupportsDarkMode: Boolean; // needs N++ 8.0 or later
    function SupportsBigFiles: Boolean; // needs N++ 8.3 or later
    function HasV5Apis: Boolean; // needs N++ 8.4 or later
    function HasFullRangeApis: Boolean; // needs N++ 8.4.3 or later
    function GetNppVersion: Cardinal;
    function GetPluginsConfigDir: string;
    function AddFuncItem(Name: nppString; Func: PFUNCPLUGINCMD): Integer; overload;
    function AddFuncItem(Name: nppString; Func: PFUNCPLUGINCMD;
      ShortcutKey: PShortcutKey): Integer; overload;
    function MakeShortcutKey(const Ctrl, Alt, Shift: Boolean; const AKey: UCHAR)
      : PShortcutKey;
    // wrappers for common API calls
    function SendNppMessage(Msg: Cardinal; _WParam: NativeUInt = 0; _LParam: NativeInt = 0): LRESULT; overload;
    function SendNppMessage(Msg: Cardinal; _WParam: NativeUInt; APParam: Pointer = nil): LRESULT; overload;
  public
    NppData: TNppData;
    constructor Create;
    destructor Destroy; override;
    procedure BeforeDestruction; override;
    function CmdIdFromDlgId(DlgId: Integer): Integer;

    // needed for DLL export.. wrappers are in the main dll file.
    function GetName: nppPChar;
    function GetFuncsArray(var FuncsCount: Integer): Pointer;
    procedure BeNotified(sn: PSciNotification); virtual;
    procedure MessageProc(var Msg: TMessage); virtual;
    procedure SetInfo(NppData: TNppData); virtual;

    // hooks
    procedure DoNppnToolbarModification; virtual;
    procedure DoNppnShutdown; virtual;
    procedure DoNppnBufferActivated(const BufferID: THandle); virtual;
    procedure DoNppnFileClosed(const BufferID: THandle); virtual;
    procedure DoUpdateUI(const hwnd: HWND; const updated: Integer); virtual;
    procedure DoModified(const hwnd: HWND; const modificationType: Integer); virtual;

    // df
    function DoOpen(filename: String): Boolean; overload;
    function DoOpen(filename: String; Line: Sci_Position): Boolean; overload;
    procedure GetFileLine(var filename: String; var Line: Sci_Position);
    function GetWord: string;

    // needs N++ 8.4.1 or later
    function IsDarkModeEnabled: Boolean;
    procedure GetDarkModeColors(PColors: PDarkModeColors);

    property CurrentScintilla: HWND read GetCurrentScintilla;
  end;

implementation

{ TNppPlugin }

{ This is hacking for trouble...
  We need to unset the Application handler so that the forms
  don't get berserk and start throwing OS error 1004.
  This happens because the main NPP HWND is already lost when the
  DLL_PROCESS_DETACH gets called, and the form tries to allocate a new
  handler for sending the "close" windows message...
}
procedure TNppPlugin.BeforeDestruction;
begin
{$IFNDEF FPC}
  Application.Handle := 0;
  Application.Terminate;
{$ENDIF}
  inherited;
end;

constructor TNppPlugin.Create;
begin
  inherited;
end;

destructor TNppPlugin.Destroy;
var
  i: Integer;
begin
  for i := 0 to Length(self.FuncArray) - 1 do
  begin
    if (self.FuncArray[i].ShortcutKey <> nil) then
    begin
      Dispose(self.FuncArray[i].ShortcutKey);
    end;
  end;
  inherited;
end;

function TNppPlugin.AddFuncItem(Name: nppString; Func: PFUNCPLUGINCMD): Integer;
var
  i: Integer;
begin
  i := Length(self.FuncArray);
  SetLength(self.FuncArray, i + 1);
  StrPLCopy(self.FuncArray[i].ItemName, Name, 1000);
  self.FuncArray[i].Func := Func;
  self.FuncArray[i].ShortcutKey := nil;
  Result := i;
end;

function TNppPlugin.AddFuncItem(Name: nppString; Func: PFUNCPLUGINCMD;
  ShortcutKey: PShortcutKey): Integer;
var
  i: Integer;
begin
  i := self.AddFuncItem(Name, Func);
  self.FuncArray[i].ShortcutKey := ShortcutKey;
  Result := i;
end;

function TNppPlugin.MakeShortcutKey(const Ctrl, Alt, Shift: Boolean;
  const AKey: UCHAR): PShortcutKey;
begin
  Result := New(PShortcutKey);
  with Result^ do
  begin
    IsCtrl := Ctrl;
    IsAlt := Alt;
    IsShift := Shift;
    Key := AKey;
  end;
end;

procedure TNppPlugin.GetFileLine(var filename: String; var Line: Sci_Position);
var
  s: array [0..1001] of char;
  r: Sci_Position;
  editor: HWND;
begin
  editor := CurrentScintilla;
  SendNppMessage(NPPM_GETFULLCURRENTPATH, 0, @s[0]);
  filename := string(s);

  r := SendMessage(editor, SCI_GETCURRENTPOS, 0, 0);
  Line := SendMessage(editor, SCI_LINEFROMPOSITION, r, 0);
end;

function TNppPlugin.GetFuncsArray(var FuncsCount: Integer): Pointer;
begin
  FuncsCount := Length(self.FuncArray);
  Result := self.FuncArray;
end;

function TNppPlugin.GetName: nppPChar;
begin
  Result := nppPChar(self.PluginName);
end;

function TNppPlugin.GetPluginsConfigDir: string;
var
  s: array [0..1001] of char;
begin
  SendNppMessage(NPPM_GETPLUGINSCONFIGDIR, 1000, @s[0]);
  Result := string(s);
end;

procedure TNppPlugin.BeNotified(sn: PSciNotification);
begin
  try
    if HWND(sn^.nmhdr.hwndFrom) = self.NppData.NppHandle then begin
      case sn.nmhdr.code of
        NPPN_TBMODIFICATION: begin
          self.DoNppnToolbarModification;
        end;
        NPPN_SHUTDOWN: begin
          self.DoNppnShutdown;
        end;
        NPPN_BUFFERACTIVATED: begin
          self.DoNppnBufferActivated(sn.nmhdr.idFrom);
        end;
        NPPN_FILEBEFORECLOSE: begin
          FClosingBufferID := SendMessageW(HWND(sn.nmhdr.hwndFrom), NPPM_GETCURRENTBUFFERID, 0, 0);
        end;
        NPPN_FILECLOSED: begin
          self.DoNppnFileClosed(FClosingBufferID);
        end;
      end;
    end else begin
      case sn.nmhdr.code of
        SCN_MODIFIED: begin
          Self.DoModified(HWND(sn.nmhdr.hwndFrom), sn.modificationType);
        end;
        SCN_UPDATEUI: begin
          self.DoUpdateUI(HWND(sn.nmhdr.hwndFrom), sn.updated);
        end;
      end;
    end;
   except
     on E: Exception do begin
       OutputDebugString({$ifdef FPC}PAnsiChar{$else}PChar{$endif}(Format('%s> %s: "%s"', [{$ifdef FPC}UTF8Encode{$endif}(PluginName), E.ClassName, E.Message])));
     end;
   end;
end;

{$REGION 'Virtual procedures'}

procedure TNppPlugin.MessageProc(var Msg: TMessage);
var
  hm: HMENU;
  i: Integer;
begin
  if (Msg.Msg = WM_CREATE) then
  begin
    // Change - to separator items
    hm := GetMenu(self.NppData.NppHandle);
    for i := 0 to Length(self.FuncArray) - 1 do
      if (self.FuncArray[i].ItemName[0] = '-') then
        ModifyMenu(hm, self.FuncArray[i].CmdID, MF_BYCOMMAND or
          MF_SEPARATOR, 0, nil);
  end;
  Dispatch(Msg);
end;

procedure TNppPlugin.SetInfo(NppData: TNppData);
begin
  self.NppData := NppData;
{$IFNDEF FPC}
  Application.Handle := NppData.NppHandle;
{$ENDIF}
end;

procedure TNppPlugin.DoNppnShutdown;
begin
  // override
end;

procedure TNppPlugin.DoNppnToolbarModification;
begin
  // override
end;

procedure TNppPlugin.DoNppnBufferActivated(const BufferID: THandle);
begin
  // override
end;

procedure TNppPlugin.DoNppnFileClosed(const BufferID: THandle);
begin
  // override
end;

procedure TNppPlugin.DoModified(const hwnd: HWND; const modificationType: Integer);
begin
  // override
end;

procedure TNppPlugin.DoUpdateUI(const hwnd: HWND; const updated: Integer);
begin
  // override
end;
{$ENDREGION}

// utils
function TNppPlugin.GetWord: string;
var
  s: string;
begin
  s := '';
  SetLength(s, 800);
  SendNppMessage(NPPM_GETCURRENTWORD, 0, PChar(s));
  Result := s;
end;

function TNppPlugin.DoOpen(filename: String): Boolean;
var
  r: Integer;
  s: array [0..1001] of char;
begin
  // ask if we are not already opened
  SendNppMessage(NPPM_GETFULLCURRENTPATH, 0, @s[0]);
  Result := true;
  if {$ifdef FPC}WideSameText{$else}SameText{$endif}(string(s), filename) then
    exit;
  r := SendNppMessage(WM_DOOPEN, 0, PChar(filename));
  Result := (r = 0);
end;

function TNppPlugin.DoOpen(filename: String; Line: Sci_Position): Boolean;
var
  r: Boolean;
begin
  r := self.DoOpen(filename);
  if (r) then
    SendMessage(CurrentScintilla, SCI_GOTOLINE, Line, 0);
  Result := r;
end;

function TNppPlugin.CmdIdFromDlgId(DlgId: Integer): Integer;
begin
  Result := self.FuncArray[DlgId].CmdID;
end;

function TNppPlugin.GetNppVersion: Cardinal;
var
  NppVersion: Cardinal;
begin
  NppVersion := SendNppMessage(NPPM_GETNPPVERSION);
  // retrieve the zero-padded version, if available
  // https://github.com/notepad-plus-plus/notepad-plus-plus/commit/ef609c896f209ecffd8130c3e3327ca8a8157e72
  if ((HIWORD(NppVersion) > 8) or
      ((HIWORD(NppVersion) = 8) and
        (((LOWORD(NppVersion) >= 41) and (not (LOWORD(NppVersion) in [191, 192, 193]))) or
          (LOWORD(NppVersion) in [5, 6, 7, 8, 9])))) then
    NppVersion := SendNppMessage(NPPM_GETNPPVERSION, 1, 0);

  Result := NppVersion;
end;

function TNppPlugin.SendNppMessage(Msg: Cardinal; _WParam: NativeUInt; _LParam: NativeInt): LRESULT;
begin
  Result := SendMessage(self.NppData.NppHandle, Msg, WPARAM(_WParam), LPARAM(_LParam));
end;

function TNppPlugin.SendNppMessage(Msg: Cardinal; _WParam: NativeUInt; APParam: Pointer): LRESULT;
begin
  Result := SendNppMessage(Msg, _WParam, NativeInt(APParam));
end;

function TNppPlugin.GetCurrentScintilla: HWND;
var
  Idx: Integer;
begin
  Result := Self.NppData.ScintillaMainHandle;
  SendNppMessage(NPPM_GETCURRENTSCINTILLA, 0, @Idx);
  if Idx <> 0 then
    Result := Self.NppData.ScintillaSecondHandle;
end;

/// since 8.0
/// A return value of `true` means the NPPM_ADDTOOLBARICON_FORDARKMODE message is defined
/// https://community.notepad-plus-plus.org/topic/21652/add-new-api-nppm_addtoolbaricon_fordarkmode-for-dark-mode
function TNppPlugin.SupportsDarkMode: Boolean;
begin
  Result := HIWORD(GetNppVersion) >= 8;
end;

/// since 8.4.1
/// Returns `true` if the dark mode setting can be detected by sending the NPPM_ISDARKMODEENABLED message
/// https://github.com/notepad-plus-plus/notepad-plus-plus/commit/1eb5b10e41d7ab92b60aa32b28d4fe7739d15b53
function TNppPlugin.IsDarkModeEnabled: Boolean;
var
  NppVersion: Cardinal;
  HasQueryApi: Boolean;
begin
  NppVersion := GetNppVersion;
  HasQueryApi :=
    ((HIWORD(NppVersion) > 8) or
     ((HIWORD(NppVersion) = 8) and
        (((LOWORD(NppVersion) >= 41) and (not (LOWORD(NppVersion) in [191, 192, 193]))))));
  Result := (HasQueryApi and Boolean(SendNppMessage(NPPM_ISDARKMODEENABLED)));
end;

/// since 8.4.1
/// Initializes a TDarkModeColors instance with the editor's active dark mode styles
/// https://github.com/notepad-plus-plus/notepad-plus-plus/commit/1eb5b10e41d7ab92b60aa32b28d4fe7739d15b53
procedure TNppPlugin.GetDarkModeColors(PColors: PDarkModeColors);
begin
  if IsDarkModeEnabled then
    SendNppMessage(NPPM_GETDARKMODECOLORS, SizeOf(TDarkModeColors), PColors);
end;

/// since 8.3
/// *** MAJOR BREAKING CHANGE ***
/// A return value of `true` means that x64 editors return 64-bit character and line positions,
/// i.e., sizeof(Sci_Position) == sizeof(NativeInt), and sizeof(Sci_PositionU) == sizeof(SIZE_T)
/// https://community.notepad-plus-plus.org/topic/22471/recompile-your-x64-plugins-with-new-header
function TNppPlugin.SupportsBigFiles: Boolean;
var
  NppVersion: Cardinal;
begin
  NppVersion := GetNppVersion;
  Result :=
    (HIWORD(NppVersion) > 8) or
    ((HIWORD(NppVersion) = 8) and
      // 8.3 => 8,3 *not* 8,30
      ((LOWORD(NppVersion) in [3, 4]) or
       // Also check for N++ versions 8.1.9.1, 8.1.9.2 and 8.1.9.3
       ((LOWORD(NppVersion) > 21) and (not (LOWORD(NppVersion) in [191, 192, 193])))));
end;

/// since 8.4
/// A return value of `true` means the Scintilla API level is at least 5.2.1
/// https://github.com/notepad-plus-plus/notepad-plus-plus/commit/a61b03ea8887e21c6e1b7374068962f635b79b80
///
/// See https://www.scintilla.org/ScintillaHistory.html § 5.1.5
/// > When calling SCI_GETTEXT, SCI_GETSELTEXT, and SCI_GETCURLINE with a NULL
/// > buffer argument to discover the length that should be allocated, do not
/// > include the terminating NUL in the returned value. The value returned is 1
/// > less than previous versions of Scintilla. Applications should allocate a
/// > buffer 1 more than this to accommodate the NUL. The wParam (length)
/// > argument to SCI_GETTEXT and SCI_GETCURLINE also omits the NUL
function TNppPlugin.HasV5Apis: Boolean;
var
  NppVersion: Cardinal;
begin
  NppVersion := GetNppVersion;
  Result :=
    (HIWORD(NppVersion) > 8) or
    ((HIWORD(NppVersion) = 8) and
        ((LOWORD(NppVersion) >= 4) and
           (not (LOWORD(NppVersion) in [11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 31, 32, 33, 191, 192, 193]))));
end;

/// since 8.4.3
/// A return value of `true` means the 64-bit APIs added in Scintilla 5.2.3 are available
/// https://groups.google.com/g/scintilla-interest/c/mPLwYdC0-FE
/// https://github.com/notepad-plus-plus/notepad-plus-plus/commit/ed4bb1a93e763001aac842698fcde0856ba8b0bc
function TNppPlugin.HasFullRangeApis: Boolean;
var
  NppVersion: Cardinal;
begin
  NppVersion := GetNppVersion;
  Result :=
    (HIWORD(NppVersion) > 8) or
    ((HIWORD(NppVersion) = 8) and (LOWORD(NppVersion) >= 430));
end;

end.
