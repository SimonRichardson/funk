funk.ioc = funk.ioc || {};
funk.ioc.AbstractModule = (function(){
    "use strict";
    var findByBind = function(list, item){
        var l = list;
        while(l.nonEmpty()) {
            var result = when(l.head(), {
                none: function(){
                    return false;
                },
                some: function(value){
                    if(value === funk.util.verifiedType(value, funk.ioc.Binding)) {
                        return value.bind() === item ? value : false;
                    }
                }
            });
            if(result) {
                return result;
            }
            l = l.tail().get();
        }
        return null;
    };
    var containsBind = function(list, item){
        var l = list;
        while(l.nonEmpty()) {
            var result = when(l.head(), {
                none: function(){
                    return false;
                },
                some: function(value){
                    if(value === funk.util.verifiedType(value, funk.ioc.Binding)) {
                        return value.bind() === item;
                    }
                }
            });
            if(result) {
                return true;
            }
            l = l.tail().get();
        }
        return false;
    };

    var AbstractModuleImpl = function(){
        funk.ioc.Module.call(this);

        this._list = funk.collection.immutable.nil();
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
        this._list = this._list.prepend(binding);
        return binding;
    };
    AbstractModuleImpl.prototype.initialize = function(){
        this.configure();
        this._initialized = true;
    };
    AbstractModuleImpl.prototype.getInstance = function(value){
        if(!funk.isValid(value)){
            throw new funk.error.ArgumentError("Value can not be null");
        }

        if(!this._initialized){
            throw new funk.ioc.error.BindingError("Modules have to be created using \"Injector.initialize(new Module())\".");
        }
        var binding = findByBind(this._list, value);
        try
        {
            funk.ioc.Injector.pushScope(this);
            if(funk.isValid(binding)) {
                var instance = binding.getInstance();
                return funk.option.when(instance, {
                    none: function(){
                        return new (value)();
                    },
                    some: function(v){
                        return v;
                    }
                });
            } else {
                return new (value)()
            }
        } finally {
            funk.ioc.Injector.popScope();
        }
    };
    AbstractModuleImpl.prototype.binds = function(value){
        return containsBind(this._list, value);
    };
    return AbstractModuleImpl;
})();
