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

//! Types and utilities for creating basic plugin dialogs
unit NppForms;

{$IFDEF FPC}{$mode delphi}{$ENDIF}

interface

uses
  Windows, Messages, Classes, NppPlugin,
{$IFNDEF FPC}
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs
{$ELSE}
  Graphics, Controls, Forms, Dialogs, LCLIntf, LCLType, LMessages, LResources
{$ENDIF};

type
  //! Generic function type of a typical Win32 window message procedure
  TWinApiMsgProc = function(Hndl: HWND; Msg: Cardinal; _WParam: WPARAM;
    _LParam: LPARAM): LRESULT; stdcall;

{$IFNDEF FPC}
  {$if CompilerVersion >= 23.0}[ComponentPlatformsAttribute(pidWin32 or pidWin64)]{$endif}
{$ENDIF}
   //! Default implementation of a basic (non-docking) plugin dialog
  TNppForm = class(TForm)
  private
    { Private declarations }
    FThemeInitialized: Boolean;
    FRegistered: Boolean;
    function CanRegister: Boolean;
  protected
    //! Sends a plugin or Scintilla API message to a dialog window
    function SafeSendMessage(Hndl: HWND; Msg: Cardinal; _WParam: NativeUInt = 0; _LParam: NativeInt = 0): LRESULT; overload;
    //! Sends a plugin or Scintilla API message to a dialog window when the `LPARAM` is a pointer
    function SafeSendMessage(Hndl: HWND; Msg: Cardinal; _WParam: NativeUInt = 0; _LParam: Pointer = nil): LRESULT; overload;
    //! Sends @link(NPPM_MODELESSDIALOG) with @link(MODELESSDIALOGADD)
    procedure RegisterForm();
    //! Sends @link(NPPM_MODELESSDIALOG) with @link(MODELESSDIALOGREMOVE)
    procedure UnregisterForm();
    //! Allows this @classname instance to replace the given `TCloseAction` with @link(DefaultCloseAction)
    procedure DoClose(var Action: TCloseAction); override;
{$ifdef FPC}
    { sent by clicking the 'X' on the title bar }
    //! Added to ensure that Free Pascal plugin dialogs respond to the `X` close button after @link(ShowModal) is called.
    //! @note(Not implemented for Delphi plugins.)
    procedure HandleCloseQuery({%H-}Sender: TObject; {%H-}var CanClose: Boolean); virtual;
{$endif}
  public
    { Public declarations }
    Npp: TNppPlugin;
    DefaultCloseAction: TCloseAction;
    //! Overrides the base constructor to create a new @classname instance.
    constructor Create(AOwner: TComponent); overload; override;
    //! Creates a new @classname instance and initializes the @link(Npp) member.
    //! @param Plugin [in] an instance of @link(TNppPlugin); it should be initialized when @link(DLLExports.DLLEntryPoint) receives `DLL_PROCESS_ATTACH`
    constructor Create(const Plugin: TNppPlugin); reintroduce; overload;
    destructor Destroy; override;
    function WantChildKey(Child: TControl; var Message: TMessage): Boolean; override;
    procedure ToggleDarkMode; virtual;
    procedure SubclassAndTheme(DmFlag: Cardinal); virtual;
{$ifdef FPC}
    //! Displays this @classname in its own message loop, but without disabling the parent window.
    //! @note(Not implemented for Delphi plugins.)
    function ShowModal: Integer; override;
{$endif}
  end;

{$ifdef FPC}
//! @exclude
procedure Register;
{$endif}

implementation

uses SysUtils;

//! @note(This overload does __*not*__ initialize the @link(Npp) member. Two-phase initialization
//!       is required when this constructor is called explicitly or implicitly, as, for example,
//!       by calling @url(
{$ifdef FPC}
//! https://wiki.freepascal.org/TApplication
{$else}
//! https://docwiki.embarcadero.com/Libraries/Athens/en/Vcl.Forms.TApplication.CreateForm
{$endif}
//! Application.CreateForm); e.g.,
//! @longCode(
//!   interface
//!
//!   uses
//!     NppPlugin, NppForms, Forms;
//!
//!   type
//!     TPlugin = class(TNppPlugin)
//!     // ...
//!     end;
//!
//!     TPluginForm = class(TNppForm)
//!     // ...
//!     end;
//!
//!   var
//!     MyForm: TPluginForm;
//!
//!   implementation
//!
//!   constructor TPlugin.Create;
//!   begin
//!     Application.CreateForm(TPluginForm, MyForm);
//!     MyForm.Npp := Self;
//!   end;
//!))
constructor TNppForm.Create(AOwner: TComponent);
begin
  FThemeInitialized := False;
  FRegistered := False;
  self.DefaultCloseAction := caNone;
{$ifdef FPC}
  self.OnCloseQuery := HandleCloseQuery;
{$endif}
  inherited Create(AOwner);
  if Assigned(Self.Npp) then
    ToggleDarkMode;
