var MockObject = (function(){
    "use strict";
    var MockObjectImpl = function(){
        funk.ioc.Provider.call(this);

        this._property = 0;
    };
    MockObjectImpl.prototype = new funk.ioc.Provider();
    MockObjectImpl.prototype.constructor = MockObjectImpl;
    MockObjectImpl.prototype.name = "MockObject";
    MockObjectImpl.prototype.property = function(value){
        if(funk.isDefined(value)) {
            this._property = value;
        }
        return this._property;
    }
    MockObjectImpl.prototype.returnValue = function(value){
        return value;
    };
    MockObjectImpl.prototype.callMe = function(func){
        func();
    };
    MockObjectImpl.prototype.toString = function(){
        return "Mock(" + this._property + ")";
    };
    return MockObjectImpl;
})();