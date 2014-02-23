define(function () {
    var log = getLogger("crawler.js");

    require (["std/sys", "std/os", "std/utils/json2-util", "app/env"], function(sys, os, jsonUtil, env) {
        //The crawler settings
        if (env.CHILD_INDEX_CODE_LIST.length > 0){
            env.CRAWLER_WORKSPACE_LIST = [];
            env.CRAWLER_INDEX_DIR_LIST = [];
            env.CRAWLER_CONF_FILE_LIST = [];
            require(["std/utils/misc"], function(misc){
                misc.arrayForEach(env.CHILD_INDEX_CODE_LIST, function(indexCode, i){
                    env.CRAWLER_WORKSPACE_LIST[i] = os.normalizePath("${PROFILE_HOME}/.work/"+indexCode);
                    env.CRAWLER_INDEX_DIR_LIST[i] = os.normalizePath("${PROFILE_HOME}/data/"+indexCode);
                    env.CRAWLER_CONF_FILE_LIST[i] = os.normalizePath("${PROFILE_HOME}/conf/CrawlerConfiguration."+indexCode+".xml");
                });
            });
        }else{
            env.CRAWLER_WORKSPACE_LIST = [ os.normalizePath("${PROFILE_HOME}/.work") ];
            env.CRAWLER_INDEX_DIR_LIST = [ os.normalizePath("${PROFILE_HOME}/data") ];
            env.CRAWLER_CONF_FILE_LIST = [ os.normalizePath("${PROFILE_HOME}/conf/CrawlerConfiguration.xml") ];
        }
        
        //Show env in log
        require(["std/utils/json2-util"], function(util){
            var str = util.format(env);
            log.info("Runtime environment: " + str);
        });
        
        //Make directories, check config file
        require(["std/shell", "std/utils/misc"], function(shell, misc){
            misc.arrayForEach(env.CRAWLER_WORKSPACE_LIST, function(path){
                shell.mkdir(path);
            });
            misc.arrayForEach(env.CRAWLER_INDEX_DIR_LIST, function(path){
                shell.mkdir(path);
            });
        });
        //Check CrawlerConfiguration files exist or not
        var missingFiles = os.findMissingFiles(env.CRAWLER_CONF_FILE_LIST);
        if (missingFiles.length > 0){
            sys.raiseErr("Missing one or more required file: \n\t" + missingFiles.join(";\n\t"));
        }
        
        //Prepare the configuration files for every child-index
        require(["std/shell", "std/utils/misc"], function(shell, misc){
            misc.arrayForEach(env.CHILD_INDEX_CODE_LIST, function(indexCode, i){
                var _CURRENT = {
                    CRAWLER_WORKSPACE: env.CRAWLER_WORKSPACE_LIST[i],
                    CRAWLER_INDEX_DIR: env.CRAWLER_INDEX_DIR_LIST[i]
                }
                var provider = function(key){
                    var tmp = _CURRENT[key];
                    if (null==tmp){
                        tmp = env[key];
                    }
                    return tmp;
                };
                //find log4j properties template file
                var tmplLog4j = os.normalizePath("${PROFILE_HOME}/conf/log4j.properties");
                if (! os.fileExists(tmplLog4j)){
                    tmplLog4j = os.normalizePath("${DEFAULT_CONF}/log4j.properties");
                }
                //Apply configuration file templates
                var log4jWork = os.normalizePath([_CURRENT.CRAWLER_WORKSPACE, "log4j.properties"]);
                shell.copyTemplateFile(tmplLog4j, log4jWork, function(key){
                    return misc.escapeProperty(provider(key));
                });
                var cfgWork = os.normalizePath([_CURRENT.CRAWLER_WORKSPACE, "CrawlerConfiguration.xml"]);
                shell.copyTemplateFile(env.CRAWLER_CONF_FILE_LIST[i], cfgWork, provider);
                //Start crawler
                var java = os.normalizePath("${JAVA_HOME}/bin/java");
                var cp = [
                    os.normalizePath("${AUTH_EXT_HOME}/bin"),
                    os.normalizePath("${IK_EXT_HOME}/bin"),
                    os.normalizePath("${IK_HOME}/IKAnalyzer2012_u6.jar"),
                    os.normalizePath("${REGAIN_HOME}/runtime/crawler/regain-crawler.jar")
                ];
                cp = cp.join(Packages.java.io.File.pathSeparator);
                var javaOpts = os.getProp("JAVA_OPTS", "");
                var cmdLine = '"${java}" ${JAVA_OPTS} -Dfile.encoding=UTF-8 -cp "${cp}" net.sf.regain.crawler.Main -config "${cfg}" -logConfig "${log4j}"';
                cmdLine = misc.replacePlaceHolder(cmdLine, {java:java, cp:cp, JAVA_OPTS:javaOpts, cfg:cfgWork, log4j:log4jWork});
                log.info("COMMAND to start [" + cmdLine + "] ...");
            });
        });
        
    });
    return {};
});