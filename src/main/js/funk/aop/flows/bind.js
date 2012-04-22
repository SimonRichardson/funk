funk.aop = funk.aop || {};
funk.aop.flows = funk.aop.flows || {};
funk.aop.flows.__binds__ = funk.collection.immutable.nil();
funk.aop.flows.bind = function(source0, source1){
    "use strict";

    // See if it's already been cached
    var signal = null,
        p = funk.aop.flows.__binds__;
    while(p.nonEmpty()) {
        signal = when(p.head(), {
            none: function(){
                return null;
            },
            some: function(value){
                // locate the source
                if(funk.util.eq(value._1, source0) && funk.util.eq(value._2, source1)) {
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

    // Two way bind.
    signal = new funk.signals.Signal(Object, Object);
    var signal0 = funk.aop.flows.listen(source0._1, source0._2);
    signal0.add(function(method, args, returnValue){
        signal1.setEnabled(false);
        source1._1[source1._2](returnValue);
        signal1.setEnabled(true);

        signal.dispatch(source0, returnValue);
    });
    var signal1 = funk.aop.flows.listen(source1._1, source1._2);
    signal1.add(function(method, args, returnValue){
        signal0.setEnabled(false);
        source0._1[source0._2](returnValue);
        signal0.setEnabled(true);

        signal.dispatch(source1, returnValue);
    });

    // Add the items to the tuple
    var tuple = funk.tuple.tuple3(source0, source1, signal);
    funk.aop.flows.__binds__ = funk.aop.flows.__binds__.prepend(tuple);
    return signal;
};