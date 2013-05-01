package funk.reactives;

import funk.types.Function1;
import funk.types.extensions.EnumValues;

enum Pulse<T> {
    Pulse(time : Float, value : T);
}

class PulseTypes {

    public static function time<T>(pulse : Pulse<T>) : Float return EnumValues.getValueByIndex(pulse, 0);

    public static function value<T>(pulse : Pulse<T>) : T return EnumValues.getValueByIndex(pulse, 1);

    public static function map<T, E>(pulse : Pulse<T>, func : Function1<T, E>) : Pulse<E> {
        return withValue(pulse, func(value(pulse)));
    }

    public static function withValue<T, E>(pulse : Pulse<T>, value : E) : Pulse<E> {
        return Pulse(time(pulse), value);
    }
}
