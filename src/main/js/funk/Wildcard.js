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

        return function(x) {
            if(!funk.has(x, name)) {
                throw new funk.error.TypeError("No such method " + name);
            }

            var innerArgs = funk.toArray(arguments);
            innerArgs.shift();

            return x[name].apply(x, args.concat(innerArgs));
        };
    };
    WildcardImpl.prototype.get = function(name) {
        return function(x) {
            return x[name];
        };
    };
    WildcardImpl.prototype.binaryNot = function(value) {
        return ~value;
    };
    WildcardImpl.prototype.decrementBy = function(value) {
        return function(x){
            return x - value;
        };
    };
    WildcardImpl.prototype.plus = function(a, b){
        return a + b;
    };
    WildcardImpl.prototype.minus = function(a, b){
        return a - b;
    };
    WildcardImpl.prototype.multiply = function(a, b){
        return a * b;
    };
    WildcardImpl.prototype.divide = function(a, b){
        return a / b;
    };
    WildcardImpl.prototype.modulo = function(a, b){
        return a % b;
    };
    WildcardImpl.prototype.lessThan = function(a, b){
        return a < b;
    };
    WildcardImpl.prototype.lessThanEqual = function(a, b){
        return a <= b;
    };
    WildcardImpl.prototype.greaterThan = function(a, b){
        return a > b;
    };
    WildcardImpl.prototype.greaterThanEqual = function(a, b){
        return a >= b;
    };
    WildcardImpl.prototype.equal = function(a, b){
        return funk.util.eq(a, b);
    };
    WildcardImpl.prototype.notEqual = function(a, b){
        return funk.util.ne(a, b);
    };
    WildcardImpl.prototype.strictlyEqual = function(a, b){
        return a === b;
    };
    WildcardImpl.prototype.strictlyNotEqual = function(a, b){
        return a !== b;
    };
    WildcardImpl.prototype.binaryAnd = function(a, b){
        return a & b;
    };
    WildcardImpl.prototype.binaryOr = function(a, b){
        return a | b;
    };
    WildcardImpl.prototype.binaryXor = function(a, b){
        return a ^ b;
    };
    return WildcardImpl;
})();

funk.WILDCARD = new funk.Wildcard();

// Alias
var _ = wildcard = funk.WILDCARD;