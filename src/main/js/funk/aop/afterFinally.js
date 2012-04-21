funk.aop = funk.aop || {};
funk.aop.afterFinally = function(pointer, method, func){
    return funk.aop.Aspect.add(funk.aop.AspectType.AFTER_FINALLY, pointer, method, func);
};

// Alias
var afterFinally = funk.aop.afterFinally;