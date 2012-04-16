funk.Wildcard = (function(){
    "use strict";
    var WildcardImpl = function(){
    };
    WildcardImpl.prototype = {};
    WildcardImpl.prototype.constructor = WildcardImpl;
    WildcardImpl.prototype.name = "Wildcard";
    // TODO (Simon) Implement Proxies when they're avaiable in Chrome.
    WildcardImpl.prototype.invoke = function(name) {
        var args = funk.toArray(arguments);
        args.shift();

        if(funk.has(this, name)) {
            // Invoke wildcard methods over object methods
            return this[name].apply(this, args);
        } else {
            return function(x) {
                if(!funk.has(x, name)) {
                    throw new funk.error.TypeError("No such method " + name);
                }

                var innerArgs = funk.toArray(arguments);
                innerArgs.shift();

                return x[name].apply(x, args.concat(innerArgs));
            };
        }
    };
    WildcardImpl.prototype.binaryNot = function(value) {
        return ~funk.option.toValue(value);
    };
    WildcardImpl.prototype.decrementBy = function(value) {
        var v = funk.option.toValue(value);
        return function(x){
            return funk.option.toValue(x) - value;
        };
    };
    WildcardImpl.prototype.divideBy = function(value) {
        var v = funk.option.toValue(value);
        return function(x){
            return funk.option.toValue(x) / v;
        };
    };
    WildcardImpl.prototype.equals = function(value) {
        var v = funk.option.toValue(value);
        return function(x){
            return funk.util.eq(funk.option.toValue(x), v);
        };
    };
    WildcardImpl.prototype.get = function(name) {
        return function(x) {
            return x[name];
        };
    };
    WildcardImpl.prototype.greaterThan = function(value) {
        var v = funk.option.toValue(value);
        return function(x){
            return funk.option.toValue(x) > v;
        };
    };
    WildcardImpl.prototype.greaterThanEqual = function(value) {
        var v = funk.option.toValue(value);
        return function(x){
            return funk.option.toValue(x) >= v;
        };
    };
    WildcardImpl.prototype.incrementBy = function(value) {
        var v = funk.option.toValue(value);
        return function(x){
            return funk.option.toValue(x) + v;
        };
    };
    WildcardImpl.prototype.inRange = function(minValue, maxValue) {
        return function(x){
            var v = funk.option.toValue(x);
            return v >= minValue && v <= maxValue;
        };
    };
    WildcardImpl.prototype.isEven = function() {
        return function(x){
            var v = funk.option.toValue(x);
            var asInt = Math.floor(v);

            if(0 != (v - asInt)) {
                return false;
            }

            return (asInt & 1) == 0;
        };
    };
    WildcardImpl.prototype.isOdd = function(value) {
        return function(x){
            var v = funk.option.toValue(x);
            var asInt = Math.floor(v);

            if(0 != (v - asInt)) {
                return false;
            }

            return (asInt & 1) != 0;
        };
    };
    WildcardImpl.prototype.lessThan = function(value) {
        var v = funk.option.toValue(value);
        return function(x){
            return funk.option.toValue(x) < v;
        };
    };
    WildcardImpl.prototype.lessThanEqual = function(value) {
        var v = funk.option.toValue(value);
        return function(x){
            return funk.option.toValue(x) <= v;
        };
    };
    WildcardImpl.prototype.moduloBy = function(value) {
        var v = funk.option.toValue(value);
        return function(x){
            return funk.option.toValue(x) % v;
        };
    };
    WildcardImpl.prototype.multiplyBy = function(value) {
        var v = funk.option.toValue(value);
        return function(x){
            return funk.option.toValue(x) * v;
        };
    };
    WildcardImpl.prototype.not = function(value){
        return !funk.option.toValue(value);
    };
    WildcardImpl.prototype.toBoolean = function(value) {
        return funk.option.toValue(value) ? true : false;
    };
    WildcardImpl.prototype.toLowerCase = function(value) {
        var v = funk.option.toValue(value);
        return ("string" === typeof v) ? v.toLowerCase() : ("" + v).toLowerCase();
    };
    WildcardImpl.prototype.toString = function(value) {
        var v = funk.option.toValue(value);
        return ("string" === typeof v) ? v : ("" + v);
    };
    WildcardImpl.prototype.toUpperCase = function(value) {
        var v = funk.option.toValue(value);
        return ("string" === typeof v) ? v.toUpperCase() : ("" + v).toUpperCase();
    };
    WildcardImpl.prototype.toList = function(value) {
        var v = funk.option.toValue(value);
        return funk.collection.toList(v);
    };
    WildcardImpl.prototype.plus_ = function(a, b){
        return a + b;
    };
    WildcardImpl.prototype.minus_ = function(a, b){
        return a - b;
    };
    WildcardImpl.prototype.multiply_ = function(a, b){
        return a * b;
    };
    WildcardImpl.prototype.divide_ = function(a, b){
        return a / b;
    };
    WildcardImpl.prototype.modulo_ = function(a, b){
        return a % b;
    };
    WildcardImpl.prototype.lessThan_ = function(a, b){
        return a < b;
    };
    WildcardImpl.prototype.lessThanEqual_ = function(a, b){
        return a <= b;
    };
    WildcardImpl.prototype.greaterThan_ = function(a, b){
        return a > b;
    };
    WildcardImpl.prototype.greaterThanEqual_ = function(a, b){
        return a >= b;
    };
    WildcardImpl.prototype.equal_ = function(a, b){
        return funk.util.eq(a, b);
    };
    WildcardImpl.prototype.notEqual_ = function(a, b){
        return funk.util.ne(a, b);
    };
    WildcardImpl.prototype.strictlyEqual_ = function(a, b){
        return a === b;
    };
    WildcardImpl.prototype.strictlyNotEqual_ = function(a, b){
        return a !== b;
    };
    WildcardImpl.prototype.binaryAnd_ = function(a, b){
        return a & b;
    };
    WildcardImpl.prototype.binaryOr_ = function(a, b){
        return a | b;
    };
    WildcardImpl.prototype.binaryXor_ = function(a, b){
        return a ^ b;
    };

    return WildcardImpl;
})();

funk.WILDCARD = new funk.Wildcard();

// Alias
var _ = wildcard = funk.WILDCARD;