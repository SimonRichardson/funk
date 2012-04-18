funk.ioc = funk.ioc || {};
funk.ioc.AbstractModule = (function(){
    "use strict";
    var AbstractModuleImpl = function(){
        this._map = {};
        this._initialized = false;
    };
    AbstractModuleImpl.prototype = new funk.ioc.Module();
    AbstractModuleImpl.prototype.constructor = AbstractModuleImpl;
    AbstractModuleImpl.prototype.name = "AbstractModule";
    AbstractModuleImpl.prototype.configure = function(){
        funk.util.isAbstract();
    };
    AbstractModuleImpl.prototype.bind = function(value){
        if(this.binds(value)){
            throw new funk.ioc.error.BindingError(value + "is already bound.");
        }

        var binding = new funk.ioc.Binding(this, value);
        this._map[value] = binding;
        return binding;
    };
    AbstractModuleImpl.prototype.initialize = function(){
        this.configure();
        this._initialized = true;
    };
    AbstractModuleImpl.prototype.getInstance = function(value){
        if(!this._initialized){
            throw new funk.ioc.error.BindingError("Modules have to be created using \"Injector.initialize(new Module())\".");
        }

        var binding = this._map[value];
        try
        {
            funk.ioc.Injector.pushScope(this);
            return funk.isValid(binding) ? binding.getInstance() : new value();
        } finally {
            funk.ioc.Injector.popScope();
        }
    };
    AbstractModuleImpl.prototype.binds = function(value){
        return funk.isValid(this._map[value]);
    };
    return AbstractModuleImpl;
})();
