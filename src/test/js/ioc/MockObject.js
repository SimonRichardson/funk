var MockObject = (function(){
    var MockObjectImpl = function() {
        this._byInstance = funk.ioc.inject(String);
    };
    MockObjectImpl.prototype = {};
    MockObjectImpl.prototype.constructor = MockObjectImpl;
    MockObjectImpl.prototype.byInstance = function(){
        return this._byInstance;
    };
    return MockObjectImpl;
})();