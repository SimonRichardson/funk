var MockProviderObject = (function(){
    "use strict";
    var MockProviderObjectImpl = function(){
        funk.ioc.Provider.call(this);
    };
    MockProviderObjectImpl.prototype = new funk.ioc.Provider();
    MockProviderObjectImpl.prototype.constructor = MockProviderObjectImpl;
    MockProviderObjectImpl.prototype.name = "MockProviderObject";
    MockProviderObjectImpl.prototype.get = function(){
        funk.util.isAbstract();
    };
    return MockProviderObjectImpl;
})();