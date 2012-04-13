funk.closure = function(f){
    "use strict";
    var outer = funk.toArray(arguments);
    outer.shift();
    return function(){
        var inner = funk.toArray(arguments);
        return inner.length == 0 ? f.apply(null, outer) : f.apply(null, inner);
    }
}
