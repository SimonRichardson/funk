funk.error = funk.error || {};
funk.error.NoSuchMethodError = (function(){
    "use strict";
    var NoSuchMethodErrorImpl = function(msg){
        Error.apply(this, arguments);

        if(funk.isDefined(msg)) {
            this.message = msg;
        }
    };
    NoSuchMethodErrorImpl.prototype = new Error();
    NoSuchMethodErrorImpl.prototype.constructor = NoSuchMethodErrorImpl;
    NoSuchMethodErrorImpl.prototype.name = "NoSuchMethodError";
    return NoSuchMethodErrorImpl;
})();