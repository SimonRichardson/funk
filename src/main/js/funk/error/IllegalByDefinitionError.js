funk.error = funk.error || {};
funk.error.IllegalByDefinitionError = (function(){
    "use strict";
    var IllegalByDefinitionErrorImpl = function(){
        Error.apply(this, arguments);
    };
    IllegalByDefinitionErrorImpl.prototype = new Error();
    IllegalByDefinitionErrorImpl.prototype.constructor = IllegalByDefinitionErrorImpl;
    IllegalByDefinitionErrorImpl.prototype.name = "IllegalByDefinitionError";
    return IllegalByDefinitionErrorImpl;
})();