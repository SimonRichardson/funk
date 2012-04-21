funk.aop = funk.aop || {};
funk.aop.Aspect = (function(){
    "use strict";
    var AspectImpl = function(){

    };
    AspectImpl.prototype = {};
    AspectImpl.prototype.constructor = AspectImpl;
    AspectImpl.add = function(type, pointer, method, func){
        var source = funk.has(pointer, 'prototype') ? pointer.prototype : pointer;
        if(funk.has(source, method)) {
            var current = source[method];

            if(!funk.isFunction(current)) {
                throw new funk.aop.error.AspectError("Unable to bind to " + method);
            }

            var aspect;
            if(type.equals(AspectType.AFTER) ||
                type.equals(AspectType.AFTER_THROW) ||
                type.equals(AspectType.AFTER_FINALLY)) {
                aspect = function(){
                    var returnValue,
                        exceptionThrown = null,
                        finallyCalled = false;

                    try {
                        returnValue = current.apply(this, arguments);
                    } catch(e) {
                        exceptionThrown = e;
                    } finally {
                        finallyCalled = true;
                    }

                    if(type.equals(AspectType.AFTER)) {
                        if(funk.isValid(exceptionThrown)) {
                            throw exceptionThrown;
                        } else {
                            returnValue = func.apply(this, [method, returnValue]);
                        }
                    } else if(type.equals(AspectType.AFTER_THROW)) {
                        if(funk.isValid(exceptionThrown)) {
                            returnValue = func.apply(this, [method, exceptionThrown]);
                        }
                    } else if(type.equals(AspectType.AFTER_FINALLY)) {
                        if(finallyCalled) {
                            returnValue = func.apply(this, [method, exceptionThrown, returnValue]);
                        }
                    }

                    return returnValue;
                };
            } else if(type.equals(AspectType.AROUND)) {
                aspect = function(){
                    var invocation = {source: source, args: funk.toArray(arguments)};
                    return func.apply(this, [method, invocation, function(){
                        return current.apply(this, invocation.args);
                    }]);
                };
            } else if(type.equals(AspectType.BEFORE)) {
                aspect = function(){
                    func.apply(this, [method, arguments]);
                    return current.apply(this, arguments);
                };
            }

            aspect.remove = function(){
                source[method] = current;
            };

            source[method] = aspect;

            return aspect;
        }

        throw new funk.error.NoSuchMethodError();
    };
    return AspectImpl;
})();

// Alias
var Aspect = funk.aop.Aspect;