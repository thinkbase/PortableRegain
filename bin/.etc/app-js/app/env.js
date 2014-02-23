define(function () {
    var env;
    require (["std/sys", "std/os"], function(sys, os) {
        env = sys.appProperties;
        
        env.PORTABLE_ROOT = os.normalizePath("../../..")+"";
        //PROFILE_HOME, default is $PORTABLE_ROOT/profiles/default
        env.PROFILE_HOME = os.normalizePath([env.PORTABLE_ROOT, os.getProp("PROFILE_HOME", "profiles/default")]);
        //REGAIN_HOME
        env.REGAIN_HOME = os.normalizePath("${PORTABLE_ROOT}/bin/.runtime/regain");
        //TOMCAT_HOME
        env.TOMCAT_HOME = os.normalizePath("${PORTABLE_ROOT}/bin/.runtime/tomcat");
        //IKAnalyzer home
        env.IK_HOME = os.normalizePath("${PORTABLE_ROOT}/bin/.runtime/IKAnalyzer");
        //IKAnalyzer extension home
        env.IK_EXT_HOME = os.normalizePath("${PORTABLE_ROOT}/bin/.extension/IKAnalyzer");
        //Default configuration files
        env.DEFAULT_CONF = os.normalizePath("${PORTABLE_ROOT}/bin/.extension/DefaultConf");
        //Authentication extension home
        env.AUTH_EXT_HOME = os.normalizePath("${PORTABLE_ROOT}/bin/.extension/AuthExt");
        
        //PORTABLE_ROOT_URL and PROFILE_HOME
        env.PORTABLE_ROOT_URL = (new java.io.File(env.PORTABLE_ROOT)).toURI().toURL()+"";
        env.PROFILE_HOME_URL = (new java.io.File(env.PROFILE_HOME)).toURI().toURL()+"";
        
        //CHILD_INDEX_CODE_LIST: codes of child-index(split by ",", such as "site1,site2,docs").
        env.CHILD_INDEX_CODE_LIST = os.getProp("CHILD_INDEX_CODE_LIST");
        //Now convert it to an array ...
        if (env.CHILD_INDEX_CODE_LIST){
            env.CHILD_INDEX_CODE_LIST = env.CHILD_INDEX_CODE_LIST.split(",");
            require (["std/utils/misc"], function(trimer) {
                env.CHILD_INDEX_CODE_LIST = trimer.trim(env.CHILD_INDEX_CODE_LIST);
            });
        }else{
            env.CHILD_INDEX_CODE_LIST = [];
        }
        
        //Check environment(folders and files)
        //${PROFILE_HOME}/conf/CrawlerConfiguration*.xml, ${PROFILE_HOME}/conf/SearchConfiguration.xml, ${JAVA_HOME}/bin/java.exe
        var files = [
            "${PROFILE_HOME}/conf/CrawlerConfiguration*.xml",
            "${PROFILE_HOME}/conf/SearchConfiguration.xml",
            "${JAVA_HOME}/bin/java*"
        ];
        var filesExist = os.fileExists(files);
        if (! filesExist){
            sys.raiseErr("Missing one or more required file: " + files.join(";") + ", please check.");
        }
    });
    return env;
});