funk.curry = function(func, x, scope) {
    return function() {
        var a = funk.toArray(arguments);
        a.unshift(x);
        return func.apply(scope, a);
    }
}