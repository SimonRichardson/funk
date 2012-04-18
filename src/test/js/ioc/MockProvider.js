var MockProvider = (function(){
    "use strict";
    var MockProviderImpl = function(){
        funk.ioc.Provider.call(this);
    };
    MockProviderImpl.prototype = new funk.ioc.Provider();
    MockProviderImpl.prototype.constructor = MockProviderImpl;
    MockProviderImpl.prototype.name = "MockProvider";
    MockProviderImpl.prototype.get = function(){
        funk.util.isAbstract();
    };
    return MockProviderImpl;
})();