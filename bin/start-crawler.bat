@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Initialize system variables and check configuration
call "%~dp0.etc\init.cmd" /CRAWLER
IF %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%

pushd "!REGAIN_HOME!/runtime/crawler"
TITLE Regain crawler - %CHILD_INDEX_CODE%
java %JAVA_OPTS% -Dfile.encoding=UTF-8 -cp !AUTH_EXT_HOME!/bin;!IK_EXT_HOME!/bin;!IK_HOME!/IKAnalyzer2012_u6.jar;!REGAIN_HOME!/runtime/crawler/regain-crawler.jar net.sf.regain.crawler.Main -config "!CRAWLER_WORKSPACE!/CrawlerConfiguration.xml" -logConfig "!CRAWLER_WORKSPACE!/log4j.properties"

set _ERROR_=%ERRORLEVEL%
echo.
:: ERRORCODE=1 means non-fatal errors, =100 means fatal errors
IF %_ERROR_% NEQ 0 (
    echo ^>^>^> Crawler finished with errors, ERRORLEVEL=%_ERROR_% !
    IF %_ERROR_% NEQ 1 (
        echo ^>^>^> Crawler finished with fatal errors, ERRORLEVEL=%_ERROR_% !
        echo. & pause
        exit /B -1
    )
)

if NOT exist "!CRAWLER_INDEX_DIR!/new" (
    echo ^>^>^> Crawler finished with ERROR: [!CRAWLER_INDEX_DIR!/new] not created !
    echo. & pause
    exit /B -1
)

popd

ENDLOCAL