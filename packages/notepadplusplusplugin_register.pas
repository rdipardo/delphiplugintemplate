unit notepadplusplusplugin_register;

{$R ..\Source\Forms\Common\Resources\notepadplusplusplugin.dcr}

interface

procedure Register;

implementation

uses
  Classes, NppForms, NppDockingForms;

procedure Register;
begin
  RegisterComponents('N++ Plugin', [TNppForm]);
  RegisterComponents('N++ Plugin', [TNppDockingForm]);
end;

end.
