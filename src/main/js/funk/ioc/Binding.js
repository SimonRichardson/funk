funk.ioc = funk.ioc || {};
funk.ioc.Binding = (function(){
    "use strict";
    var solve = function(binding){
        var type = binding._bindingClass;
        if(0 === type){

            return funk.option.when(binding._to, {
                none: function(){
                    return new (binding._bind)();
                },
                some: function(value){
                    return binding._module.getInstance(value);
                }
            });

        } else if(1 === type) {

            return funk.option.when(binding._toInstance, {
                some: function(value){
                    return value;
                }
            });

        } else if(2 === type) {

            var bindingProvider = funk.option.when(binding._toProvider, {
                some: function(value){
                    return value;
                }
            });
            var provider = funk.option.when(binding._module.getInstance(bindingProvider), {
                some: function(value){
                    return value;
                }
            });
            return funk.util.verifiedType(provider, funk.ioc.Provider);

        } else {
            throw new funk.ioc.error.BindingError("Unexpected binding type");
        }
    };
    var BindingImpl = function(module, bind){
        funk.ioc.Scope.call(this);

        this._module = funk.util.verifiedType(module, funk.ioc.AbstractModule);
        this._bind = bind;

        this._to = funk.option.none();
        this._toInstance = funk.option.none();
        this._toProvider = funk.option.none();
        this._bindingClass = 0;
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
                return funk.util.verifiedType(this._value, funk.option.Option);
            }
            this._value = funk.option.some(solve(this));
            this._evaluated = true;
            return this._value;
        } else {
            return funk.option.some(solve(this));
        }
    };
    BindingImpl.prototype.asSingleton = function(){
        this._singletonScope = true;
    };
    return BindingImpl;
})();