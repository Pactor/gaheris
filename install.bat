@echo off
setlocal enabledelayedexpansion

rem ============================================================
rem  Gaheris conversion installer for Windows -- no WSL/Linux.
rem
rem  The Windows equivalent of install.sh. Applies the sql\ migrations
rem  to an OpenDAoC database on MySQL or MariaDB, in numeric order,
rem  resolving feature dependencies from sql\features.conf.
rem
rem  Usage:
rem    install.bat                     the whole conversion
rem    install.bat mercenaries         one feature and its dependencies
rem    install.bat classes travel      several at once
rem    install.bat --list              what can be installed on its own
rem    install.bat --dry-run frontiers name the migrations, apply none
rem    install.bat --testkit           also the optional testing kit
rem    install.bat --maintenance       also the one-off repair scripts
rem
rem  Connection settings come from a .env file beside this script
rem  (a line DB_PASSWORD=yourpass), or from the variables below.
rem ============================================================

cd /d "%~dp0"

set "CONF=sql\features.conf"
if not exist "%CONF%" (
  echo ERROR: %CONF% not found. Run this from the repo root.
  exit /b 1
)

rem ---- parse arguments ----
set "FEATURES="
set "FEATURES_GIVEN="
set "EXTRAS="
set "DRYRUN="
set "DOLIST="

:parseargs
if "%~1"=="" goto afterargs
set "a=%~1"
if /i "!a!"=="--list" (set "DOLIST=1" & shift & goto parseargs)
if /i "!a!"=="--dry-run" (set "DRYRUN=1" & shift & goto parseargs)
if /i "!a!"=="--testkit" (set "EXTRAS=!EXTRAS! testkit" & shift & goto parseargs)
if /i "!a!"=="--maintenance" (set "EXTRAS=!EXTRAS! maintenance" & shift & goto parseargs)
if "!a:~0,1!"=="-" (echo Unknown option: !a! & exit /b 1)
set "FEATURES=!FEATURES! !a!"
set "FEATURES_GIVEN=1"
shift
goto parseargs
:afterargs

rem ---- parse features.conf into DEPS_x / NUMS_x / KNOWN_x and LISTED ----
set "LISTED="
findstr /v /b /c:"#" "%CONF%" | findstr /c:"|" > "%TEMP%\gah_feat.txt"
for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%TEMP%\gah_feat.txt") do (
  set "nm=%%a"
  set "nm=!nm: =!"
  if not "!nm!"=="" (
    set "KNOWN_!nm!=1"
    set "DEPS_!nm!=%%b"
    set "NUMS_!nm!=%%c"
    set "LISTED=!LISTED! %%c "
  )
)

if defined DOLIST (
  echo Features that can be installed on their own:
  echo.
  for /f "usebackq tokens=1,2 delims=|" %%a in ("%TEMP%\gah_feat.txt") do (
    set "nm=%%a"
    set "nm=!nm: =!"
    set "dp=%%b"
    if not "!nm!"=="" echo   !nm!  needs:!dp!
  )
  echo.
  echo   install.bat mercenaries     one feature and its dependencies
  echo   install.bat                 everything
  echo.
  echo See docs\features.md for what each one is and which scripts go with it.
  del "%TEMP%\gah_feat.txt" >nul 2>&1
  exit /b 0
)

rem ---- resolve requested features into WANTED (migration numbers) ----
set "WANTED="
set "SELECTED="
set "UNKNOWN="
if defined FEATURES_GIVEN (
  for %%f in (!FEATURES!) do call :want "%%f"
  if defined UNKNOWN (del "%TEMP%\gah_feat.txt" >nul 2>&1 & exit /b 1)
  echo Applying:!SELECTED!
) else (
  echo Installing the full conversion.
)
echo.

rem ---- connection settings ----
if not defined DB_HOST set "DB_HOST=127.0.0.1"
if not defined DB_PORT set "DB_PORT=3306"
if not defined DB_USER set "DB_USER=root"
if not defined DB_NAME set "DB_NAME=opendaoc"

