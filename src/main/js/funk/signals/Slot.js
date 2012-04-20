funk.signals = funk.signals || {};
funk.signals.Slot = (function(){
    var verifyListener = function(slot, listener){
        if(!funk.isValid(listener)) {
            throw new funk.error.ArgumentError('Given listener is null.');
        }

        if(!funk.isValid(slot._signal)) {
            throw new funk.error.IllegalByDefinitionError('Internal signal reference has not been set yet.');
        }
        return listener;
    };

    var SlotImpl = function(signal, listener, scope, once){
        this._signal = signal;
        this._listener = verifyListener(this, listener);
        this._scope = funk.isDefined(scope) ? scope : null;
        this._once = once;
        this._enabled = true;
        this._params = null;
    };
    SlotImpl.prototype = new funk.Product();
    SlotImpl.prototype.constructor = SlotImpl;
    SlotImpl.prototype.name = "Slot";
    SlotImpl.prototype.execute = function(valueObjects){
        if(!this._enabled){
            return;
        }
        if(this._once){
            this.remove();
        }

        var values = valueObjects;
        if(funk.isValid(this._params) && this._params.length) {
            values = valueObjects.concat(this._params);
        }
        this._listener.apply(this._scope, values);
    };
    SlotImpl.prototype.remove = function(){
        this._signal.remove(this._listener);
    };
    SlotImpl.prototype.signal = function(){
        return this._signal;
    };
    SlotImpl.prototype.listener = function(){
        return this._listener;
    };
    SlotImpl.prototype.setListener = function(value){
        this._listener = verifyListener(this, value);
    };
    SlotImpl.prototype.scope = function(){
        return this._scope;
    };
    SlotImpl.prototype.once = function(){
        return this._once;
    };
    SlotImpl.prototype.getEnabled = function(){
        return this._enabled;
    };
    SlotImpl.prototype.setEnabled = function(value){
        this._enabled = !!value;
    }
    SlotImpl.prototype.params = function(value){
        if(funk.isDefined(value)) {
            this._params = value;
        }
        return this._params;
    };
    SlotImpl.prototype.productArity = function(){
        return 1;
    };
    SlotImpl.prototype.productElement = function(index){
        funk.util.requireRange(index, this.productArity());
        return this._listener;
    };
    SlotImpl.prototype.productPrefix = function(){
        return "Slot";
    };
    return SlotImpl;
})();