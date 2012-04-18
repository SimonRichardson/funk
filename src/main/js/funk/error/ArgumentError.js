funk.error = funk.error || {};
funk.error.ArgumentError = (function(){
    "use strict";
    var ArgumentErrorImpl = function(msg){
        Error.apply(this, arguments);

        if(funk.isDefined(msg)) {
            this.message = msg;
        }
    };
    ArgumentErrorImpl.prototype = new Error();
    ArgumentErrorImpl.prototype.constructor = ArgumentErrorImpl;
    ArgumentErrorImpl.prototype.name = "ArgumentError";
    return ArgumentErrorImpl;
})();