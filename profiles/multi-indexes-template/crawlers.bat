@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: set JAVA_HOME=<Should set JAVA_HOME here>
set JAVA_OPTS=-Xmx1024m -XX:MaxNewSize=256m -verbose:gc

REM detect profile home
pushd "%~dp0"
set PROFILE_HOME=!cd!
set PROFILE_HOME=!PROFILE_HOME:\=/!
popd

pushd "!PROFILE_HOME!\..\..\bin"
for %%F in (
    _main
    bin
    browser_AdminShells
    thinkbase_main
) do (
    set CHILD_INDEX_CODE=%%F
    start cmd /c start-crawler.bat
)
popd

ENDLOCAL