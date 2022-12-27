{
  Original unit (c) 2008 Damjan Zobo Cvetko
  Revisions (c) 2022 Robert Di Pardo <dipardo.r@gmail.com>

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

unit HelloWorldPlugin;

interface

uses
  SysUtils, Windows, NppPlugin, HelloWorldDockingForms;

const
  /// menu index of the dockable form
  DlgMenuId = 2;

type
  THelloWorldPlugin = class(TNppPlugin)
  public
    constructor Create;
    procedure FuncHelloWorld;
    procedure FuncHolaMundo;
    procedure FuncHolaMundoEx;
    procedure FuncHelloWorldDocking;
    procedure FuncAbout;
    procedure DoNppnToolbarModification; override;
  end;

procedure _FuncHelloWorld; cdecl;
procedure _FuncHolaMundo; cdecl;
procedure _FuncHelloWorldDocking; cdecl;
procedure _FuncAbout; cdecl;

/// a global instance of the main plugin object
var
  Npp: THelloWorldPlugin;

implementation

uses
  ModulePath, VersionInfo {$IFDEF FPC}, Forms{$ENDIF};

{ THelloWorldPlugin }

constructor THelloWorldPlugin.Create;
var
  PSk: PShortcutKey;
begin
  inherited;
  self.PluginName := 'Hello &World';

  PSk := MakeShortcutKey(true, false, true, $48); // CTRL + SHIFT + H
  self.AddFuncItem('&Insert "Hello, World!"', _FuncHelloWorld, PSk);

  PSk := MakeShortcutKey(false, true, true, $48); // ALT + SHIFT + H
  self.AddFuncItem('&Replace "Hello, World!"', _FuncHolaMundo, PSk);

  self.AddFuncItem('Load Docking &Form', _FuncHelloWorldDocking);
  self.AddFuncItem('-', nil); // create a separator
  self.AddFuncItem('&About', _FuncAbout);
end;

procedure _FuncHelloWorld; cdecl;
begin
  Npp.FuncHelloWorld;
end;

procedure _FuncHolaMundo; cdecl;
const
  Msg = 'This function requires %s!'#13#10'It has been disabled to prevent a crash.';
begin
{$IFDEF CPUx64}
{$IFNDEF NPP_NO_HUGE_FILES}
  if not Npp.SupportsBigFiles then
  begin
    MessageBoxW(Npp.NppData.NppHandle, PWChar(WideFormat(Msg,['Notepad++ 8.3 or newer'])),
      PWChar('Unsupported N++ Version'), MB_ICONWARNING);
    Exit;
  end;
{$ELSE}
  if Npp.SupportsBigFiles then
  begin
    MessageBoxW(Npp.NppData.NppHandle, PWChar(WideFormat(Msg,['Notepad++ 8.2.1 or older'])),
      PWChar('Unsupported N++ Version'), MB_ICONWARNING);
    Exit;
  end;
{$ENDIF}
{$ENDIF}
  if Npp.HasFullRangeApis then
    Npp.FuncHolaMundoEx
  else
    Npp.FuncHolaMundo;
end;

procedure _FuncAbout; cdecl;
begin
  Npp.FuncAbout;
end;

procedure _FuncHelloWorldDocking; cdecl;
begin
  Npp.FuncHelloWorldDocking;
end;

procedure THelloWorldPlugin.FuncHelloWorld;
begin
  SendMessageW(self.NppData.ScintillaMainHandle, SCI_REPLACESEL, 0, LPARAM(PAnsiChar('Hello, World!'#13#10)));

  if SendMessageW(self.NppData.ScintillaMainHandle, SCI_GETCODEPAGE, 0, 0) = SC_CP_UTF8
  then
    SendMessageW(self.NppData.ScintillaMainHandle, SCI_REPLACESEL, 0, LPARAM(PAnsiChar('こにちは、皆さん‼'#13#10)));
end;

procedure THelloWorldPlugin.FuncHolaMundo;
const
  OldTxt = 'Hello, World!';
  NewTxt = '¡Hola, mundo!';
var
  HelloTxt: TSciTextToFind;
  StartPos: Sci_Position;
begin
  HelloTxt := Default (TSciTextToFind);
  HelloTxt.chrg.cpMin := 0;
  HelloTxt.chrg.cpMax := SendMessageW(NppData.ScintillaMainHandle, SCI_GETLENGTH, 0, 0);
  HelloTxt.chrgText := HelloTxt.chrg;
  HelloTxt.lpstrText := PAnsiChar(OldTxt);
  StartPos := SendMessageW(NppData.ScintillaMainHandle, SCI_FINDTEXT, 0, LPARAM(@HelloTxt));
  if StartPos <> INVALID_POSITION then
  begin
    SendMessageW(NppData.ScintillaMainHandle, SCI_SETTARGETSTART, StartPos, 0);
    SendMessageW(NppData.ScintillaMainHandle, SCI_SETTARGETEND,
      StartPos + Length(OldTxt), 0);
    SendMessageW(NppData.ScintillaMainHandle, SCI_REPLACETARGET,
      Length(NewTxt), LPARAM(PAnsiChar(NewTxt)));
    SendMessageW(NppData.ScintillaMainHandle, SCI_SETSELECTIONSTART, StartPos, 0);
    SendMessageW(NppData.ScintillaMainHandle, SCI_SETSELECTIONEND, Length(NewTxt), 0);
  end;
end;

procedure THelloWorldPlugin.FuncHolaMundoEx;
const
  OldTxt = 'Hello, World!';
  NewTxt = '¡Hola, mundo!';
var
  HelloTxt: TSciTextToFindFull;
  StartPos: Sci_Position;
begin
  HelloTxt := Default (TSciTextToFindFull);
  HelloTxt.chrg.cpMin := 0;
  HelloTxt.chrg.cpMax := SendMessage(NppData.ScintillaMainHandle,
    SCI_GETLENGTH, 0, 0);
  HelloTxt.chrgText := HelloTxt.chrg;
  HelloTxt.lpstrText := PAnsiChar(OldTxt);
  StartPos := SendMessage(NppData.ScintillaMainHandle, SCI_FINDTEXTFULL, 0,
    LPARAM(@HelloTxt));
  if StartPos <> INVALID_POSITION then
  begin
    SendMessage(NppData.ScintillaMainHandle, SCI_SETTARGETSTART, StartPos, 0);
    SendMessage(NppData.ScintillaMainHandle, SCI_SETTARGETEND,
      StartPos + Length(OldTxt), 0);
    SendMessage(NppData.ScintillaMainHandle, SCI_REPLACETARGET,
      Length(NewTxt), LPARAM(PAnsiChar(NewTxt)));
    SendMessage(NppData.ScintillaMainHandle, SCI_SETSELECTIONSTART,
      StartPos, 0);
    SendMessage(NppData.ScintillaMainHandle, SCI_SETSELECTIONEND,
      Length(NewTxt), 0);
  end;
end;

procedure THelloWorldPlugin.FuncAbout;
const
  Msg = '%s'#13#10#13#10'%s'#13#10'%s'#13#10'License: %s';
var
  Info: TFileVersionInfo;
begin
  try
    try
      Info := TFileVersionInfo.Create(TModulePath.DLLFullName);
      MessageBoxW(Npp.NppData.NppHandle,
                  PWChar(WideFormat(Msg,
                    [Info.FileDescription,
                     Info.LegalCopyright,
                     Info.Comments,
                     Info.LegalTrademarks])),
                  PWChar(Info.ProductName),
                  MB_ICONINFORMATION);
    finally
      FreeAndNil(Info);
    end;
  except
  on E: Exception do
  {$IFDEF FPC}
    MessageBox(Npp.NppData.NppHandle, PChar(E.Message), PChar(E.Message), MB_ICONERROR);
  {$ELSE}
    MessageBoxW(Npp.NppData.NppHandle, PWChar(E.Message), PWChar(E.Message), MB_ICONERROR);
  {$ENDIF}
  end;
end;

procedure THelloWorldPlugin.FuncHelloWorldDocking;
begin
  if (not Assigned(HelloWorldDockingForm)) then
{$IFDEF FPC}
    Application.CreateForm(THelloWorldDockingForm, HelloWorldDockingForm);
    if (not Assigned(HelloWorldDockingForm.Npp)) then
      HelloWorldDockingForm.Show(self, DlgMenuId)
    else
      HelloWorldDockingForm.Show;
{$ELSE}
    HelloWorldDockingForm := THelloWorldDockingForm.Create(self, DlgMenuId);
    HelloWorldDockingForm.Show;
{$ENDIF}
end;

procedure THelloWorldPlugin.DoNppnToolbarModification;
var
  tb: TToolbarIcons;
  tbDark: TTbIconsDarkMode;
  HTbBmp: HBITMAP;
  HTIcon: HICON;
begin
  tb := Default (TToolbarIcons);
  tbDark := Default (TTbIconsDarkMode);
  HTbBmp := LoadImage(Hinstance, 'TB_BMP', IMAGE_BITMAP, 0, 0,
    (LR_DEFAULTSIZE or LR_LOADMAP3DCOLORS));
  HTIcon := LoadImage(Hinstance, 'TB_ICON', IMAGE_ICON, 0, 0,
    (LR_DEFAULTSIZE or LR_LOADMAP3DCOLORS));
  tb.ToolbarBmp := HTbBmp;
  tb.ToolbarIcon := HTIcon;
  tbDark.ToolbarBmp := HTbBmp;
  tbDark.ToolbarIcon := HTIcon;

  if self.SupportsDarkMode then
  begin
    tbDark.ToolbarIconDarkMode := LoadImage(Hinstance, 'TB_DM_ICON', IMAGE_ICON,
      0, 0, (LR_DEFAULTSIZE or LR_LOADMAP3DCOLORS));
    SendMessage(NppData.NppHandle, NPPM_ADDTOOLBARICON_FORDARKMODE,
      WPARAM(CmdIdFromDlgId(DlgMenuId)), LPARAM(@tbDark));
  end
  else
    SendMessage(NppData.NppHandle, NPPM_ADDTOOLBARICON_DEPRECATED,
      WPARAM(CmdIdFromDlgId(DlgMenuId)), LPARAM(@tb));
end;

end.
