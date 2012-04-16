funk.util = funk.util || {};
funk.util.eq = function(a, b){
    "use strict";
    var a0 = a !== null && a !== undefined && ("undefined" !== typeof a.equals);
    var b0 = b !== null && b !== undefined && ("undefined" !== typeof b.equals);
    if(a0 && b0) {
        return a.equals(b);
    } else if((a0 && !b0) || (!a0 && b0)) {
        // Possible option to value comparison
        var a1 = a instanceof funk.option.Option;
        var b1 = b instanceof funk.option.Option;

        if(a1 || b1) {
            var opt = a1 ? a : b;
            var val = a1 ? b : a;

            return when(opt, {
                none: function(){
                    return funk.util.eq(false, val);
                },
                some: function(value){
                    return funk.util.eq(value, val);
                }
            });
        }
    }
    return a === b;
};

// Alias
var eq = funk.util.eq;