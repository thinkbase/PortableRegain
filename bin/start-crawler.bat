@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: SHELL_ROOT - Location(Path) of this batch file
pushd "%~dp0"
set SHELL_ROOT=!cd!
popd
:: PORTABLE_ROOT - The root path of PortableRegain
set PORTABLE_ROOT=!SHELL_ROOT!/..
pushd "!PORTABLE_ROOT!"
set PORTABLE_ROOT=!cd!
popd

:: PROFILE_HOME - Profile folder
set PROFILE_HOME=%1
set PROFILE_HOME=%PROFILE_HOME:"=%
if "%PROFILE_HOME%"=="" (
    echo ^>^>^> Environment variable [PROFILE_HOME] is empty, use the defaule value.
    echo ^ ^ ^> This variable should be first argument when calling "%0".
)

:: CHILD_INDEX_CODE_LIST - code list of more the one child-index
set CHILD_INDEX_CODE_LIST=%2
set CHILD_INDEX_CODE_LIST=%CHILD_INDEX_CODE_LIST:"=%
if "%CHILD_INDEX_CODE_LIST%"=="" (
    echo ^>^>^> Environment variable [CHILD_INDEX_CODE_LIST] is empty, use the defaule value.
    echo ^ ^ ^> This variable should be second argument when calling "%0".
)

:: JAVA_HOME
if "%JAVA_HOME%"=="" (
    set JAVA_HOME=!PORTABLE_ROOT!/bin/.runtime/jdk
    echo ^>^>^> Environment variable [JAVA_HOME] is empty, use the defaule value [!JAVA_HOME!]
)

:: Call rhino-shell
set CLASSPATH=!PORTABLE_ROOT!\bin\.etc\app-js;!PORTABLE_ROOT!\bin\.runtime\rhino-shell\lib-js;!PORTABLE_ROOT!\bin\.runtime\rhino-shell\lib-java\*;
echo "!JAVA_HOME!\bin\java" -cp "!CLASSPATH!" net.thinkbase.shell.rhino.Main
call "!JAVA_HOME!\bin\java" -cp "!CLASSPATH!" net.thinkbase.shell.rhino.Main

ENDLOCAL