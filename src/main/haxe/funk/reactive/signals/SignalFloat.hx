package funk.reactive.signals;

import funk.reactive.Signal;

class SignalFloat {

	public static function plus(signal0 : Signal<Float>, signal1 : Signal<Float>) : Signal<Float> {
        return signal0.zip(signal1).map(function(tuple) {
        	return tuple._1 + tuple._2;
        });
    }

    public static function minus(signal0 : Signal<Float>, signal1 : Signal<Float>) : Signal<Float> {
        return signal0.zip(signal1).map(function(tuple) {
        	return tuple._1 - tuple._2;
        });
    }

    public static function multiply(    signal0 : Signal<Float>,
                                        signal1 : Signal<Float>) : Signal<Float> {
        return signal0.zip(signal1).map(function(tuple) {
        	return tuple._1 * tuple._2;
        });
    }

    public static function modulo(  signal0 : Signal<Float>,
                                    signal1 : Signal<Float>) : Signal<Float> {
        return signal0.zip(signal1).map(function(tuple) {
        	return tuple._1 % tuple._2;
        });
    }

    public static function divide(  signal0 : Signal<Float>,
                                    signal1 : Signal<Float>) : Signal<Float> {
        return signal0.zip(signal1).map(function(tuple) {
        	return tuple._1 / tuple._2;
        });
    }
}
