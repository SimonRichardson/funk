funk.aop = funk.aop || {};
funk.aop.Aspect = (function(){
    "use strict";
    var lock = true;
    var aspect = null;
    var AspectImpl = function(){
        if(lock){
            funk.util.isAbstract();
        } else {
            this._slots = funk.collection.immutable.nil();
        }
    };
    AspectImpl.prototype = {};
    AspectImpl.prototype.constructor = AspectImpl;
    AspectImpl.add = function(type, pointer, method, func){
        var source = funk.has(pointer, 'prototype') ? pointer.prototype : pointer;
        if(funk.has(source, method)) {
            var origin = source[method];

            if(!funk.isFunction(origin)) {
                throw new funk.aop.error.AspectError("Unable to bind to " + method);
            }

            var result;
            if(type.equals(AspectType.AFTER) ||
                type.equals(AspectType.AFTER_THROW) ||
                type.equals(AspectType.AFTER_FINALLY)) {
                result = function(){
                    var returnValue,
                        exceptionThrown = null,
                        finallyCalled = false;

                    var a = funk.toArray(arguments);
                    try {
                        returnValue = origin.apply(this, a);
                    } catch(e) {
                        exceptionThrown = e;
                    } finally {
                        finallyCalled = true;
                    }

                    if(type.equals(AspectType.AFTER)) {
                        if(funk.isValid(exceptionThrown)) {
                            throw exceptionThrown;
                        } else {
                            returnValue = func.apply(this, [result, a, returnValue]);
                        }
                    } else if(type.equals(AspectType.AFTER_THROW)) {
                        if(funk.isValid(exceptionThrown)) {
                            returnValue = func.apply(this, [result, a, exceptionThrown]);
                        }
                    } else if(type.equals(AspectType.AFTER_FINALLY)) {
                        if(finallyCalled) {
                            returnValue = func.apply(this, [result, a, exceptionThrown, returnValue]);
                        }
                    }

                    return returnValue;
                };
            } else if(type.equals(AspectType.AROUND)) {
                result = function(){
                    var invocation = {source: source, args: funk.toArray(arguments)};
                    return func.apply(this, [result, invocation, function(){
                        return origin.apply(this, invocation.args);
                    }]);
                };
            } else if(type.equals(AspectType.BEFORE)) {
                result = function(){
                    var a = funk.toArray(arguments);
                    func.apply(this, [result, a]);
                    return origin.apply(this, a);
                };
            }

            // Patch the method
            source[method] = result;

            var slot = new funk.aop.Slot(result, source, method, origin);
            aspect._slots = aspect._slots.prepend(slot);
            return slot;
        }

        throw new funk.error.NoSuchMethodError();
    };
    AspectImpl.removeAll = function(){
        var p = aspect._slots;
        while(p.nonEmpty()) {
            when(p.head(), {
                some: function(value){
                    var slot = funk.util.verifiedType(value, funk.aop.Slot);
                    slot.remove();
                }
            });
            p = p.tail().get();
        }
        aspect._aspects = funk.collection.immutable.nil();
    };
    // Create a new instance
    lock = false;
    aspect = new AspectImpl();
    lock = true;
    // Return the aspect
    return AspectImpl;
})();

// Alias
var Aspect = funk.aop.Aspect;