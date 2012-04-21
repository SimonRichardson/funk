var MockObject = (function(){
    "use strict";
    var MockObjectImpl = function(){
        funk.ioc.Provider.call(this);
    };
    MockObjectImpl.prototype = new funk.ioc.Provider();
    MockObjectImpl.prototype.constructor = MockObjectImpl;
    MockObjectImpl.prototype.name = "MockObject";
    MockObjectImpl.prototype.returnValue = function(value){
        return value;
    };
    MockObjectImpl.prototype.callMe = function(func){
        func();
    };
    return MockObjectImpl;
})();