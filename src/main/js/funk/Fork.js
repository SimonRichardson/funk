funk.Fork = (function(){
    "use strict";
    var ForkImpl = function(func, scope, args) {
        this._func = func;
        this._scope = scope;
        this._args = funk.toArray(args);
    };
    ForkImpl.prototype = {};
    ForkImpl.prototype.constructor = ForkImpl;
    ForkImpl.prototype.andThen = function(func, scope, args) {
        var self = this;
        var inner = function() {
            func.apply(scope, args);
        };
        return function() {
            self._args.unshift(inner);
            var args = funk.toArray(arguments);
            setTimeout(function(){
                self._func.apply(self._scope, self._args.concat(args));
            }, 1);
        };
    };
    ForkImpl.prototype.andContinue = function(func) {
        var self = this;
        var inner = function() {
            func.apply(self._scope, funk.toArray(arguments));
        };
        return function() {
            self._args.unshift(inner);
            var args = funk.toArray(arguments);
            setTimeout(function(){
                self._func.apply(self._scope, self._args.concat(args));
            }, 1);
        };
    };
    ForkImpl.prototype.toString = function(){
        return "Fork";
    };
    ForkImpl.prototype.name = "Fork";
    return ForkImpl;
})();

function fork(func, scope, args){
    return new funk.Fork(func, scope, args);
};