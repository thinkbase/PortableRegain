@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: set JAVA_HOME=<Should set JAVA_HOME here>
set JAVA_OPTS=-Xmx1024m
set TOMCAT_PORT_HTTP=81

REM detect profile home
pushd "%~dp0"
set PROFILE_HOME=!cd!
set PROFILE_HOME=!PROFILE_HOME:\=/!
popd

pushd "!PROFILE_HOME!\..\..\bin"
call start-tomcat.bat
popd

ENDLOCAL