@echo off
SETLOCAL

set FILE=%1
set FILE=%FILE:"=%

:: Sed regex escape: C:/temp/test ==> C:\/temp\/test
set PROFILE_HOME=%PROFILE_HOME:/=\/%
set PROFILE_HOME_URL=%PROFILE_HOME_URL:/=\/%
set PORTABLE_ROOT=%PORTABLE_ROOT:/=\/%
set PORTABLE_ROOT_URL=%PORTABLE_ROOT_URL:/=\/%
set CRAWLER_WORKSPACE=%CRAWLER_WORKSPACE:/=\/%
set CRAWLER_INDEX_DIR=%CRAWLER_INDEX_DIR:/=\/%

set SED=%~dp0.\sed\bin\sed.exe
type "%FILE%" ^
    | "%SED%" "s/\${PROFILE_HOME}/%PROFILE_HOME%/g" ^
    | "%SED%" "s/\${PROFILE_HOME_URL}/%PROFILE_HOME_URL%/g" ^
    | "%SED%" "s/\${PORTABLE_ROOT}/%PORTABLE_ROOT%/g" ^
    | "%SED%" "s/\${PORTABLE_ROOT_URL}/%PORTABLE_ROOT_URL%/g" ^
    | "%SED%" "s/\${CRAWLER_WORKSPACE}/%CRAWLER_WORKSPACE%/g" ^
    | "%SED%" "s/\${CRAWLER_INDEX_DIR}/%CRAWLER_INDEX_DIR%/g" ^
    > "%FILE%.swap"
copy "%FILE%.swap" "%FILE%"

ENDLOCAL