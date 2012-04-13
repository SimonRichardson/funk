funk.util = funk.util || {};
funk.util.eq = function(a, b){
    "use strict";
    var a0 = a !== null && a !== undefined && ("undefined" !== typeof a.equals);
    var b0 = b !== null && b !== undefined && ("undefined" !== typeof b.equals);
    if(a0 && b0) {
        return a.equals(b);
    }
    return a === b;
};

// Alias
var eq = funk.util.eq;