funk.aop = funk.aop || {};
funk.aop.flows = funk.aop.flows || {};
funk.aop.flows.__binds__ = funk.collection.immutable.nil();
funk.aop.flows.bind = function(source, method){
    var p = funk.aop.flows.__binds__;
    while(p.nonEmpty()) {
        var signal = when(p.head(), {
            none: function(){
                return null;
            },
            some: function(value){
                // locate the source
                if(value._1 === source && value._2 === method) {
                    return value._3;
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
    var signal = new funk.signals.Signal();
    funk.aop.after(source, method, function(method, args){
        signal.dispatch.apply(signal, args);
    });
    // Add the items to the tuple
    var tuple = funk.tuple.tuple3(source, method, signal);
    funk.aop.flows.__binds__ = funk.aop.flows.__binds__.prepend(tuple);
    return signal;
};