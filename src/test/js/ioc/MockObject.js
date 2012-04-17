var MockObject = (function(){
    var MockObjectImpl = function() {
    };
    MockObjectImpl.prototype = new funk.ioc.AbstractModule();
    MockObjectImpl.prototype.constructor = MockObjectImpl;
    MockObjectImpl.prototype.configure = function(){

    };
})();