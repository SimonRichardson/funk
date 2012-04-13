funk.error = funk.error || {};
funk.error.AbstractMethodError = (function(){
    "use strict";
    var AbstractMethodErrorImpl = function(msg){
        Error.apply(this, arguments);
    };
    AbstractMethodErrorImpl.prototype = new Error();
    AbstractMethodErrorImpl.prototype.constructor = AbstractMethodErrorImpl;
    AbstractMethodErrorImpl.prototype.name = "AbstractMethodError";
    return AbstractMethodErrorImpl;
})();