funk.ioc = funk.ioc || {};
funk.ioc.createObject = function(configure){
    if(!funk.isValid(configure)){
        throw new funk.error.ArgumentError("Configure must not be null");
    }
    // Create a new instance to get around the configure issue and lazy evaluation
    var NewObject = (function(){
        var NewObjectImpl = function() {
            funk.ioc.AbstractModule.call(this);

            configure.apply(this, [this]);
        };
        NewObjectImpl.prototype = new funk.ioc.AbstractModule();
        NewObjectImpl.prototype.constructor = NewObjectImpl;
        NewObjectImpl.prototype.name = "NewObject";
        return NewObjectImpl;
    })();

    return NewObject;
};