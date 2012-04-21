funk.aop = funk.aop || {};
funk.aop.afterThrow = function(pointer, method, func){
    return funk.aop.Aspect.add(funk.aop.AspectType.AFTER_THROW, pointer, method, func);
};

// Alias
var afterThrow = funk.aop.afterThrow;