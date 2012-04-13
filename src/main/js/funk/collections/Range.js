funk.collection = funk.collection || {};
funk.collection.Range = (function(){
    "use strict";
    var RangeImpl = function(){};
    RangeImpl.to = function(start, end){
        funk.require(start < end, "Start must be less than end.");

        var m = start - 1;
        var n = end + 1;
        var list = nil();

        while(--n > m) {
            list = list.prepend(n);
        }

        return list;
    };
    RangeImpl.until = function(start, end){
        funk.require(start < end, "Start must be less than end.");

        var m = start - 1;
        var n = end;
        var list = nil();

        while(--n > m) {
            list = list.prepend(n);
        }

        return list;
    }
    return RangeImpl;
})();