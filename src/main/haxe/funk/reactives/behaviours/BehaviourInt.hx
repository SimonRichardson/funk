package funk.reactives.behaviours;

import funk.Funk;
import funk.reactives.Behaviour;
import funk.reactives.Propagation;
import funk.reactives.streams.StreamBool;
import funk.types.Tuple1;

using funk.reactives.Stream;
using funk.reactives.Behaviour;
using funk.reactives.streams.StreamBool;

class BehaviourInt {

    public static function plus(behaviour0 : Behaviour<Int>, behaviour1 : Behaviour<Int>) : Behaviour<Int> {
        return behaviour0.zip(behaviour1).lift(function(tuple) return tuple._1() + tuple._2());
    }

    public static function minus(behaviour0 : Behaviour<Int>, behaviour1 : Behaviour<Int>) : Behaviour<Int> {
        return behaviour0.zip(behaviour1).lift(function(tuple) return tuple._1() - tuple._2());
    }

    public static function multiply(behaviour0 : Behaviour<Int>, behaviour1 : Behaviour<Int>) : Behaviour<Int> {
        return behaviour0.zip(behaviour1).lift(function(tuple) return Std.int(tuple._1() * tuple._2()));
    }

    public static function modulo(behaviour0 : Behaviour<Int>, behaviour1 : Behaviour<Int>) : Behaviour<Int> {
        return behaviour0.zip(behaviour1).lift(function(tuple) return Std.int(tuple._1() % tuple._2()));
    }

    public static function divide(behaviour0 : Behaviour<Int>, behaviour1 : Behaviour<Int>) : Behaviour<Int> {
        return behaviour0.zip(behaviour1).lift(function(tuple) return Std.int(tuple._1() / tuple._2()));
    }
}
