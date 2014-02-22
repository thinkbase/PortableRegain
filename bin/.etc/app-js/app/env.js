define(function () {
    var log = function(msg){
        print("[env] " + msg);
    }
    log("Command line arguments: " + __ARGS__.join(", "));

    require (["std/sys", "std/os"], function(sys, os) {
        var env = sys.appProperties;
        
        env.PORTABLE_ROOT = os.normalizePath("../../..")+"";
        //PROFILE_HOME, default is $PORTABLE_ROOT/profiles/default
        env.PROFILE_HOME = os.normalizePath([env.PORTABLE_ROOT, os.getProp("PROFILE_HOME", "profiles/default")]);
        //REGAIN_HOME
        env.REGAIN_HOME = os.normalizePath("${PORTABLE_ROOT}/bin/.runtime/regain");
        //TOMCAT_HOME
        env.TOMCAT_HOME = os.normalizePath("${PORTABLE_ROOT}bin/.runtime/tomcat");
        //IKAnalyzer home
        env.IK_HOME = os.normalizePath("${PORTABLE_ROOT}bin/.runtime/IKAnalyzer");
        //IKAnalyzer extension home
        env.IK_EXT_HOME = os.normalizePath("${PORTABLE_ROOT}bin/.extension/IKAnalyzer");
        //Default configuration files
        env.DEFAULT_CONF = os.normalizePath("${PORTABLE_ROOT}bin/.extension/DefaultConf");
        //Authentication extension home
        env.AUTH_EXT_HOME = os.normalizePath("${PORTABLE_ROOT}bin/.extension/AuthExt");
        //Show env in log
        log(dump(env));
        
        //Check environment(folders and files)
        //${PROFILE_HOME}/conf/CrawlerConfiguration*.xml, ${PROFILE_HOME}/conf/SearchConfiguration.xml, ${JAVA_HOME}/bin/java.exe
        var files = [
            "${PROFILE_HOME}/conf/CrawlerConfiguration*.xml",
            "${PROFILE_HOME}/conf/SearchConfiguration.xml",
            "${JAVA_HOME}/bin/java*"
        ];
        var filesExist = os.fileExists(files);
        if (! filesExist){
            sys.raiseErr("Missing one or more required file: " + files.join(";"));
        }
    });
    return {};
});