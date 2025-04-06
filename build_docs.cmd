@echo off
REM ----------------------------------------------------------------------
REM Generates HTML doc pages using `pasdoc`
REM
REM Usage:
REM   C:\> build_docs [TOOLCHAIN] [PLATFORM]
REM
REM Parameters:
REM   TOOLCHAIN
REM     Pascal compiler identifier: FPC, DELPHI
REM   PLATFORM
REM     target CPU architecture: WIN32 (for x86), WIN64 (for x64)
REM ----------------------------------------------------------------------
setlocal
where pasdoc >NUL: 2>&1
if %errorlevel% NEQ 0 ( goto :NOPASDOC )

set "DOCS_PATH=%~dp0docs"
set TOOLCHAIN=FPC
set PLATFORM=WIN64

if "%1" NEQ "" ( set "TOOLCHAIN=%1" )
if "%2" NEQ "" ( set "PLATFORM=%2" )

md "%DOCS_PATH%" 2>NUL:
md "%DOCS_PATH%\cache" 2>NUL:
pasdoc @pasdoc.cfg --output "%DOCS_PATH%" --cache-dir "%DOCS_PATH%\cache" ^
  --define=%TOOLCHAIN% ^
  --define=%PLATFORM% ^
  "%~dp0Source\Units\Common\*.pas" ^
  "%~dp0Source\Forms\Common\*.pas" ^
  "%~dp0Source\Units\DLLExports.pas"
goto :END

:NOPASDOC
echo :: ==============================================================
echo :: 'pasdoc.exe' is not on the PATH. See https://pasdoc.github.io
echo :: ==============================================================

:END
exit /B %errorlevel%

endlocal
