funk.error = funk.error || {};
funk.error.AbstractMethodError = (function(){
    "use strict";
    var AbstractMethodErrorImpl = function(msg){
        if(funk.isDefined(msg)) {
            this.message = msg;
        }

        Error.apply(this, arguments);
    };
    AbstractMethodErrorImpl.prototype = new Error();
    AbstractMethodErrorImpl.prototype.constructor = AbstractMethodErrorImpl;
    AbstractMethodErrorImpl.prototype.name = "AbstractMethodError";
    return AbstractMethodErrorImpl;
})();