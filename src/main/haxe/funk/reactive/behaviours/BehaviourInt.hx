package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.extensions.Behaviours;
import funk.reactive.extensions.Propagations;
import funk.reactive.extensions.Streams;
import funk.reactive.streams.StreamBool;
import funk.signal.Signal0;
import funk.types.Tuple2;
import funk.types.extensions.Tuples2;

using funk.reactive.extensions.Streams;
using funk.reactive.extensions.Behaviours;
using funk.reactive.streams.StreamBool;
using funk.types.extensions.Tuples2;

class BehaviourInt {

	public static function plus(behaviour0 : Behaviour<Int>, behaviour1 : Behaviour<Int>) : Behaviour<Int> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return tuple._1() + tuple._2();
        });
    }

    public static function minus(behaviour0 : Behaviour<Int>, behaviour1 : Behaviour<Int>) : Behaviour<Int> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return tuple._1() - tuple._2();
        });
    }

    public static function multiply(behaviour0 : Behaviour<Int>, behaviour1 : Behaviour<Int>) : Behaviour<Int> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return Std.int(tuple._1() * tuple._2());
        });
    }

    public static function modulo(behaviour0 : Behaviour<Int>, behaviour1 : Behaviour<Int>) : Behaviour<Int> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return Std.int(tuple._1() % tuple._2());
        });
    }

    public static function divide(behaviour0 : Behaviour<Int>, behaviour1 : Behaviour<Int>) : Behaviour<Int> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return Std.int(tuple._1() / tuple._2());
        });
    }
}
