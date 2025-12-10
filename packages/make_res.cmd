@echo off
REM ----------------------------------------------------------------------
REM (Re-)generates the resource file(s) of a design time component
REM
REM Usage:
REM   C:\> make_res [COMPONENT]
REM
REM Parameters:
REM   COMPONENT (*.lpk only)
REM     name of a design time component, e.g., TNppDockingForm
REM ----------------------------------------------------------------------
if [%1]==[] ( goto :DELPHI )
if "%LazarusDir%" NEQ "" (
  "%LazarusDir%\tools\lazres.exe" ^
    "%~dp0..\Source\Forms\Common\Resources\%1.lrs" ^
    "%~dp0..\Source\Forms\Common\Resources\%1.png" ^
    "%~dp0..\Source\Forms\Common\Resources\%1_150.png" ^
    "%~dp0..\Source\Forms\Common\Resources\%1_200.png"
)
goto :END

:DELPHI
where brcc32 >NUL: 2>&1
if %errorlevel% NEQ 0 ( goto :END )
brcc32 "%~dp0..\Source\Forms\Common\Resources\notepadplusplusplugin.rc" -r ^
  -fo"%~dp0..\Source\Forms\Common\Resources\notepadplusplusplugin.dcr"

:END
exit /B %errorlevel%
