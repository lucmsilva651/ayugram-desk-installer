@echo off
chcp 65001 > nul

echo Removing old installs of AyuGram...
rmdir /q /s %LOCALAPPDATA%\AyuGram
rmdir /q /s %LOCALAPPDATA%\NirCmd
cls

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