end;

constructor TNppForm.Create(const Plugin: TNppPlugin);
begin
  self.Npp := Plugin;
  Create(TComponent(nil));
end;

destructor TNppForm.Destroy;
begin
  try
    if (Assigned(self.Npp)) then
    begin
      self.UnregisterForm();
    end;
  finally
  end;
  inherited;
end;

function TNppForm.SafeSendMessage(Hndl: HWND; Msg: Cardinal; _WParam: NativeUInt; _LParam: NativeInt): LRESULT;
begin
  try
    if SendMessageTimeoutW(Hndl, Msg, _WParam, _LParam, SMTO_NORMAL, 5000, @Result) = 0 then
      RaiseLastOSError;
  except
    on E: EOSError do begin
      raise;
    end;
    on E: Exception do begin
      raise;
    end;
  end;
end;

function TNppForm.SafeSendMessage(Hndl: HWND; Msg: Cardinal; _WParam: NativeUInt; _LParam: Pointer): LRESULT;
begin
  Result := SafeSendMessage(Hndl, Msg, _WParam, NativeInt(_LParam));
end;

procedure TNppForm.RegisterForm();
begin
  if not CanRegister then
    exit;
  // "For each created dialog in your plugin, you should register it (and
  // unregister while destroy it) to Notepad++ by using this message. If
  // this message is ignored, then your dialog won't react with the key
  // stroke messages such as TAB key. For the good functioning of your
  // plugin dialog, you're recommended to not ignore this message"
  // https://github.com/notepad-plus-plus/npp-usermanual/blob/master/content/docs/plugin-communication.md#nppm_modelessdialogage
  FRegistered :=
    LRESULT(0) <> SafeSendMessage(self.Npp.NppData.NppHandle, NPPM_MODELESSDIALOG,
      MODELESSDIALOGADD, LPARAM(self.Handle));
end;

procedure TNppForm.UnregisterForm();
begin
  if not (FRegistered and CanRegister) then
    exit;
  SafeSendMessage(self.Npp.NppData.NppHandle, NPPM_MODELESSDIALOG,
    MODELESSDIALOGREMOVE, LPARAM(self.Handle));
end;

procedure TNppForm.DoClose(var Action: TCloseAction);
begin
  if (self.DefaultCloseAction <> caNone) then
    Action := self.DefaultCloseAction;
  inherited;
end;

// This is going to help us solve the problems we are having because of N++ handling our messages
function TNppForm.WantChildKey(Child: TControl; var Message: TMessage): Boolean;
begin
  Result := Child.Perform(CN_BASE + Message.Msg, Message.WParam,
    Message.LParam) <> 0;
end;

procedure TNppForm.ToggleDarkMode;
var
  DmFlag: Cardinal;
begin
  if FThemeInitialized then
    DmFlag := dmfHandleChange
  else begin
    DmFlag := dmfInit;
    FThemeInitialized := True;
  end;
  if Assigned(self.Npp) and (self.Npp.CanSubclass) then
    SubclassAndTheme(DmFlag);
end;

procedure TNppForm.SubclassAndTheme(DmFlag: Cardinal);
begin
  SafeSendMessage(Npp.NppData.NppHandle, NPPM_DARKMODESUBCLASSANDTHEME, DmFlag, self.Handle);
end;

function TNppForm.CanRegister: Boolean;
begin
  Result := (Assigned(self.Npp) and IsWindow(self.Npp.NppData.NppHandle) and self.HandleAllocated);
end;

{$ifdef FPC}
//! Whereas Delphi treats Notepad++ itself as the main application, and disables the editor as
//! expected, the main application handle of an LCL program should **never** be reassigned after
//! initialization. The LCL's default @name method attempts to hide the parent window. But if
//! the main application handle belongs to Notepad++, hiding it makes the editor window
//! disappear, with no user-accessible way to focus it again, requiring the Task Manager to
//! ultimately shut it down.
//! @warning(If the user does not explicitly close the modal form, the message loop created by
//!          this method will continue running even after Notepad++ has been shut down. The Task
//!          Manager can be used to kill the form in such cases.)
function TNppForm.ShowModal: Integer;
begin
  Exclude(FFormState, fsModal);
  try
    try
      FormStyle := fsSystemStayOnTop;
      Show;
      while (ModalResult = mrNone) do
      begin
        { https://gitlab.com/freepascal.org/lazarus/lazarus/-/blob/main/lcl/include/customform.inc?ref_type=heads#L3022 }
        Application.HandleMessage;
      end;
    finally
      Result := ModalResult;
    end;
  except
    Raise;
  end;
end;

procedure TNppForm.HandleCloseQuery({%H-}Sender: TObject; {%H-}var CanClose: Boolean);
begin
  ModalResult := mrCancel;
end;

procedure Register;
begin
  {$I resources/tnppform.lrs}
  RegisterComponents('N++ Plugin', [TNppForm]);
end;
{$endif}
end.
