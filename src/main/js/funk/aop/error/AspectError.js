funk.aop = funk.aop || {};
funk.aop.error = funk.aop.error || {};
funk.aop.error.AspectError = (function(){
    "use strict";
    var AspectErrorImpl = function(msg){
        if(funk.isDefined(msg)) {
            this.message = msg;
        }

        Error.apply(this, arguments);
    };
    AspectErrorImpl.prototype = new Error();
    AspectErrorImpl.prototype.constructor = AspectErrorImpl;
    AspectErrorImpl.prototype.name = "AspectError";
    return AspectErrorImpl;
})();