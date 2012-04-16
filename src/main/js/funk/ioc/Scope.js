funk.ioc = funk.ioc || {};
funk.ioc.Scope = (function(){
    "use strict";
    var ScopeImpl = function(){};
    ScopeImpl.prototype = {};
    ScopeImpl.prototype.constructor = ScopeImpl;
    ScopeImpl.prototype.name = "Scope";
    ScopeImpl.prototype.asSingleton = function(){
        funk.util.isAbstract();
    };
    return ScopeImpl;
})();