var MockModule = (function(){
    var MockModuleImpl = function() {};
    MockModuleImpl.prototype = new funk.ioc.AbstractModule();
    MockModuleImpl.prototype.constructor = MockModuleImpl;
    MockModuleImpl.prototype.configure = function(){
        this.bind(String).toInstance("Test");
    };
    return MockModuleImpl;
})();