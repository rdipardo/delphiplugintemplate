library HelloWorld;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$R 'HelloWorldResource.res' 'HelloWorldResource.rc'}

{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$ENDIF}

{$WARN SYMBOL_PLATFORM OFF} // Notepad++ only supports Windows

uses
  SysUtils,
  Classes,
  Types,
  Windows,
  Messages,
  DLLExports in 'Units\DLLExports.pas',
  NppPlugin in 'Units\Common\nppplugin.pas',
  NppForms in 'Forms\Common\NppForms.pas' {NppForm} ,
  NppDockingForms in 'Forms\Common\NppDockingForms.pas' {NppDockingForm} ,
  AboutForms in 'Forms\AboutForms.pas' {AboutForm} ,
  HelloworldDockingforms in 'Forms\helloworlddockingforms.pas' {HelloWorldDockingForm} ,
  HelloWorldPlugin in 'Units\HelloWorldPlugin.pas';

exports
  setInfo, getName, getFuncsArray, beNotified, messageProc;
{$IFDEF NPPUNICODE}
exports
  isUnicode;
{$ENDIF}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  { First, assign the procedure to the DLLProc variable }
  DllProc := @DLLEntryPoint;
  { Now invoke the procedure to reflect that the DLL is attaching to the process }
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
