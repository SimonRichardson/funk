funk.error = funk.error || {};
funk.error.NoSuchElementError = (function(){
    "use strict";
    var NoSuchElementErrorImpl = function(){
        Error.apply(this, arguments);
    };
    NoSuchElementErrorImpl.prototype = new Error();
    NoSuchElementErrorImpl.prototype.constructor = NoSuchElementErrorImpl;
    NoSuchElementErrorImpl.prototype.name = "NoSuchElementError";
    return NoSuchElementErrorImpl;
})();