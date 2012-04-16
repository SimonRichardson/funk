funk.ioc = funk.ioc || {};
funk.ioc.Binding = (function(){
    "use strict";
    var solve = function(binding){
        var type = binding._bindingClass;
        if(0 === type){
            return funk.option.when(binding._to, {
                none: function(){
                    return new binding._bind();
                },
                some: function(value){
                    return binding._module.getInstance(binding._to);
                }
            });
        } else if(1 == type) {
            return binding._toInstance;
        } else if(2 == type) {
            var provider = binding._module.getInstance(binding._toProvider);
            return funk.util.verifiedType(provider, funk.ioc.Provider).get();
        }
    };
    var BindingImpl = function(module, bind){
        this._module = funk.util.verifiedType(module, funk.ioc.AbstractModule);
        this._bind = bind;

        this._to = funk.option.none();
        this._toInstance = funk.option.none();
        this._toProvider = funk.option.none();
        this._bindingClass = -1;
        this._singletonScope = false;
        this._evaluated = false;
        this._value = funk.option.none();
    };
    BindingImpl.prototype = new funk.ioc.Scope();
    BindingImpl.prototype.constructor = BindingImpl;
    BindingImpl.prototype.name = "Binding";
    BindingImpl.prototype.to = function(value){
        this._to = funk.option.some(value);
        this._bindingClass = 0;
        return this;
    };
    BindingImpl.prototype.toInstance = function(instance){
        this._toInstance = funk.option.some(instance);
        this._bindingClass = 1;
        return this;
    };
    BindingImpl.prototype.toProvider = function(provider){
        if(provider === funk.util.verifiedType(provider, funk.ioc.Provider)){
            this._toProvider = funk.option.some(provider);
            this._bindingClass = 2;
            return this;
        }
    };
    BindingImpl.prototype.getInstance = function(){
        if(this._singletonScope) {
            if(this._evaluated){
                return this._value;
            }

            this._value = solve(this);
            this._evaluated = true;
        } else {
            return solve(this);
        }
    };
    BindingImpl.prototype.asSingleton = function(){
        this._singletonScope = true;
    };
    return BindingImpl;
})();