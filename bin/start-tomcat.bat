@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Initialize system variables and check configuration
call "%~dp0.etc\init.cmd" /TOMCAT
IF %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%

:: Deploy regain web-app
>  "%TOMCAT_HOME%\conf\Catalina\localhost\ROOT.xml" echo ^<?xml version=^"1.0^" encoding=^"UTF-8^"?^>
>> "%TOMCAT_HOME%\conf\Catalina\localhost\ROOT.xml" echo ^<Context path=^"/^" docBase=^"!REGAIN_HOME!/runtime/search/webapps/regain^" reloadable=^"true^" allowLinking=^"true^"/^>

:: Start tomcat (See alse: $TOMCAT_HOME/bin/setenv.bat)
pushd "!TOMCAT_HOME!/bin"
TITLE Regain tomcat server
set JAVA_OPTS=%JAVA_OPTS% -DTOMCAT_PORT_HTTP=%TOMCAT_PORT_HTTP%
call startup.bat
popd

ENDLOCAL