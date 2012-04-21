funk.aop = funk.aop || {};
funk.aop.after = function(pointer, method, func){
    return funk.aop.Aspect.add(funk.aop.AspectType.AFTER, pointer, method, func);
};

// Alias
var after = funk.aop.after;