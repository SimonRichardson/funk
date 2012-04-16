funk.compose = function(func, next) {
    return function(){
        return func(next.apply(null, funk.toArray(arguments)));
    }
};