var SingletonInstance = (function(){
    "use strict";
    var SingletonInstanceImpl = function(){
        SingletonInstanceImpl.numInstances++;
    };
    SingletonInstanceImpl.prototype = {};
    SingletonInstanceImpl.prototype.constructor = SingletonInstanceImpl;
    SingletonInstanceImpl.prototype.name = "SingletonInstance";
    SingletonInstanceImpl.numInstances = 0;
    return SingletonInstanceImpl;
})();