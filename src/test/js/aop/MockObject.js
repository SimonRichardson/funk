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
        console.log(value);
        if(funk.isDefined(value)){
            this._property = value;
        }
        console.log(">>", this._property);
        return this._property;
    };
    MockObjectImpl.prototype.returnValue = function(value){
        return value;
    };
    MockObjectImpl.prototype.callMe = function(func){
        func();
    };
    return MockObjectImpl;
})();