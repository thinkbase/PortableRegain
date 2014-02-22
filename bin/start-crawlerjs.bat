@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: ============================================================
:: Initialize the system variables
:: ============================================================
:: SHELL_ROOT - Location(Path) of this batch file
pushd "%~dp0"
set SHELL_ROOT=!cd!
set SHELL_ROOT=!SHELL_ROOT:\=/!
popd
:: PORTABLE_ROOT - The root path of PortableRegain
set PORTABLE_ROOT=!SHELL_ROOT!/..
pushd "!PORTABLE_ROOT!"
set PORTABLE_ROOT=!cd!
set PORTABLE_ROOT=!PORTABLE_ROOT:\=/!
popd
:: JAVA_HOME
if "%JAVA_HOME%"=="" (
    set JAVA_HOME=!PORTABLE_ROOT!/bin/.runtime/jdk
    echo ^>^>^> Environment variable [JAVA_HOME] is empty, use the defaule value [!JAVA_HOME!]
)

:: Debugger options
set THINKBASE_NET_RHINO_DEBUGGER=local://PortableRegain

:: Call rhino-shell
set CLASSPATH=!PORTABLE_ROOT!/bin/.etc/app-js;!PORTABLE_ROOT!/bin/.runtime/rhino-shell/lib-js;!PORTABLE_ROOT!/bin/.runtime/rhino-shell/lib-java/*;
call "!JAVA_HOME!/bin/java" -cp "!CLASSPATH!" net.thinkbase.shell.rhino.Main "!PORTABLE_ROOT!"

popd
ENDLOCAL