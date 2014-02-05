@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Initialize system variables and check configuration
call "%~dp0.etc\init.cmd"
IF %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%

pushd "!REGAIN_HOME!/runtime/crawler"
TITLE Regain crawler
java %JAVA_OPTS% -Dfile.encoding=UTF-8 -cp !IK_EXT_HOME!/bin;!IK_HOME!/IKAnalyzer2012_u6.jar;!REGAIN_HOME!/runtime/crawler/regain-crawler.jar net.sf.regain.crawler.Main -config "!PROFILE_HOME!/.work/CrawlerConfiguration.xml" -logConfig "!PROFILE_HOME!/.work/log4j.properties"
popd

ENDLOCAL