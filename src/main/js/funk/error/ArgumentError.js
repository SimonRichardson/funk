funk.error = funk.error || {};
funk.error.ArgumentError = (function(){
    "use strict";
    var ArgumentErrorImpl = function(msg){
        Error.apply(this, arguments);
    };
    ArgumentErrorImpl.prototype = new Error();
    ArgumentErrorImpl.prototype.constructor = ArgumentErrorImpl;
    ArgumentErrorImpl.prototype.name = "ArgumentError";
    return ArgumentErrorImpl;
})();