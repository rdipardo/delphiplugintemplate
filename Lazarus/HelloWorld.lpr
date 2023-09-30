{
  Copyright 2022 Robert Di Pardo

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

library HelloWorld;

{$IFDEF RELEASE}
  {$SetPEOptFlags $40}
{$ENDIF}

{$R '..\Source\HelloWorldResource.res'}
{$WARN SYMBOL_PLATFORM OFF} // Notepad++ only supports Windows

uses
  SysUtils,
  Classes,
  Types,
  Windows,
  Messages,
  Interfaces,
  LCLIntf,
  LCLType,
  LMessages,
  Forms,
  DLLExports in '..\Source\Units\DLLExports.pas',
  ModulePath in '..\Source\Units\Common\ModulePath.pas',
  VersionInfo in '..\Source\Units\Common\VersionInfo.pas',
  NppPlugin in '..\Source\Units\Common\nppplugin.pas',
  NppForms in '..\Source\Forms\Common\NppForms.pas' {NppForm} ,
  NppDockingForms in '..\Source\Forms\Common\NppDockingForms.pas' {NppDockingForm} ,
  HelloworldDockingforms in '..\Source\Forms\helloworlddockingforms.pas' {HelloWorldDockingForm} ,
  HelloWorldPlugin in '..\Source\Units\HelloWorldPlugin.pas';

exports
  setInfo, getName, getFuncsArray, beNotified, messageProc, isUnicode;

begin
  Dll_Process_Detach_Hook:= @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
  Application.Initialize;
  Application.CreateForm(THelloWorldDockingForm, HelloWorldDockingForm);
end.
