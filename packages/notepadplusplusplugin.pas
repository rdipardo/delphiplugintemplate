{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit notepadplusplusplugin;

{$warn 5023 off : no warning about unused units}
interface

uses
  NppDockingForms, NppForms, ModulePath, NppPlugin, Utf8IniFiles, VersionInfo, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('NppDockingForms', @NppDockingForms.Register);
  RegisterUnit('NppForms', @NppForms.Register);
end;

initialization
  RegisterPackage('notepadplusplusplugin', @Register);
end.
