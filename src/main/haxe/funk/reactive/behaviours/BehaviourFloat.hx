package funk.reactive.behaviours;

import funk.Funk;
import funk.reactive.Behaviour;
import funk.reactive.Propagation;
import funk.reactive.streams.StreamBool;
import funk.types.Tuple1;

using funk.reactive.Stream;
using funk.reactive.Behaviour;
using funk.reactive.streams.StreamBool;

class BehaviourFloat {

	public static function plus(behaviour0 : Behaviour<Float>, behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
            return tuple._1() + tuple._2();
        });
    }

    public static function minus(behaviour0 : Behaviour<Float>, behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return tuple._1() - tuple._2();
        });
    }

    public static function multiply(    behaviour0 : Behaviour<Float>,
                                        behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return tuple._1() * tuple._2();
        });
    }

    public static function modulo(  behaviour0 : Behaviour<Float>,
                                    behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return tuple._1() % tuple._2();
        });
    }

    public static function divide(  behaviour0 : Behaviour<Float>,
                                    behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return tuple._1() / tuple._2();
        });
    }
}
