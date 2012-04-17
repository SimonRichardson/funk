funk.signals = funk.signals || {};
funk.signals.Slot = (function(){
    var verifyListener = function(slot, listener){
        if(!funk.isDefined(listener)) {
            throw new funk.error.ArgumentError('Given listener is null.');
        }

        if(!funk.isDefined(slot._signal)) {
            throw new funk.error.IllegalByDefinitionError('Internal signal reference has not been set yet.');
        }
    };

    var SlotImpl = function(signal, listener, scope, once){
        this._signal = signal;
        this._listener = listener;
        this._scope = funk.isDefined(scope) ? scope : null;
        this._once = once;
        this._enabled = true;
        this._params = null;

        verifyListener(this, listener);
    };
    SlotImpl.prototype = {};
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
        if(funk.isDefined(this._params) && this._params.length) {
            values = valueObjects.concat(this._params);
        }

        this._listener.apply(this._scope, [funk.tuple.tuple(values)]);
    };
    SlotImpl.prototype.remove = function(){
        this._signal.remove(this._listener);
    };
    SlotImpl.prototype.signal = function(){
        return this._signal;
    };
    SlotImpl.prototype.listener = function(value){
        if(funk.isDefined(value)){
            verifyListener(this, value);
            this._listener = value;
        }
        return this._listener;
    };
    SlotImpl.prototype.scope = function(){
        return this._scope;
    };
    SlotImpl.prototype.once = function(){
        return this._once;
    };
    SlotImpl.prototype.enabled = function(value){
        if(funk.isDefined(value)) {
            this._enabled = value;
        }
        return this._enabled;
    };
    SlotImpl.prototype.params = function(value){
        if(funk.isDefined(value)) {
            this._params = value;
        }
        return this._params;
    };
    return SlotImpl;
})();