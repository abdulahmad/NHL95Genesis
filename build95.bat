@echo off
setlocal

REM Get the directory of this batch file
set "workspaceFolder=%~dp0"

REM Set default values for rev and checksum if not provided
if not defined rev set rev=0
if not defined checksum set checksum=1

REM Pre-step: tools\prebuild.js checks the ROM and Extracted/ and extracts the assets if they are missing
REM or incomplete; it stops the build with the ROM path, SHA-1 and size if the ROM is missing. The npm
REM scripts run it first and set NHL_PREBUILD_DONE; tools/verify_all.sh does the same under wine.
set "prebuildTarget=retail"
if not defined NHL_PREBUILD_DONE (
    node "%workspaceFolder%tools\prebuild.js" %prebuildTarget%
    if errorlevel 1 exit /b 1
)

@REM echo Using rev=%rev% and checksum=%checksum%

REM Create the output directory
if not exist "%workspaceFolder%output" mkdir "%workspaceFolder%output"

REM Change to the workspace src directory
cd /d "%workspaceFolder%src"

REM Determine revision flag
if "%REV%"=="1" (
    set revFlag="/e REV=1"
    ECHO "its reva"
) else (
    set revFlag="/e REV=0"
    ECHO "its retail"
)

REM Determine checksum flag
if "%checksum%"=="0" (
    set checksumFlag="/e CHECKSUM=0"
) else (
    set checksumFlag="/e CHECKSUM=1"
)

REM Run the assembler with all flags
"%workspaceFolder%assembler\Assembler.exe" ^
  /p /m /g ^
  /o d- /o s- /o r+ /o l+ /o l. /o ow+ /o op- /o os+ /o oz+ /o omq- /o oaq+ /o osq+ ^
  %revFlag% %checksumFlag% ^
  "%workspaceFolder%src\nhl95.asm,%workspaceFolder%output\nhl95.bin,%workspaceFolder%output\nhl95,%workspaceFolder%output\nhl95" ^
  > "%workspaceFolder%output\Build95.log"
set asmerr=%errorlevel%
findstr /C:"SHORTCALL" "%workspaceFolder%output\Build95.log" >nul
if errorlevel 1 goto noshort
echo.
echo A short-range target moved past $7FFF:
findstr /C:"SHORTCALL" "%workspaceFolder%output\Build95.log"
echo Put the added data after the 2MB fill, or use the long form. See docs\EXPANDING_THE_ROM.md.
:noshort
if not "%asmerr%"=="0" (
    echo ASSEMBLY FAILED. See output\Build95.log
    exit /b 1
)

endlocal
exit /b 0
