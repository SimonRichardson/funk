funk.aop = funk.aop || {};
funk.aop.before = function(pointer, method, func){
    return funk.aop.Aspect.add(funk.aop.AspectType.BEFORE, pointer, method, func);
};

// Alias
var before = funk.aop.before;