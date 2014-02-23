@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: set JAVA_HOME=<Should set JAVA_HOME here>
set JAVA_OPTS=-Xmx1024m -XX:MaxNewSize=256m -verbose:gc

:: Debugger options
set -THINKBASE_NET_RHINO_DEBUGGER=local://PortableRegain

REM detect profile home
pushd "%~dp0"
set PROFILE_HOME=!cd!
set PROFILE_HOME=!PROFILE_HOME:\=/!
popd

pushd "!PROFILE_HOME!\..\..\bin"
call start-crawler.bat "profiles\multi-indexes-template" "_main,bin,browser_AdminShells,thinkbase_main"
popd

ENDLOCAL