funk.tuple = funk.tuple || {};
funk.tuple.Tuple2 = (function(){
    "use strict";
    var TupleImpl = function(_1, _2){
        this.__1 = _1;
        this.__2 = _2;
    };
    TupleImpl.prototype = new funk.tuple.Tuple();
    TupleImpl.prototype.constructor = TupleImpl;
    TupleImpl.prototype._1 = function(){
        return this.__1;
    };
    TupleImpl.prototype._2 = function(){
        return this.__2;
    };
    TupleImpl.prototype.productArity = function(){
        return 2;
    };
    TupleImpl.prototype.productElement = function(index){
        switch(index) {
            case 0: return this._1();
            case 1: return this._2();
            default: throw new funk.error.RangeError();
        }
    };
    TupleImpl.prototype.name = "Tuple2";
    return TupleImpl;
})();

funk.tuple.tuple2 = function(_1, _2){
    return new funk.tuple.Tuple2(_1, _2);
};

// Alias
var tuple2 = funk.tuple.tuple2;