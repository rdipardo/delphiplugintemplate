unit HelloWorldPlugin;

interface

uses
  SysUtils, Windows, NppPlugin, AboutForms, HelloWorldDockingForms;

const
  /// menu index of the dockable form
  DlgMenuId = 2;

type
  THelloWorldPlugin = class(TNppPlugin)
  public
    constructor Create;
    procedure FuncHelloWorld;
    procedure FuncHolaMundo;
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
    MessageBox(Npp.NppData.NppHandle, PChar(Format(Msg,['Notepad++ 8.3 or newer'])),
      PChar('Unsupported N++ Version'), MB_ICONWARNING);
    Exit;
  end;
{$ELSE}
  if Npp.SupportsBigFiles then
  begin
    MessageBox(Npp.NppData.NppHandle, PChar(Format(Msg,['Notepad++ 8.2.1 or older'])),
      PChar('Unsupported N++ Version'), MB_ICONWARNING);
    Exit;
  end;
{$ENDIF}
{$ENDIF}
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
  SendMessage(self.NppData.ScintillaMainHandle, SCI_REPLACESEL, 0,
    LPARAM(PAnsiChar('Hello, World!'#13#10)));

  if SendMessage(self.NppData.ScintillaMainHandle, SCI_GETCODEPAGE, 0, 0) = SC_CP_UTF8
  then
    SendMessage(self.NppData.ScintillaMainHandle, SCI_REPLACESEL, 0,
      LPARAM(UTF8Encode('こにちは、皆さん‼'#13#10)));
end;

procedure THelloWorldPlugin.FuncHolaMundo;
const
  OldTxt = 'Hello, World!';
  NewTxt = 'Hola, mundo!';
var
  HelloTxt: TSciTextToFind;
  StartPos: Sci_Position;
begin
  HelloTxt := Default (TSciTextToFind);
  HelloTxt.chrg.cpMin := 0;
  HelloTxt.chrg.cpMax := SendMessage(NppData.ScintillaMainHandle,
    SCI_GETLENGTH, 0, 0);
  HelloTxt.chrgText := HelloTxt.chrg;
  HelloTxt.lpstrText := PAnsiChar(OldTxt);
  StartPos := SendMessage(NppData.ScintillaMainHandle, SCI_FINDTEXT, 0,
    LPARAM(@HelloTxt));
  if StartPos <> INVALID_POSITION then
  begin
    SendMessage(NppData.ScintillaMainHandle, SCI_SETTARGETSTART, StartPos, 0);
    SendMessage(NppData.ScintillaMainHandle, SCI_SETTARGETEND,
      StartPos + Length(OldTxt), 0);
    SendMessage(NppData.ScintillaMainHandle, SCI_REPLACETARGET,
      Length(OldTxt) - 1, LPARAM(PAnsiChar(NewTxt)));
    SendMessage(NppData.ScintillaMainHandle, SCI_SETSELECTIONSTART,
      StartPos, 0);
    SendMessage(NppData.ScintillaMainHandle, SCI_SETSELECTIONEND,
      Length(NewTxt), 0);
  end;
end;

procedure THelloWorldPlugin.FuncAbout;
var
  a: TAboutForm;
begin
  a := TAboutForm.Create(self);
  try
    a.ShowModal;
  finally
    FreeAndNil(a);
  end;
end;

procedure THelloWorldPlugin.FuncHelloWorldDocking;
begin
  if (not Assigned(HelloWorldDockingForm)) then
    HelloWorldDockingForm := THelloWorldDockingForm.Create(self, DlgMenuId);
  HelloWorldDockingForm.Show;
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
