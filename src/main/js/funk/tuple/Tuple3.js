funk.tuple = funk.tuple || {};
funk.tuple.Tuple3 = (function(){
    "use strict";
    var TupleImpl = function(_1, _2, _3){
        this.__1 = _1;
        this.__2 = _2;
        this.__3 = _3;
    };
    TupleImpl.prototype = new funk.tuple.Tuple();
    TupleImpl.prototype.constructor = TupleImpl;
    TupleImpl.prototype._1 = function(){
        return this.__1;
    };
    TupleImpl.prototype._2 = function(){
        return this.__2;
    };
    TupleImpl.prototype._3 = function(){
        return this.__3;
    };
    TupleImpl.prototype.productArity = function(){
        return 3;
    };
    TupleImpl.prototype.productElement = function(index){
        switch(index) {
            case 0: return this._1();
            case 1: return this._2();
            case 2: return this._3();
            default: throw new funk.error.RangeError();
        }
    };
    TupleImpl.prototype.productPrefix = function(){
        return "Tuple3";
    };
    TupleImpl.prototype.name = "Tuple3";
    return TupleImpl;
})();

funk.tuple.tuple3 = function(_1, _2, _3){
    return new funk.tuple.Tuple3(_1, _2, _3);
};

// Alias
var tuple3 = funk.tuple.tuple3;