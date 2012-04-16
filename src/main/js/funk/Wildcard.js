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

        var scope = this;
        if(funk.has(scope, name)) {
            // Invoke wildcard methods over object methods
            if(args.length > 0) {
                return scope[name].apply(scope, args);
            } else {
                return function(){
                    return scope[name].apply(scope, funk.toArray(arguments));
                };
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
    WildcardImpl.prototype.isEven = function(x) {
        var v = funk.option.toValue(x);
        var asInt = Math.floor(v);

        if(0 != (v - asInt)) {
            return false;
        }

        return (asInt & 1) == 0;
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
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 + b0;
    };
    WildcardImpl.prototype.minus_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 - b0;
    };
    WildcardImpl.prototype.multiply_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 * b0;
    };
    WildcardImpl.prototype.divide_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 / b0;
    };
    WildcardImpl.prototype.modulo_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 % b0;
    };
    WildcardImpl.prototype.lessThan_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 < b0;
    };
    WildcardImpl.prototype.lessThanEqual_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 <= b0;
    };
    WildcardImpl.prototype.greaterThan_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 > b0;
    };
    WildcardImpl.prototype.greaterThanEqual_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 >= b0;
    };
    WildcardImpl.prototype.equal_ = function(a, b){
        return funk.util.eq(a, b);
    };
    WildcardImpl.prototype.notEqual_ = function(a, b){
        return funk.util.ne(a, b);
    };
    WildcardImpl.prototype.strictlyEqual_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 === b0;
    };
    WildcardImpl.prototype.strictlyNotEqual_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 !== b0;
    };
    WildcardImpl.prototype.binaryAnd_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 & b0;
    };
    WildcardImpl.prototype.binaryOr_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 | b0;
    };
    WildcardImpl.prototype.binaryXor_ = function(a, b){
        var a0 = funk.option.toValue(a);
        var b0 = funk.option.toValue(b);
        return a0 ^ b0;
    };

    return WildcardImpl;
})();

funk.WILDCARD = new funk.Wildcard();

// Alias
var _ = wildcard = funk.WILDCARD;