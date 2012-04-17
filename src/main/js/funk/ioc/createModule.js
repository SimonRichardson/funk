funk.ioc = funk.ioc || {};
funk.ioc.createModule = function(configure){
    var newModule = (function(){
        var NewModuleImpl = function() {};
        NewModuleImpl.prototype = new funk.ioc.AbstractModule();
        NewModuleImpl.prototype.constructor = NewModuleImpl;
        NewModuleImpl.prototype.name = "NewModule";
        NewModuleImpl.prototype.configure = configure;
        return NewModuleImpl;
    })();
    return new newModule();
};