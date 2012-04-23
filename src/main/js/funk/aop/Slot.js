funk.aop = funk.aop || {};
funk.aop.Slot = (function(){
    var SlotImpl = function(result, source, method, current){
        funk.Product.call(this);

        this._result = result;
        this._source = source;
        this._method = method;
        this._current = current;
    };
    SlotImpl.prototype = new funk.Product();
    SlotImpl.prototype.constructor = SlotImpl;
    SlotImpl.prototype.name = "Slot";
    SlotImpl.prototype.result = function(){
        return this._result;
    };
    SlotImpl.prototype.source = function(){
        return this._source;
    };
    SlotImpl.prototype.method = function(){
        return this._method;
    };
    SlotImpl.prototype.current = function(){
        return this._current;
    };
    SlotImpl.prototype.remove = function(){
        this._source[this._method] = this._current;
    };
    SlotImpl.prototype.productArity = function(){
        return 1;
    };
    SlotImpl.prototype.productElement = function(index){
        funk.util.requireRange(index, this.productArity());
        return this._method;
    };
    SlotImpl.prototype.productPrefix = function(){
        return "Slot";
    };
    return SlotImpl;
})();