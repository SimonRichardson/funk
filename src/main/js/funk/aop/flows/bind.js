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
                if(funk.util.eq(value._1(), source0) && funk.util.eq(value._2(), source1)) {
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

    // Two way bind.
    signal = new funk.signals.Signal(funk.tuple.Tuple, Object);

    var target0 = source0._1();
    var method0 = source0._2();

    var target1 = source1._1();
    var method1 = source1._2();


    var signal0 = funk.aop.flows.listen(target0, method0);
    var slot0 = signal0.add(function(method, args, returnValue){
        slot0.setEnabled(false);
        slot1.setEnabled(false);

        var pointer = target1[method1];
        if(funk.isFunction(pointer)) {
            pointer.apply(target1, [returnValue]);
        }

        signal.dispatch(source0, returnValue);

        slot0.setEnabled(true);
        slot1.setEnabled(true);

        return returnValue;
    });

    var signal1 = funk.aop.flows.listen(target1, method1);
    var slot1 = signal1.add(function(method, args, returnValue){
        slot0.setEnabled(false);
        slot1.setEnabled(false);

        var pointer = target0[method0];
        if(funk.isFunction(pointer)) {
            pointer.apply(target0, [returnValue]);
        }

        signal.dispatch(source1, returnValue);

        slot0.setEnabled(true);
        slot1.setEnabled(true);

        return returnValue;
    });

    // Add the items to the tuple
    var tuple = funk.tuple.tuple3(source0, source1, signal);
    funk.aop.flows.__binds__ = funk.aop.flows.__binds__.prepend(tuple);
    return signal;
};