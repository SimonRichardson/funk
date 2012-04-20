funk.signals = funk.signals || {};
funk.signals.Signal = (function(){
    var findSlot = function(slots, listener){
        var option = slots.find(function(item){
            return funk.option.when(item, {
                none: function(){
                    return false;
                },
                some: function(slot){
                    return funk.util.eq(slot.listener(), listener);
                }
            });
        });
        return funk.option.when(option, {
            none: function(){
                return null;
            },
            some: function(slot){
                return slot;
            }
        });
    };
    var registerListener = function(signal, listener, scope, once){
        if(funk.isValid(listener)) {
            if(!funk.isFunction(listener)) {
                throw new funk.error.ArgumentError("Listener has to be null");
            }

            once = funk.isValid(once) ? once : false;

            if(registrationPossible(signal, listener, scope, once)) {
                var slot = new funk.signals.Slot(signal, listener, scope, once);
                signal._slots = signal._slots.prepend(slot);
                return slot;
            }

            return findSlot(signal._slots, listener);
        } else {
            throw new funk.error.ArgumentError("Listener can not be null");
        }
    };
    var registrationPossible = function(signal, listener, scope, once) {
        if(!signal._slots.nonEmpty()) {
            return true;
        } else {
            var slot = findSlot(signal._slots, listener);
            if(!funk.isValid(slot)) {
                return true;
            }
            console.log(slot);
            if(slot.once() != once){
                throw new funk.error.IllegalByDefinitionError();
            }
            return false;
        }
    };

    var SignalImpl = function(){
        funk.Product.call(this);

        this._slots = funk.collection.immutable.nil();
        this._valueClasses = funk.toArray(arguments);
    };
    SignalImpl.prototype = new funk.Product();
    SignalImpl.prototype.constructor = SignalImpl;
    SignalImpl.prototype.name = "Signal";
    SignalImpl.prototype.add = function(listener){
        registerListener(this, listener);
    };
    SignalImpl.prototype.addOnce = function(listener){
        registerListener(this, listener, true);
    };
    SignalImpl.prototype.remove = function(listener){
        var slot = findSlot(this._slots, listener);

        if(funk.isDefined(slot)){
            this._slots = this._slots.filterNot(slot);
            return funk.option.some(slot);
        }

        return funk.option.none();
    };
    SignalImpl.prototype.removeAll = function(){
        this._slots = funk.collection.immutable.nil();
    };
    SignalImpl.prototype.dispatch = function(){
        var valueObjects = funk.toArray(arguments);

        var numValueClasses = this._valueClasses.length;
        var numValueObjects = valueObjects.length;
        if(numValueObjects < numValueClasses) {
            throw new funk.error.ArgumentError('Incorrect number of arguments. ' +
                'Expected at least ' + numValueClasses + ' but received ' +
                numValueObjects + '.');
        }

        for(var i=0; i<numValueClasses; ++i){
            if(valueObjects === null || funk.util.verifiedType(valueObjects[i], this._valueClasses[i])) {
                continue;
            }

            throw new funk.error.ArgumentError('Value object <' + valueObjects[i]
                + '> is not an instance of <' + this._valueClasses[i] + '>.');
        }

        var p = this._slots;
        if(p.nonEmpty()) {
            while(p.nonEmpty()) {
                when(p.head(), {
                    some: function(value){
                        value.execute(valueObjects);
                    }
                });
                p = p.tail();
            }
        }
    };
    SignalImpl.prototype.size = function(){
        return this._slots.size();
    };
    SignalImpl.prototype.valueClasses = function(){
        return this._valueClasses;
    };
    SignalImpl.prototype.productArity = function(){
        return this._valueClasses.length;
    };
    SignalImpl.prototype.productElement = function(index){
        funk.util.requireRange(index, this.productArity());
        return this._valueClasses[index];
    };
    SignalImpl.prototype.productPrefix = function(){
        return "Signal";
    };
    return SignalImpl;
})();