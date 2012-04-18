funk.ioc = funk.ioc || {};
funk.ioc.NewModule = (function(){
    var NewModuleImpl = function(configure) {
        funk.ioc.AbstractModule.call(this);

        if(!funk.isValid(configure)){
            throw new funk.error.ArgumentError("Configure must not be null");
        }
        this._configure = configure;
    };
    NewModuleImpl.prototype = new funk.ioc.AbstractModule();
    NewModuleImpl.prototype.constructor = NewModuleImpl;
    NewModuleImpl.prototype.name = "NewModule";
    NewModuleImpl.prototype.configure = function(){
        this._configure.apply(this, [this]);
    };
    return NewModuleImpl;
})();
funk.ioc.createModule = function(configure){
    return new funk.ioc.NewModule(configure);
};