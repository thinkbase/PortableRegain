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

:: Default configuration files
set DEFAULT_CONF=!PORTABLE_ROOT!/bin/.extension/DefaultConf

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
:: Deal child index (CHILD_INDEX_CODE variable)
:: ============================================================
set CRAWLER_WORKSPACE=!PROFILE_HOME!/.work
set CRAWLER_INDEX_DIR=!PROFILE_HOME!/data
set CRAWLER_CONF_FILE=!PROFILE_HOME!/conf/CrawlerConfiguration.xml
if [%CHILD_INDEX_CODE%]==[""] set CHILD_INDEX_CODE=
if not "%CHILD_INDEX_CODE%"=="" (
    set CRAWLER_WORKSPACE=!PROFILE_HOME!/.work/%CHILD_INDEX_CODE%
    set CRAWLER_INDEX_DIR=!PROFILE_HOME!/data/%CHILD_INDEX_CODE%
    set CRAWLER_CONF_FILE=!PROFILE_HOME!/conf/CrawlerConfiguration.%CHILD_INDEX_CODE%.xml
    echo ^>^>^> Child index found: [CHILD_INDEX_CODE=%CHILD_INDEX_CODE%].
)
:: child index's configuration MUST exist - CrawlerConfiguration.${CHILD_INDEX_CODE}.xml
if "%1"=="/CRAWLER" (
    if NOT exist "!CRAWLER_CONF_FILE!" (
        echo ^>^>^> File [!CRAWLER_CONF_FILE!] missing
        echo ^ ^ ^ ^ - This necessary file is missing, please check configuration.
        echo. & pause
        exit /B -1
    )
)

:: ============================================================
:: Other preparations
:: ============================================================
:: Tomcat's temporary folders
mkdir "!TOMCAT_HOME!/temp"
mkdir "!TOMCAT_HOME!/work"
mkdir "!TOMCAT_HOME!/logs"
:: work folder, to store some temporary file
mkdir "!CRAWLER_WORKSPACE!"
:: Copy configuration files into ${CRAWLER_WORKSPACE}
xcopy /Y/F "!DEFAULT_CONF!/*.*" "!CRAWLER_WORKSPACE!/"
xcopy /Y/F "!PROFILE_HOME!/conf/*.*" "!CRAWLER_WORKSPACE!/"
:: Copy child index's configuration files into ${CRAWLER_WORKSPACE}, overwrite the profile's main configuration
:: FIXME: XCOPY should be confused by "FILE" or "DIR", so create the file (echo. > ...) before copy
if not "%CHILD_INDEX_CODE%"=="" (
    echo. > "!CRAWLER_WORKSPACE!/CrawlerConfiguration.xml"
    xcopy /Y/F "!CRAWLER_CONF_FILE!" "!CRAWLER_WORKSPACE!/CrawlerConfiguration.xml"
)
:: Replace variables(FIXME: You must use "!CRAWLER_WORKSPACE!\<file name>" in command line, "!CRAWLER_WORKSPACE!/file name" should cause file not found error of command "type")
call "!SHELL_ROOT!/do-sed" "!CRAWLER_WORKSPACE!\log4j.properties"
call "!SHELL_ROOT!/do-sed" "!CRAWLER_WORKSPACE!\CrawlerConfiguration.xml"
call "!SHELL_ROOT!/do-sed" "!CRAWLER_WORKSPACE!\SearchConfiguration.xml"
:: Copy SearchConfiguration.xml into regain webapp related folders
mkdir "!REGAIN_HOME!/runtime/search/webapps/.temp"
xcopy /Y/F "!CRAWLER_WORKSPACE!/SearchConfiguration.xml" "!REGAIN_HOME!/runtime/search/webapps/.temp"
:: PATH
set PATH=!JAVA_HOME!/bin;%PATH%

:: ============================================================
:: Initialization process report
:: ============================================================
echo.
echo ============================================================
echo * PortableRegain startup ...
echo ^>^>^> PORTABLE_ROOT     =!PORTABLE_ROOT!
echo ^>^>^> PROFILE_HOME      =!PROFILE_HOME!
echo ^>^>^> CHILD_INDEX_CODE  =!CHILD_INDEX_CODE!
echo ^>^>^> CRAWLER_WORKSPACE =!CRAWLER_WORKSPACE!
echo ^>^>^> CRAWLER_INDEX_DIR =!CRAWLER_INDEX_DIR!
echo ^>^>^> CRAWLER_CONF_FILE =!CRAWLER_CONF_FILE!
echo.
echo ^>^>^> JAVA_HOME       =!JAVA_HOME!
echo ^>^>^> REGAIN_HOME     =!REGAIN_HOME!
echo ^>^>^> TOMCAT_HOME     =!TOMCAT_HOME!
echo ^>^>^> TOMCAT_PORT_HTTP=!TOMCAT_PORT_HTTP!
echo ^>^>^> IK_HOME         =!IK_HOME!
echo ^>^>^> IK_EXT_HOME     =!IK_EXT_HOME!
echo ^>^>^> DEFAULT_CONF    =!DEFAULT_CONF!
echo ============================================================
echo.
:: Mark the initialization process finished successfully
exit /B 0