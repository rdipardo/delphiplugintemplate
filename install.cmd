@echo off
REM ----------------------------------------------------------------------
REM Copies template infrastructure files to a plugin project directory
REM
REM Usage:
REM   C:\> install [PROJECT_PATH]
REM
REM Parameters:
REM   PROJECT_PATH
REM     relative path to your project root (where the *.dpr file is);
REM     can be entered at the prompt if no argument is given
REM ----------------------------------------------------------------------
setlocal EnableDelayedExpansion
SET "TEMPLATE_PATH=.\Source"

IF "%1"=="" (
  SET /p "PROJECT_DIR=Enter the root path of your plugin project: "
  SET "PROJECT_PATH=%~dp0!PROJECT_DIR!"
) ELSE SET "PROJECT_PATH=%~dp0%1"

IF NOT EXIST "%PROJECT_PATH%" md "%PROJECT_PATH%"

xcopy /DIY %TEMPLATE_PATH%\Include %PROJECT_PATH%\Include
xcopy /DIY %TEMPLATE_PATH%\Units\Common %PROJECT_PATH%\Units\Common
xcopy /DIY %TEMPLATE_PATH%\Forms\Common %PROJECT_PATH%\Forms\Common
echo D | xcopy /DIY %TEMPLATE_PATH%\Units\DLLExports.pas %PROJECT_PATH%\Units

PAUSE
endlocal
