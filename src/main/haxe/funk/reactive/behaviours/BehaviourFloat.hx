package funk.reactive.behaviours;

import funk.reactive.Behaviour;

class SignalFloat {

	public static function plus(behaviour0 : Behaviour<Float>, behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
            return tuple._1 + tuple._2;
        });
    }

    public static function minus(behaviour0 : Behaviour<Float>, behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return tuple._1 - tuple._2;
        });
    }

    public static function multiply(    behaviour0 : Behaviour<Float>,
                                        behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return tuple._1 * tuple._2;
        });
    }

    public static function modulo(  behaviour0 : Behaviour<Float>,
                                    behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return tuple._1 % tuple._2;
        });
    }

    public static function divide(  behaviour0 : Behaviour<Float>,
                                    behaviour1 : Behaviour<Float>) : Behaviour<Float> {
        return behaviour0.zip(behaviour1).lift(function(tuple) {
        	return tuple._1 / tuple._2;
        });
    }
}
