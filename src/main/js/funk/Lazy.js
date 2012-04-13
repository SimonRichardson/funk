funk.Lazy = (function(){
    "use strict";
    var LazyImpl = function(func, scope, args) {
        this._func = func;
        this._scope = scope;
        this._args = funk.toArray(args);
        this._evaluated = false;
        this._value = null;
    };
    LazyImpl.prototype = {};
    LazyImpl.prototype.constructor = LazyImpl;
    LazyImpl.prototype.get = function() {
        if(!this._evaluated){
            this._value = this._func.apply(this._scope, this._args);
            this._evaluated = true;

            this._func = null;
            this._scope = null;
            this._args = null;
        }
        return this._value;
    };
    LazyImpl.prototype.toString = function() {
        return "Lazy(" + (this._value === null ? "" : this._value) + ")";
    };
    LazyImpl.prototype.name = "Lazy";
    return LazyImpl;
})();

function lazy(func, scope, args) {
    return new funk.Lazy(func, scope, args);
};