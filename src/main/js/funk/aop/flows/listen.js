funk.aop = funk.aop || {};
funk.aop.flows = funk.aop.flows || {};
funk.aop.flows.__listens__ = funk.collection.immutable.nil();
funk.aop.flows.listen = function(source, method){
    "use strict";

    // See if it's already been cached
    var signal = null,
        p = funk.aop.flows.__listens__;
    while(p.nonEmpty()) {
        signal = when(p.head(), {
            none: function(){
                return null;
            },
            some: function(value){
                // locate the source
                if(value._1() === source && value._2() === method) {
                    return value._3();
                }
                return null;
            }
        });
        if(funk.isValid(signal)) {
            return signal;
        }
        p = p.tail().get();
    }

    // Setup the binding after the method call
    signal = new funk.signals.Signal(String, Array, Object);
    var slot = funk.aop.after(source, method, function(method, args, returnValue){
        signal.dispatch(method, args, returnValue);
        return returnValue;
    });
    // Add the items to the tuple
    var tuple = funk.tuple.tuple3(source, method, signal);
    funk.aop.flows.__listens__ = funk.aop.flows.__listens__.prepend(tuple);
    return funk.tuple.tuple2(slot, signal);
};