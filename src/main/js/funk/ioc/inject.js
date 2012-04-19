funk.ioc = funk.ioc || {};
funk.ioc.inject = function(type){
    if(type == null) {
        throw new funk.error.ArgumentError("Given type must not be null.")
    }

    var currentScope = funk.ioc.Injector.currentScope();
    if(!funk.isValid(currentScope)){
        return funk.ioc.Injector.scopeOf(type).getInstance(type);
    }
    return currentScope.getInstance(type);
};

// Alias
var inject = funk.ioc.inject;