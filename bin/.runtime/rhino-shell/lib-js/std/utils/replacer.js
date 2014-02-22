define(function () {
    /** Replace ${XXX} in a string */
    var replacePlaceHolder = function(string, dataOrProvider){
        if (!string || !dataOrProvider){
            return string;
        };
        string = string + "";   //Force to javascript string
        var result = string.replace(
            /\$\{(.*?)\}/g,
            function(s0){
                s0 = s0.substr(2,s0.length-3);
                var result = null;
                if (typeof dataOrProvider == "function"){
                    //If argument 2 is a provider
                    result = dataOrProvider.call(this, s0);
                }else{
                    //Just the data
                    result = dataOrProvider[s0];
                }
                if (null==result){
                    result = s0;
                }
                return result;
            }
        );
        return result;
    }

    return {
        replacePlaceHolder: replacePlaceHolder
    }
});