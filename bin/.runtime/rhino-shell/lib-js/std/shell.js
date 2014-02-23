define(function () {
    var log = getLogger("shell.js");
    var FileUtils = Packages.org.apache.commons.io.FileUtils;

    /** Makes a directory, including any necessary but non-existence parent directories;
      * support more then one directory(argument "path" as array). */
    var mkdir = function(path){
        if (! path){
            log.warn("Path is BLANK("+path+"), no directory created");
            return;
        }
        if (path.join){
            
        }else{
            if (! (path instanceof java.io.File) ){
                path = new java.io.File(new java.lang.String(path+""));
            }
            FileUtils.forceMkdir(path);
            log.info("Directory ["+path+"] created.");
        }
    }
    
    /** Copy file and replace place-holder variables, always use UTF-8 encoding */
    var copyTemplateFile = function(tmplPath, targetPath, dataOrProvider, thisObj){
        if (! thisObj){
            thisObj = this;
        }
        var template = FileUtils.readFileToString(new java.io.File(tmplPath), "UTF-8");
        require (["std/utils/misc"], function(replacer) {
            var result = replacer.replacePlaceHolder(template, dataOrProvider, thisObj);
            FileUtils.write(new java.io.File(targetPath), result, "UTF-8");
        });
    }
    
    return {
        mkdir: mkdir,
        copyTemplateFile: copyTemplateFile
    }
});