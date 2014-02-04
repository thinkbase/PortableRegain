:: ============================================================
:: Initialize the system variables
:: ============================================================
:: SHELL_ROOT - Location(Path) of this batch file
pushd "%~dp0"
set SHELL_ROOT=!cd!
set SHELL_ROOT=!SHELL_ROOT:\=/!
popd
:: PORTABLE_ROOT - The root path of PortableRegain
set PORTABLE_ROOT=!SHELL_ROOT!/../..
pushd "!PORTABLE_ROOT!"
set PORTABLE_ROOT=!cd!
set PORTABLE_ROOT=!PORTABLE_ROOT:\=/!
popd
:: PORTABLE_ROOT_URL - File URL of PortableRegain (NOTE: ":" should be encoded by "%3A")
set PORTABLE_ROOT_URL=file://!PORTABLE_ROOT::=%%3A!
set PORTABLE_ROOT_URL_4_CMDLINE=file://!PORTABLE_ROOT::=%%%%3A!
:: PROFILE_HOME - The profile home, default value is ${PORTABLE_ROOT}/profiles/default
if "%PROFILE_HOME%"=="" (
    set PROFILE_HOME=!PORTABLE_ROOT!/profiles/default
    echo ^>^>^> Environment variable [PROFILE_HOME] is empty, use the defaule value [!PROFILE_HOME!]
)
:: PROFILE_HOME_URL - File URL of profile home (NOTE: ":" should be encoded by "%3A")
set PROFILE_HOME_URL=file://!PROFILE_HOME::=%%3A!
set PROFILE_HOME_URL_4_CMDLINE=file://!PROFILE_HOME::=%%%%3A!
:: REGAIN_HOME
set REGAIN_HOME=!PORTABLE_ROOT!/bin/.runtime/regain
:: TOMCAT_HOME
set TOMCAT_HOME=!PORTABLE_ROOT!/bin/.runtime/tomcat
:: JAVA_HOME
if "%JAVA_HOME%"=="" (
    set JAVA_HOME=!PORTABLE_ROOT!/bin/.runtime/jdk
    echo ^>^>^> Environment variable [JAVA_HOME] is empty, use the defaule value [!JAVA_HOME!]
)
:: IKAnalyzer home
set IK_HOME=!PORTABLE_ROOT!/bin/.runtime/IKAnalyzer
:: IKAnalyzer extension home
set IK_EXT_HOME=!PORTABLE_ROOT!/bin/.extension/IKAnalyzer

:: TOMCAT_PORT_HTTP, Tomcat http port
if "%TOMCAT_PORT_HTTP%"=="" (
    set TOMCAT_PORT_HTTP=8080
    echo ^>^>^> Environment variable [TOMCAT_PORT_HTTP] is empty, use the defaule value [!TOMCAT_PORT_HTTP!]
)

:: ============================================================
:: Check necessary files
:: ============================================================
:: ${PROFILE_HOME}/conf/CrawlerConfiguration.xml, ${PROFILE_HOME}/conf/SearchConfiguration.xml, ${JAVA_HOME}/bin/java.exe
for %%F in (
    "!PROFILE_HOME!/conf/CrawlerConfiguration.xml"
    "!PROFILE_HOME!/conf/SearchConfiguration.xml"
    "!JAVA_HOME!/bin/java.exe"
) do (
    if NOT exist "%%F" (
        echo ^>^>^> File [%%F] missing
        echo ^ ^ ^ ^ - This necessary file is missing, please check configuration.
        echo. & pause
        exit /B -1
    )
)

:: ============================================================
:: Other preparations
:: ============================================================
:: work folder, to store some temporary file
mkdir "!PROFILE_HOME!/.work"
:: Copy configuration files into .work and replace variables
:: (FIXME: You must use ".work\*.*" in command line, ".work/*.*" should not work
xcopy /Y/F "!PROFILE_HOME!/conf/*.*" "!PROFILE_HOME!/.work"
call "!SHELL_ROOT!/fart" -V "!PROFILE_HOME!/.work\*.*" ${PROFILE_HOME} !PROFILE_HOME!
call "!SHELL_ROOT!/fart" -V "!PROFILE_HOME!/.work\*.*" ${PROFILE_HOME_URL} !PROFILE_HOME_URL_4_CMDLINE!
call "!SHELL_ROOT!/fart" -V "!PROFILE_HOME!/.work\*.*" ${PORTABLE_ROOT} !PORTABLE_ROOT!
call "!SHELL_ROOT!/fart" -V "!PROFILE_HOME!/.work\*.*" ${PORTABLE_ROOT_URL} !PORTABLE_ROOT_URL_4_CMDLINE!
:: data folder, to store the search index
mkdir "!PROFILE_HOME!/data"
:: Copy SearchConfiguration.xml into regain webapp related folders
mkdir "!REGAIN_HOME!/runtime/search/webapps/.temp"
xcopy /Y/F "!PROFILE_HOME!/.work/SearchConfiguration.xml" "!REGAIN_HOME!/runtime/search/webapps/.temp"
:: PATH
set PATH=!JAVA_HOME!/bin;%PATH%

:: ============================================================
:: Initialization process report
:: ============================================================
echo.
echo ============================================================
echo * PortableRegain startup ...
echo ^>^>^> PORTABLE_ROOT=!PORTABLE_ROOT!
echo ^>^>^> PROFILE_HOME =!PROFILE_HOME!
echo.
echo ^>^>^> JAVA_HOME       =!JAVA_HOME!
echo ^>^>^> REGAIN_HOME     =!REGAIN_HOME!
echo ^>^>^> TOMCAT_HOME     =!TOMCAT_HOME!
echo ^>^>^> TOMCAT_PORT_HTTP=!TOMCAT_PORT_HTTP!
echo ^>^>^> IK_HOME         =!IK_HOME!
echo ^>^>^> IK_EXT_HOME     =!IK_EXT_HOME!
echo ============================================================
echo.
:: Mark the initialization process finished successfully
exit /B 0