if not defined DB_PASSWORD if exist ".env" (
  for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
    if /i "%%a"=="DB_PASSWORD" set "DB_PASSWORD=%%b"
  )
)
if defined DB_PASSWORD set "DB_PASSWORD=!DB_PASSWORD:"=!"

set "CLIENT="
set "PWARG="

if not defined DRYRUN (
  if not defined DB_PASSWORD set /p "DB_PASSWORD=Database password for %DB_USER%: "

  rem ---- locate the client: mysql.exe or mariadb.exe ----
  for %%c in (mysql.exe mariadb.exe) do (
    if not defined CLIENT for /f "delims=" %%p in ('where %%c 2^>nul') do (
      if not defined CLIENT set "CLIENT=%%p"
    )
  )
  if not defined CLIENT for /d %%d in ("%ProgramFiles%\MariaDB*" "%ProgramFiles%\MySQL\MySQL Server*") do (
    if not defined CLIENT if exist "%%d\bin\mariadb.exe" set "CLIENT=%%d\bin\mariadb.exe"
    if not defined CLIENT if exist "%%d\bin\mysql.exe"   set "CLIENT=%%d\bin\mysql.exe"
  )
  if not defined CLIENT (
    echo ERROR: could not find mysql.exe or mariadb.exe.
    echo Add your MariaDB/MySQL "bin" folder to PATH, then rerun.
    exit /b 1
  )
  echo Using client: !CLIENT!

  if defined DB_PASSWORD set "PWARG=-p!DB_PASSWORD!"

  echo Testing connection to %DB_NAME% on %DB_HOST%:%DB_PORT% ...
  echo SELECT 1; | "!CLIENT!" -h %DB_HOST% -P %DB_PORT% -u %DB_USER% !PWARG! --default-character-set=utf8mb4 %DB_NAME% >nul 2>&1
  if errorlevel 1 (
    echo ERROR: could not connect, or database "%DB_NAME%" does not exist.
    echo Check DB_HOST / DB_USER / DB_PASSWORD, and that the stock OpenDAoC
    echo database has been created and imported first.
    exit /b 1
  )
  echo Connection OK.
  echo.
)

rem ---- apply migrations in numeric order ----
set "W= !WANTED! "
for /l %%n in (1,1,200) do (
  set "do="
  if not defined FEATURES_GIVEN (
    set "do=1"
  ) else (
    set "chk=!W: %%n =!"
    if not "!chk!"=="!W!" set "do=1"
  )
  if defined do (
    set "num=%%n"
    if %%n LSS 10 set "num=0%%n"
    for %%f in ("sql\!num!-*.sql") do (
      if defined DRYRUN (
        echo   would apply  %%~nxf
      ) else (
        <nul set /p "=  %%~nxf ... "
        "!CLIENT!" -h %DB_HOST% -P %DB_PORT% -u %DB_USER% !PWARG! --default-character-set=utf8mb4 %DB_NAME% < "%%f" >nul 2>&1
        if errorlevel 1 (echo FAILED & goto :fail)
        echo ok
      )
    )
  )
)

rem ---- optional extras ----
for %%e in (!EXTRAS!) do (
  if /i "%%e"=="testkit" (
    echo.
    echo Applying the testing kit:
    for %%f in ("sql\optional\*.sql") do call :applyone "%%f"
  )
  if /i "%%e"=="maintenance" (
    echo.
    echo Applying maintenance scripts:
    for %%f in ("sql\maintenance\*.sql") do call :applyone "%%f"
  )
)

del "%TEMP%\gah_feat.txt" >nul 2>&1
echo.
echo Done. Now copy the scripts\ folder into your server's scripts\custom
echo directory and restart the gameserver.
exit /b 0

