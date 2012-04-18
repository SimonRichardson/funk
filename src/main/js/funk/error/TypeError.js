funk.error = funk.error || {};
funk.error.TypeError = (function(){
    "use strict";
    var TypeErrorImpl = function(msg){
        Error.apply(this, arguments);

        if(funk.isDefined(msg)) {
            this.message = msg;
        }
    };
    TypeErrorImpl.prototype = new Error();
    TypeErrorImpl.prototype.constructor = TypeErrorImpl;
    TypeErrorImpl.prototype.name = "TypeError";
    return TypeErrorImpl;
})();