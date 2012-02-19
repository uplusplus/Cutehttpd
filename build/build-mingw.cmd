@echo off
setlocal enableextensions

mingw32-make -v >nul 2>&1 || call :Set_MinGW
mingw32-make -v >nul 2>&1 || goto No_MinGW

if "%*" == "" (set C= ) else (set C= %* )

pushd ..\src
call build-lib.cmd %C%
popd

copy /y ..\src\chtd.dll .

set s_cmdl=gcc main.c -o chtd-static.exe -Os -s -Wall%C%-static -I. -I../src -I../dep -L../src -L../dep -lchtd -lws2_32
rem set d_cmdl=gcc main.c -o chtd-shared.exe -s -Wall%C% -Wl,--subsystem,windows -I. -I../src -I../dep -L../src -L../dep -lchtd

if exist chtd-static.exe (del chtd-static.exe /q || goto :End)
if exist chtd-shared.exe (del chtd-shared.exe /q || goto :End)

echo cmdl='%s_cmdl%' & %s_cmdl% || goto End

rem echo %d_cmdl%
rem %d_cmdl% || goto End
goto End

if exist *.ex~ del *.ex~ /q
if exist *.dl~ del *.dl~ /q
upx -qk chtd-static.exe chtd-shared.exe chtd.dll
goto End


:Set_MinGW
set MinGW=D:\MinGW
set path=%path%;%MinGW%\bin
goto End


:No_MinGW
echo. # MinGW not found!
goto End


:End