:applyone
if defined DRYRUN (
  echo   would apply  %~nx1
  goto :eof
)
<nul set /p "=  %~nx1 ... "
"!CLIENT!" -h %DB_HOST% -P %DB_PORT% -u %DB_USER% !PWARG! --default-character-set=utf8mb4 %DB_NAME% < "%~1" >nul 2>&1
if errorlevel 1 (echo FAILED & goto :fail)
echo ok
goto :eof

rem ---- resolve a feature (with aliases) and pull in its dependencies ----
:want
call :resolvealias "%~1"
set "ff=!RESOLVED!"
if not defined KNOWN_!ff! (
  >&2 echo Unknown feature: %~1
  >&2 echo Try: install.bat --list
  set "UNKNOWN=1"
  goto :eof
)
if defined SEL_!ff! goto :eof
set "SEL_!ff!=1"
set "SELECTED=!SELECTED! !ff!"
for %%x in (!NUMS_%ff%!) do if not "%%x"=="-" set "WANTED=!WANTED! %%x"
if "!ff!"=="base" call :baseextras
for %%d in (!DEPS_%ff%!) do if not "%%d"=="-" call :want "%%d"
goto :eof

:resolvealias
set "RESOLVED=%~1"
set "RESOLVED=!RESOLVED: =!"
if /i "!RESOLVED!"=="mercs" set "RESOLVED=mercenaries"
if /i "!RESOLVED!"=="merc" set "RESOLVED=mercenaries"
if /i "!RESOLVED!"=="companions" set "RESOLVED=mercenaries"
if /i "!RESOLVED!"=="mauler" set "RESOLVED=maulers"
if /i "!RESOLVED!"=="ml" set "RESOLVED=masterlevels"
if /i "!RESOLVED!"=="mls" set "RESOLVED=masterlevels"
if /i "!RESOLVED!"=="masterlevel" set "RESOLVED=masterlevels"
if /i "!RESOLVED!"=="champions" set "RESOLVED=champion"
if /i "!RESOLVED!"=="cl" set "RESOLVED=champion"
if /i "!RESOLVED!"=="ras" set "RESOLVED=realmabilities"
if /i "!RESOLVED!"=="realmability" set "RESOLVED=realmabilities"
if /i "!RESOLVED!"=="ra" set "RESOLVED=realmabilities"
if /i "!RESOLVED!"=="toa" set "RESOLVED=atlantis"
if /i "!RESOLVED!"=="dungeons" set "RESOLVED=taskdungeons"
if /i "!RESOLVED!"=="td" set "RESOLVED=taskdungeons"
if /i "!RESOLVED!"=="catacombs" set "RESOLVED=classes"
if /i "!RESOLVED!"=="si" set "RESOLVED=classes"
if /i "!RESOLVED!"=="shrouded-isles" set "RESOLVED=classes"
if /i "!RESOLVED!"=="class" set "RESOLVED=classes"
if /i "!RESOLVED!"=="allclasses" set "RESOLVED=classes"
goto :eof

rem ---- migrations in no feature belong to base (applied by default) ----
:baseextras
set "L= !LISTED! "
for %%f in ("sql\*.sql") do (
  set "bn=%%~nf"
  for /f "delims=-" %%k in ("!bn!") do set "pfx=%%k"
  call :toint "!pfx!"
  if defined INT (
    set "chk=!L: %INT% =!"
    if "!chk!"=="!L!" set "WANTED=!WANTED! !INT!"
  )
)
goto :eof

:toint
set "T=%~1"
if "!T!"=="" (set "INT=" & goto :eof)
if "!T:~0,1!"=="0" set "T=!T:~1!"
set "INT="
for /f "delims=0123456789" %%z in ("!T!x") do set "BAD=%%z"
if "!BAD!"=="x" set "INT=!T!"
set "BAD="
goto :eof

:fail
del "%TEMP%\gah_feat.txt" >nul 2>&1
echo.
echo Stopped on the migration above. Nothing further was applied.
echo Fix the cause (often the stock DB was not imported) and rerun;
echo the migrations are idempotent, so rerunning is safe.
exit /b 1
