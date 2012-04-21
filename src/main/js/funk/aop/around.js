funk.aop = funk.aop || {};
funk.aop.around = function(pointer, method, func){
    return funk.aop.Aspect.add(funk.aop.AspectType.AROUND, pointer, method, func);
};

// Alias
var around = funk.aop.around;