@echo off
chcp 65001 > nul

echo Uninstalling AyuGram and temp files...
rmdir /q /s %LOCALAPPDATA%\AyuGram
rmdir /q /s %LOCALAPPDATA%\NirCmd

echo Removing shortcuts...
del /f "%APPDATA%\Roaming\Microsoft\Windows\Start Menu\Programs\AyuGram.lnk"
del /f "%USERPROFILE%\Desktop\AyuGram.lnk"