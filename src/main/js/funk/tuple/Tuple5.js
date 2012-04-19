funk.tuple = funk.tuple || {};
funk.tuple.Tuple5 = (function(){
    "use strict";
    var TupleImpl = function(_1, _2, _3, _4, _5){
        this.__1 = _1;
        this.__2 = _2;
        this.__3 = _3;
        this.__4 = _4;
        this.__5 = _5;
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
    TupleImpl.prototype._4 = function(){
        return this.__4;
    };
    TupleImpl.prototype._5 = function(){
        return this.__5;
    };
    TupleImpl.prototype.productArity = function(){
        return 5;
    };
    TupleImpl.prototype.productElement = function(index){
        switch(index) {
            case 0: return this._1();
            case 1: return this._2();
            case 2: return this._3();
            case 3: return this._4();
            case 4: return this._5();
            default: throw new funk.error.RangeError();
        }
    };
    TupleImpl.prototype.productPrefix = function(){
        return "Tuple5";
    };
    TupleImpl.prototype.name = "Tuple5";
    return TupleImpl;
})();

funk.tuple.tuple5 = function(_1, _2, _3, _4, _5){
    return new funk.tuple.Tuple5(_1, _2, _3, _4, _5);
};

// Alias
var tuple5 = funk.tuple.tuple5;