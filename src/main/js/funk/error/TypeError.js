funk.error = funk.error || {};
funk.error.TypeError = (function(){
    "use strict";
    var TypeErrorImpl = function(msg){
        if(funk.isDefined(msg)) {
            this.message = msg;
        }

        Error.apply(this, arguments);
    };
    TypeErrorImpl.prototype = new Error();
    TypeErrorImpl.prototype.constructor = TypeErrorImpl;
    TypeErrorImpl.prototype.name = "TypeError";
    return TypeErrorImpl;
})();