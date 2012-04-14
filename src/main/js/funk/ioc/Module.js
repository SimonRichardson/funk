funk.ioc = funk.ioc || {};
funk.ioc.Module = (function(){
    "use strict";
    var ModuleImpl = function(){};
    ModuleImpl.prototype = {};
    ModuleImpl.prototype.constructor = ModuleImpl;
    ModuleImpl.prototype.name = "Module";
    ModuleImpl.prototype.initialize = function(){
        funk.util.isAbstract();
    };
    ModuleImpl.prototype.getInstance = function(value){
        funk.util.isAbstract();
    };
    ModuleImpl.prototype.binds = function(value){
        funk.util.isAbstract();
    };
    return ModuleImpl;
})();