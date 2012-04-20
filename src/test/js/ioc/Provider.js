var Provider = (function(){
    "use strict";
    var ProviderImpl = function(){
        funk.ioc.Provider.call(this);

        ProviderImpl.singleton = inject(SingletonInstance);
    };
    ProviderImpl.prototype = new MockProvider();
    ProviderImpl.prototype.constructor = ProviderImpl;
    ProviderImpl.prototype.name = "Provider";
    ProviderImpl.prototype.get = function(){
        return new ProvidedObject();
    };
    return ProviderImpl;
})();