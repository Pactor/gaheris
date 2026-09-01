@echo off
setlocal
REM Launch the OpenDAoC client against the local WSL server.
REM connect.exe usage (from its own help string):
REM   connect.exe "<path_to_game.dll>" <server[:port]> <account> <password> [<character> <realm>]

set "SERVER=127.0.0.1:10300"

set "ACCT=%~1"
set "PASS=%~2"
if "%ACCT%"=="" set /p "ACCT=Account name: "
if "%PASS%"=="" set /p "PASS=Password: "

if "%ACCT%"=="" echo No account name given. & pause & exit /b 1
if "%PASS%"=="" echo No password given. & pause & exit /b 1

cd /d "C:\Program Files (x86)\OpenDAoC"
echo Connecting to %SERVER% as %ACCT% ...
connect.exe game1127.dll %SERVER% %ACCT% %PASS%
endlocal
