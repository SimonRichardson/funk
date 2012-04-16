funk.ioc = funk.ioc || {};
funk.ioc.Provider = (function(){
    "use strict";
    var ProviderImpl = function(){};
    ProviderImpl.prototype = {};
    ProviderImpl.prototype.constructor = ProviderImpl;
    ProviderImpl.prototype.name = "Provider";
    ProviderImpl.prototype.get = function(){
        funk.util.isAbstract();
    };
    return ProviderImpl;
})();