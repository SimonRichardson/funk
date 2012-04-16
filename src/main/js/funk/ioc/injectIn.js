funk.ioc = funk.ioc || {};
funk.ioc.InjectIn = function(value, module){
    if(value === null) {
        throw new funk.error.ArgumentError("Given type must not be null.");
    } else if(module === null){
        throw new funk.error.ArgumentError("Given module type must not be null");
    }
    return funk.ioc.Injector.moduleOf(module).getInstance(value);
};

funk.ioc.injectIn = funk.ioc.InjectIn;

// Alias
var injectIn = funk.ioc.InjectIn;
