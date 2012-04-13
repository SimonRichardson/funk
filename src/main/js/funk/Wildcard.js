funk.Wildcard = (function(){
    "use strict";
    var WildcardImpl = function(){
    };
    WildcardImpl.prototype = {};
    WildcardImpl.prototype.constructor = WildcardImpl;
    // TODO (Simon) Implement Proxies when they're avaiable in Chrome.
    WildcardImpl.prototype.invoke = function(name) {
        var args = funk.toArray(arguments);
        args.shift();

        return function(x) {
            return x[name].apply(x, args);
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
    return WildcardImpl;
})();

funk.WILDCARD = new funk.Wildcard();

// Alias
var _ = wildcard = funk.WILDCARD;