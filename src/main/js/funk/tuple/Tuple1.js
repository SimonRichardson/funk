funk.tuple = funk.tuple || {};
funk.tuple.Tuple1 = (function(){
    "use strict";
    var TupleImpl = function(_1){
        this.__1 = _1;
    };
    TupleImpl.prototype = new funk.tuple.Tuple();
    TupleImpl.prototype.constructor = TupleImpl;
    TupleImpl.prototype._1 = function(){
        return this.__1;
    };
    TupleImpl.prototype.productArity = function(){
        return 1;
    };
    TupleImpl.prototype.productElement = function(index){
        switch(index) {
            case 0: return this._1();
            default: throw new funk.error.RangeError();
        }
    };
    TupleImpl.prototype.productPrefix = function(){
        return "Tuple1";
    };
    TupleImpl.prototype.name = "Tuple1";
    return TupleImpl;
})();

funk.tuple.tuple1 = function(_1){
    return new funk.tuple.Tuple1(_1);
};

// Alias
var tuple1 = funk.tuple.tuple1;