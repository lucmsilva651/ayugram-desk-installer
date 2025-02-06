@echo off
chcp 65001 > nul

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------      

echo Removing old installs of AyuGram...
rmdir /q /s %LOCALAPPDATA%\AyuGram
rmdir /q /s %LOCALAPPDATA%\NirCmd
cls

echo Adding exclusions from Windows Defender...
powershell -nologo -noprofile -command "Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\AyuGram"
powershell -nologo -noprofile -command "Add-MpPreference -ExclusionPath "$env:LOCALAPPDATA\NirCmd"

echo Downloading and installing from GitHub...
powershell -nologo -noprofile -command "curl https://github.com/AyuGram/AyuGramDesktop/releases/latest/download/AyuGram.zip -o %LOCALAPPDATA%\AyuGram.zip"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%LOCALAPPDATA%\AyuGram.zip', '%LOCALAPPDATA%\AyuGram'); }"

echo Downloading NirCmd to do shortcuts...
powershell -nologo -noprofile -command "curl https://www.nirsoft.net/utils/nircmd-x64.zip -o %LOCALAPPDATA%\NirCmd.zip"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%LOCALAPPDATA%\NirCmd.zip', '%LOCALAPPDATA%\NirCmd'); }"

echo Doing shortcuts...
%LOCALAPPDATA%\NirCmd\nircmd.exe shortcut "%LOCALAPPDATA%\AyuGram\AyuGram.exe" "~$folder.programs$" "AyuGram"
%LOCALAPPDATA%\NirCmd\nircmd.exe shortcut "%LOCALAPPDATA%\AyuGram\AyuGram.exe" "~$folder.desktop$" "AyuGram"

echo Removing temp file...
del /f "%LOCALAPPDATA%\NirCmd.zip"
del /f "%LOCALAPPDATA%\AyuGram.zip"
rmdir /q /s %LOCALAPPDATA%\NirCmd

echo Starting AyuGram...
start %LOCALAPPDATA%\AyuGram\AyuGram.exe
exit
