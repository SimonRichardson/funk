funk.aop = funk.aop || {};
funk.aop.AspectType = (function(){
    "use strict";
    var AspectTypeImpl = function(type){
        this._type = type;
    };
    AspectTypeImpl.prototype = {};
    AspectTypeImpl.prototype.constructor = AspectTypeImpl;
    AspectTypeImpl.prototype.equals = function(type){
        return this._type === type._type;
    };
    AspectTypeImpl.AFTER = new AspectTypeImpl(0);
    AspectTypeImpl.AFTER_THROW = new AspectTypeImpl(1);
    AspectTypeImpl.AFTER_FINALLY = new AspectTypeImpl(2);
    AspectTypeImpl.AROUND = new AspectTypeImpl(3);
    AspectTypeImpl.BEFORE = new AspectTypeImpl(4);
    return AspectTypeImpl;
})();

// Alias
var AspectType = funk.aop.AspectType;