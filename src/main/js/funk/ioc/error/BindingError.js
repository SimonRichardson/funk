funk.ioc = funk.ioc || {};
funk.ioc.error = funk.ioc.error || {};
funk.ioc.error.BindingError = (function(){
    "use strict";
    var BindingErrorImpl = function(msg){
        if(funk.isDefined(msg)) {
            this.message = msg;
        }

        Error.apply(this, arguments);
    };
    BindingErrorImpl.prototype = new Error();
    BindingErrorImpl.prototype.constructor = BindingErrorImpl;
    BindingErrorImpl.prototype.name = "BindingError";
    return BindingErrorImpl;
})();