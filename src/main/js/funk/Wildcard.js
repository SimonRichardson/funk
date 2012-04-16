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
            return function(x){
                var innerArgs = funk.toArray(arguments);
                innerArgs.shift();

                return this[name].apply(x, args.concat(innerArgs));
            }
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
        return ~value;
    };
    WildcardImpl.prototype.decrementBy = function(value) {
        return function(x){
            return x - value;
        };
    };
    WildcardImpl.prototype.divideBy = function(value) {
        return function(x){
            return x / value;
        };
    };
    WildcardImpl.prototype.equals = function(value) {
        return function(x){
            return funk.util.eq(x, value);
        };
    };
    WildcardImpl.prototype.get = function(name) {
        return function(x) {
            return x[name];
        };
    };
    WildcardImpl.prototype.greaterThan = function(value) {
        return function(x){
            return x > value;
        };
    };
    WildcardImpl.prototype.greaterThanEqual = function(value) {
        return function(x){
            return x >= value;
        };
    };
    WildcardImpl.prototype.incrementBy = function(value) {
        return function(x){
            return x + value;
        };
    };
    WildcardImpl.prototype.inRange = function(minValue, maxValue) {
        return function(x){
            return x >= minValue && x <= maxValue;
        };
    };
    WildcardImpl.prototype.isEven = function(value) {
        var asInt = Math.floor(value);

        if(0 != (value - asInt)) {
            return false;
        }

        return (asInt & 1) == 0;
    };
    WildcardImpl.prototype.isOdd = function(value) {
        var asInt = Math.floor(value);

        if(0 != (value - asInt)) {
            return false;
        }

        return (asInt & 1) != 0;
    };
    WildcardImpl.prototype.lessThan = function(value) {
        return function(x){
            return x < value;
        };
    };
    WildcardImpl.prototype.lessThanEqual = function(value) {
        return function(x){
            return x <= value;
        };
    };
    WildcardImpl.prototype.moduloBy = function(value) {
        return function(x){
            return x % value;
        };
    };
    WildcardImpl.prototype.multiplyBy = function(value) {
        return function(x){
            return x * value;
        };
    };
    WildcardImpl.prototype.not = function(value){
        return !value;
    };
    WildcardImpl.prototype.toBoolean = function(value) {
        return value ? true : false;
    };
    WildcardImpl.prototype.toLowerCase = function(value) {
        return ("string" === typeof value) ? value.toLowerCase() : ("" + value).toLowerCase();
    };
    WildcardImpl.prototype.toString = function(value) {
        return ("string" === typeof value) ? value : ("" + value);
    };
    WildcardImpl.prototype.toUpperCase = function(value) {
        return ("string" === typeof value) ? value.toUpperCase() : ("" + value).toUpperCase();
    };
    WildcardImpl.prototype.toList = function(value) {
        return funk.collection.toList(value);
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