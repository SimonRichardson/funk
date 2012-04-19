funk.tuple = funk.tuple || {};
funk.tuple.Tuple = (function(){
    "use strict";
    var TupleImpl = function(){
        funk.Product.call(this);
    };
    TupleImpl.prototype = new funk.Product();
    TupleImpl.prototype.constructor = TupleImpl;
    TupleImpl.prototype.name = "Tuple";
    TupleImpl.prototype.productPrefix = function(){
        return "Tuple";
    };
    return TupleImpl;
})();

funk.tuple.tuple = function(){
    "use strict";
    var rest = funk.toArray(arguments);
    var total = rest.length;

    funk.util.require(total > 0, "At least one element must be specified.");
    funk.util.require(total < 9, "No more than eight elements are supported.");

    switch(total) {
        case 8: return tuple8(rest[0], rest[1], rest[2], rest[3], rest[4], rest[5], rest[6], rest[7]);
        case 7: return tuple7(rest[0], rest[1], rest[2], rest[3], rest[4], rest[5], rest[6]);
        case 6: return tuple6(rest[0], rest[1], rest[2], rest[3], rest[4], rest[5]);
        case 5: return tuple5(rest[0], rest[1], rest[2], rest[3], rest[4]);
        case 4: return tuple4(rest[0], rest[1], rest[2], rest[3]);
        case 3: return tuple3(rest[0], rest[1], rest[2]);
        case 2: return tuple2(rest[0], rest[1]);
        case 1: return tuple1(rest[0]);
        default: throw new funk.error.IllegalByDefinitionError();
    }
};

// Alias
var tuple = funk.tuple.tuple;