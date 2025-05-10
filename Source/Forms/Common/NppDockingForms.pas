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

//! Types and utilities for creating docked plugin dialogs
unit NppDockingForms;

{$IFDEF FPC}{$mode delphi}{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, NppPlugin, NppForms,
{$IFNDEF FPC}
  Vcl.Forms, Vcl.Dialogs, Vcl.Controls
{$ELSE}
  Forms, Dialogs, Controls, LCLIntf, LCLType
{$ENDIF};

{$I '..\..\Include\Docking.inc'}
{$I '..\..\Include\DockingResource.inc'}

type
   //! Default implementation of a docked plugin dialog
  TNppDockingForm = class(TNppForm)
  private
    { Private declarations }
    FCmdId, FDlgId: Integer;
    FOnDock: TNotifyEvent;
    FOnFloat: TNotifyEvent;
    procedure AddControlParent;
    procedure RemoveControlParent;
    class procedure SetControlParent(wincontrol: TWinControl; wsExMask: NativeUInt);
  protected
    { Protected declarations }
    ToolbarData: TToolbarData;
    NppDefaultDockingMask: Cardinal;
    // @todo: change caption and stuff....
    //! Handles the @link(DMN_FLOAT), @link(DMN_DOCK) and @link(DMN_CLOSE) Docking Manager messages.
    procedure OnWM_NOTIFY(var msg: TWMNotify); message WM_NOTIFY;
    //! Optional handler for the @link(DMM_FLOAT) message
    property OnDock: TNotifyEvent read FOnDock write FOnDock;
    //! Optional handler for the @link(DMM_FLOAT) message
    property OnFloat: TNotifyEvent read FOnFloat write FOnFloat;
  public
    { Public declarations }
    constructor Create(const NppParent: TNppPlugin; const DlgId: Integer); reintroduce; overload; virtual;
    constructor Create(AOwner: TNppForm; const DlgId: Integer); reintroduce; overload; virtual;
    destructor Destroy; override;
    procedure Show; overload;
    procedure Show(const Plugin: TNppPlugin; const DlgMenuId: integer); overload;
    procedure Hide;
    /// NOTE.
    //! Initializes the @link(ToolbarData) member and sends @link(NPPM_DMMREGASDCKDLG).
    procedure RegisterDockingForm(MaskStyle: Cardinal = DWS_DF_CONT_LEFT);
    procedure UpdateDisplayInfo; overload;
    procedure UpdateDisplayInfo(Info: String); overload;
    //! The menu ID of the plugin command associated with this @classname, assigned by Notepad++ during plugin initialization.
    //! @note(It is @name -- *not* `DlgId` -- that identifies a plugin command when sending API messages to the Notepad++
    //!       window. Using @link(TNppPlugin.CmdIdFromDlgId) wherever possible is recommended.)
    property CmdId: Integer read FCmdId default 0;
  published
    { Published declarations }
  end;

implementation

constructor TNppDockingForm.Create(const NppParent: TNppPlugin; const DlgId: Integer);
begin
  inherited Create(NppParent);
  self.FDlgId := DlgId;
  self.FCmdId := self.Npp.CmdIdFromDlgId(DlgId);
  self.RegisterDockingForm(self.NppDefaultDockingMask);
end;

constructor TNppDockingForm.Create(AOwner: TNppForm; const DlgId: Integer);
begin
  inherited Create(AOwner);
  self.FDlgId := DlgId;
  self.RegisterDockingForm(self.NppDefaultDockingMask);
end;

destructor TNppDockingForm.Destroy;
begin
  try
    with (self.ToolbarData) do
    begin
      if Assigned(Title) then
        Dispose(Title);
      if Assigned(ModuleName) then
        Dispose(ModuleName);
      if Assigned(AdditionalInfo) then
        Dispose(AdditionalInfo);
    end;
  finally
  end;
  inherited;
end;

//! @note(Because the Docking Manager signals its "children" dialogs through `WM_NOTIFY`,
//!       which is *also* broadcast by the Windows runtime, the likelihood of adverse
//!       interactions is high. The necessity of hacking your docked dialog's window
//!       attributes was discovered by this template's original developer in
//!       [this discussion thread](https://sourceforge.net/p/notepad-plus/discussion/482781/thread/ab626469).
//!       @br@br
//!       Newer development has tried to improve on Damjan Cvetko's insights, but there
//!       is probably no single solution for every use case. So, while many plugins
//!       will work fine using this method as is, be prepared to debug and edit this code path
//!       if your plugin starts freezing the editor in endless redraw loops.)
//! @param msg [in, out] a `TWMNotify` structure (compatible with Windows' [NMHDR](https://learn.microsoft.com/windows/win32/api/winuser/ns-winuser-nmhdr))
procedure TNppDockingForm.OnWM_NOTIFY(var msg: TWMNotify);
begin
  if (self.Npp.NppData.NppHandle <> msg.NMHdr.hwndFrom) then
  begin
    self.AddControlParent;
    inherited;
    exit;
  end;
  msg.Result := 0;

  if (msg.NMHdr.code = DMN_CLOSE) then
  begin
    self.DoHide;
  end;
  if ((msg.NMHdr.code and $FFFF) = DMN_FLOAT) then
  begin
    // msg.NMHdr.code shr 16 - container
    self.RemoveControlParent;
    if Assigned(FOnFloat) then
      FOnFloat(self);
  end;
  if ((msg.NMHdr.code and $FFFF) = DMN_DOCK) then
  begin
    // msg.NMHdr.code shr 16 - container
    if Assigned(FOnDock) then
      FOnDock(self);
  end;
end;

//! @br@br
//! This sets the style bitmask of the @link(ToolbarData) member to the combination of
//! @link(DWS_ADDINFO) and the given `MaskStyle`. If this form's
//! [Icon](https://lazarus-ccr.sourceforge.io/docs/lcl/forms/tcustomform.icon.html)
//! property is set, the @link(TToolbarData.IconTab) field is assigned from the icon's
//! [Handle](https://lazarus-ccr.sourceforge.io/docs/lcl/graphics/ticon.handle.html),
//! and the @link(DWS_ICONTAB) flag will be added to @link(TToolbarData.Mask).
//! @note(The initial dock position is saved in `%AppData%\Notepad++\config.xml` as a `GUIConfig` element with the
//!       `DockingManager` attribute; e.g.,
//! @longCode(
//! {
//!     <GUIConfig name="DockingManager" leftWidth="200" rightWidth="582" topHeight="200" bottomHeight="200">
//!         <PluginDlg pluginName="HelloWorld.dll" id="2" curr="1" prev="-1" isVisible="yes" />
//!         <ActiveTabs cont="0" activeTab="-1" />
//!         <!-- ... -->
//!     </GUIConfig>
//! })
//! You should delete this between launches when testing different configurations.)
//! @param MaskStyle [optional] one or more bit flags for the @link(TToolbarData.Mask) field
procedure TNppDockingForm.RegisterDockingForm
  (MaskStyle: Cardinal = DWS_DF_CONT_LEFT);
begin
  if (not Assigned(self.Npp)) then
    exit;

  self.HandleNeeded;
  FillChar(self.ToolbarData, sizeof(TToolbarData), 0);
  self.ToolbarData.Mask := MaskStyle;

  if (not self.Icon.Empty) then
  begin
    self.ToolbarData.IconTab := self.Icon.Handle;
    self.ToolbarData.Mask := self.ToolbarData.Mask or DWS_ICONTAB;
  end;

  self.ToolbarData.ClientHandle := self.Handle;

  self.ToolbarData.DlgId := self.FDlgId;
  self.ToolbarData.Mask := self.ToolbarData.Mask or DWS_ADDINFO;

  GetMem(self.ToolbarData.Title, MAX_PATH * sizeof(nppPChar));
  GetMem(self.ToolbarData.ModuleName, MAX_PATH * sizeof(nppPChar));
  GetMem(self.ToolbarData.AdditionalInfo, MAX_PATH * sizeof(nppPChar));

  StringToWideChar(self.Caption, self.ToolbarData.Title, MAX_PATH);
  SetLastError(0);
  GetModuleFileNameW(HInstance, self.ToolbarData.ModuleName, MAX_PATH);
  if GetLastError = ERROR_SUCCESS then
  begin
    StrPLCopy(self.ToolbarData.ModuleName,
      ExtractFileName(self.ToolbarData.ModuleName), MAX_PATH);
    StringToWideChar('', self.ToolbarData.AdditionalInfo, 1);
  end;
  SafeSendMessage(self.Npp.NppData.NppHandle, NPPM_DMMREGASDCKDLG, 0, @self.ToolbarData);
  self.Visible := true;
end;

procedure TNppDockingForm.Show;
begin
  if (not Assigned(self.Npp)) then
    exit;

  SafeSendMessage(self.Npp.NppData.NppHandle, NPPM_DMMSHOW, 0,
    LPARAM(self.Handle));
  inherited;
  self.DoShow;
end;

procedure TNppDockingForm.Show(const Plugin: TNppPlugin; const DlgMenuId: integer);
begin
  with self do begin
    Npp := Plugin;
    FDlgId := DlgMenuId;
    FCmdId := Plugin.CmdIdFromDlgId(DlgMenuId);
  end;
  self.RegisterDockingForm(self.NppDefaultDockingMask);
  self.Show;
end;

procedure TNppDockingForm.Hide;
begin
  if (not Assigned(self.Npp)) then
    exit;

  SafeSendMessage(self.Npp.NppData.NppHandle, NPPM_DMMHIDE, 0,
    LPARAM(self.Handle));
  self.DoHide;
end;

// This hack prevents the Win Dialog default procedure from an endless loop while
// looking for the previous component, while in a floating state.
// I still don't know why the pointer climbs up to the docking dialog that holds this one
// but this works for now.
// ==========================================================================================
class procedure TNppDockingForm.SetControlParent(wincontrol: TWinControl; wsExMask: NativeUInt);
var
  control: TControl;
  i: Integer;
begin
  Windows.SetWindowLongPtr(wincontrol.Handle, GWL_EXSTYLE, wsExMask);
  control := wincontrol as TControl;
  for i := control.ComponentCount - 1 downto 0 do
  begin
    if (control.Components[i] is TWinControl) then
    begin
      SetControlParent(control.Components[i] as TWinControl, wsExMask);
    end;
  end;
end;
// ==========================================================================================
// Set the WS_EX_CONTROLPARENT flag, e.g., whenever the Windows runtime wants to redraw us:
// https://github.com/kbilsted/NotepadPlusPlusPluginPack.Net/issues/17#issuecomment-683455467
// ==========================================================================================
procedure TNppDockingForm.AddControlParent;
var
  wincontrol: TWinControl;
  r: NativeInt;
begin
    wincontrol := Self as TWinControl;
    wincontrol.HandleNeeded;
    r := Windows.GetWindowLongPtr(wincontrol.Handle, GWL_EXSTYLE);
    if (r and WS_EX_CONTROLPARENT <> WS_EX_CONTROLPARENT) then
    begin
      SetControlParent(wincontrol, r or WS_EX_CONTROLPARENT);
    end;
end;
// ==========================================================================================
// Clear the WS_EX_CONTROLPARENT flag, e.g., when the Docking Manager sends DMN_FLOAT:
// https://sourceforge.net/p/notepad-plus/discussion/482781/thread/ab626469/#4458
// ==========================================================================================
procedure TNppDockingForm.RemoveControlParent;
var
  wincontrol: TWinControl;
  r: NativeInt;
begin
    wincontrol := Self as TWinControl;
    wincontrol.HandleNeeded;
    r := Windows.GetWindowLongPtr(wincontrol.Handle, GWL_EXSTYLE);
    if (r and WS_EX_CONTROLPARENT = WS_EX_CONTROLPARENT) then
    begin
      SetControlParent(wincontrol, r and (not WS_EX_CONTROLPARENT));
    end;
end;

procedure TNppDockingForm.UpdateDisplayInfo;
begin
  self.UpdateDisplayInfo('');
end;

procedure TNppDockingForm.UpdateDisplayInfo(Info: String);
begin
  if (not Assigned(self.Npp)) then
    exit;

  StringToWideChar(Info, self.ToolbarData.AdditionalInfo, MAX_PATH);
  SafeSendMessage(self.Npp.NppData.NppHandle, NPPM_DMMUPDATEDISPINFO, 0,
    LPARAM(self.Handle));
end;

end.
