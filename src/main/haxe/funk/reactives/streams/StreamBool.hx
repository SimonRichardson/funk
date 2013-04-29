package funk.reactives.streams;

import funk.reactives.Propagation;
import funk.types.Option;

using funk.ds.CollectionUtil;
using funk.reactives.Pulse;
using funk.reactives.Stream;

class StreamBool {

    public static function not(stream : Stream<Bool>) : Stream<Bool> {
        return stream.map(function(value) {
            return !value;
        });
    }

    public static function and(stream0 : Stream<Bool>, stream1 : Stream<Bool>) : Stream<Bool> {
        return stream0.zipWith(stream1, function(a : Bool, b : Bool){
            return a && b;
        });
    }

    public static function or(stream0 : Stream<Bool>, stream1 : Stream<Bool>) : Stream<Bool> {
        return stream0.zipWith(stream1, function(a : Bool, b : Bool){
            return a || b;
        });
    }

    public static function ifThen<T>(stream : Stream<Bool>, block : Stream<T>) : Stream<T> {
        var time = -1.0;
        var value = false;

        StreamTypes.create(function(pulse : Pulse<Bool>) : Propagation<Bool> {
            time = pulse.time();
            value = pulse.value();

            return Negate;
        }, [stream].toCollection());

        return StreamTypes.create(function(pulse : Pulse<T>) : Propagation<T> {
            return if(value && (time == pulse.time())) {
                Propagate(pulse);
            } else {
                Negate;
            }
        }, [block].toCollection());
    }

    public static function ifThenElse<T>(    stream : Stream<Bool>,
                                            thenBlock : Stream<T>,
                                            elseBlock : Stream<T>) : Stream<T> {
        var time = -1.0;
        var value = false;

        StreamTypes.create(function(pulse : Pulse<Bool>) : Propagation<Bool> {
            time = pulse.time();
            value = pulse.value();

            return Negate;
        }, [stream].toCollection());

        return StreamTypes.merge([
            StreamTypes.create(function(pulse : Pulse<T>) : Propagation<T> {
                return if(value && (time == pulse.time())) {
                    Propagate(pulse);
                } else {
                    Negate;
                }
            }, [thenBlock].toCollection()),
            StreamTypes.create(function(pulse : Pulse<T>) : Propagation<T> {
                return if(!value && (time == pulse.time())) {
                    Propagate(pulse);
                } else {
                    Negate;
                }
            }, [elseBlock].toCollection())].toCollection());
    }
}
