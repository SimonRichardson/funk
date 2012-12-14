package funk.reactive.extensions;

import funk.collections.Collection;
import funk.collections.extensions.CollectionsUtil;
import funk.Funk;
import funk.reactive.Process;
import funk.reactive.Pulse;
import funk.reactive.Propagation;
import funk.reactive.Stream;
import funk.reactive.extensions.Pulses;
import funk.reactive.extensions.Streams;
import funk.signals.Signal1;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Option;
import funk.types.Tuple2;
import funk.types.extensions.Options;

using funk.collections.extensions.CollectionsUtil;
using funk.reactive.extensions.Pulses;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Options;

class Streams {

    public static function bind<T, E>(func : Function1<T, Void>, stream : Stream<E>) : Stream<E> {
        stream.foreach(function(v) {
            func(cast v);
        });
        return stream;
    }

    public static function calm<T>(stream : Stream<T>, behaviour : Behaviour<Int>) : Stream<T> {
        var out : Stream<T> = identity(None);

        var task : Option<Task> = None;
        create(function(pulse : Pulse<T>) : Propagation<T> {

            task = Process.stop(task);
            task = Process.start(function() {
                stream.emit(pulse.value());
            }, behaviour.value());

            return Negate;
        }, Some(CollectionsUtil.toCollection(stream)));

        return out;
    }

    public static function constant<T1, T2>(stream : Stream<T1>, value : T2) : Stream<T2> {
        return map(stream, function(v) {
            return value;
        });
    }

    @:noUsing
	public static function create<T1, T2>(	pulse: Function1<Pulse<T1>, Propagation<T2>>,
										    sources: Option<Collection<Stream<T1>>>
										    ) : Stream<T2> {
        var stream = new Stream<T2>(cast pulse);

        sources.foreach(function(collection){
            for(source in collection.iterator()) {
                source.attachListener(cast stream);
            }
        });

        return stream;
    }

    public static function delay<T>(stream : Stream<T>, behaviour : Behaviour<Int>) : Stream<T> {
        var out : Stream<T> = identity(None);

        create(function(pulse : Pulse<T>) : Propagation<T> {
            out.emitWithDelay(pulse.value(), behaviour.value());

            return Negate;
        }, Some(CollectionsUtil.toCollection(stream)));

        return out;
    }

    public static function emitWithDelay<T>(stream : Stream<T>, value : T, delay : Int) : Stream<T> {
        Process.start(function() {
            stream.emit(value);
        }, delay);

        return stream;
    }

    public static function flatMap<T1, T2>(stream : Stream<T1>, func : Function1<T1, Stream<T2>>) : Stream<T2> {
        var previous : Option<Stream<T2>> = None;
        var out = identity(None);

        create(function(pulse : Pulse<T1>) : Propagation<T2> {
            previous.foreach(function(s) {
                s.detachListener(out);
            });
            previous = func(pulse.value()).toOption();
            previous.foreach(function(s) {
                s.attachListener(out);
            });

            return Negate;
        }, Some(CollectionsUtil.toCollection(stream)));

        return out;
    }

    public static function foreach<T>(stream : Stream<T>, func : Function1<T, Void>) : Stream<T> {
        create(function(pulse : Pulse<T>) : Propagation<T> {
            func(pulse.value());

            return Negate;
        }, Some(CollectionsUtil.toCollection(stream)));

        return stream;
    }

	public static function identity<T>(sources: Option<Collection<Stream<T>>>) : Stream<T> {
        return create(function(pulse) {
        		return Propagate(pulse);
        	}, sources);
    }

    public static function map<T1, T2>(stream : Stream<T1>, func : Function1<T1, T2>) : Stream<T2> {
        return create(function(pulse : Pulse<T1>) : Propagation<T2> {
            return Propagate(pulse.map(func));
        }, Some(CollectionsUtil.toCollection(stream)));
    }

    public static function merge<T>(streams : Collection<Stream<T>>) : Stream<T> {
        return if(streams.size() == 0) {
            zero();
        } else {
            identity(Some(streams));
        };
    }

    public static function once<T>(value : T) : Stream<T> {
        var sent = false;
        var stream = create(function(pulse : Pulse<T>) {
            return if (sent) {
                Funk.error(Errors.IllegalOperationError("Received a value that wasn't expected " + pulse.value));
                Negate;
            } else {
                sent = true;
                Propagate(pulse);
            }
        }, None);

        // NOTE (Simon) : This will break for concurrent systems
        stream.emitWithDelay(value, 1);

        return stream;
    }

    public static function random(time : Behaviour<Float>) : Stream<Float> {
        var timerStream : Stream<Float> = timer(time);
        var mapStream : Stream<Float> = timerStream.map(function(value) {
            return Math.random();
        });
        mapStream.whenFinishedDo(function() : Void {
            timerStream.finish();
        });

        return mapStream;
    }

    public static function sine(time : Behaviour<Float>, ?resolution : Null<Int>) : Stream<Float> {
        var resolution : Null<Int> = resolution == null ? 100 : resolution;
        var angle : Float = Math.PI * 2 / resolution;

        var timerStream : Stream<Float> = timer(time);
        var mapStream : Stream<Float> = timerStream.map(function(value) {
            return Math.sin(Process.stamp() + angle);
        });
        mapStream.whenFinishedDo(function() : Void {
            timerStream.finish();
        });

        return mapStream;
    }

    public static function shift<T>(stream : Stream<T>, value : Int) : Stream<T> {
        var queue : Array<T> = [];

        return create(function(pulse : Pulse<T>) : Propagation<T> {
            queue.push(pulse.value());

            return if (queue.length <= value) {
                Negate;
            } else {
                Propagate(pulse.withValue(queue.shift()));
            }
        }, Some(CollectionsUtil.toCollection(stream)));
    }

    public static function startsWith<T>(stream : Stream<T>, value : T) : Behaviour<T> {
        return new Behaviour(stream, value, function(pulse : Pulse<T>) : Propagation<T> {
            return Propagate(pulse);
        });
    }

    public static function steps<T>(stream : Stream<T>) : Stream<T> {
        var time = -1.0;

        return create(function(pulse : Pulse<T>) : Propagation<T> {
            return if(pulse.time() != time) {
                time = pulse.time();

                Propagate(pulse);
            } else {
                Negate;
            }
        }, Some(CollectionsUtil.toCollection(stream)));
    }

    public static function timer(time : Behaviour<Float>) : Stream<Float> {
        var stream : Stream<Float> = identity(None);
        var task : Option<Task> = None;

        stream.whenFinishedDo(function() {
            task = Process.stop(task);
        });

        var pulser : Function0<Void> = null;
        pulser = function() {
            stream.emit(Process.stamp());

            task = Process.stop(task);

            if(!stream.weakRef) {
                task = Process.start(pulser, time.value());
            }
        };

        task = Process.start(pulser, time.value());

        return stream;
    }

    public static function values<T>(stream : Stream<T>) : Collection<T> {
        var signal = new Signal1<T>();
        var collection = new StreamValues<T>(Some(signal));
        foreach(stream, function(value : T) : Void {
            signal.dispatch(value);
        });
        return collection;
    }

    public static function zero<T>() : Stream<T> {
        return create(function(pulse : Pulse<T>) : Propagation<T> {
                Funk.error(Errors.IllegalOperationError("Received a value that wasn't expected " + pulse.value()));
                return Negate;
            }, None);
    }

    public static function zip<T1, T2>(stream0 : Stream<T1>, stream1 : Stream<T2>) : Stream<Tuple2<T1, T2>> {
        return zipWith(stream0, stream1, function (a, b) {
            return tuple2(a, b);
        });
    }

    public static function zipWith<T1, T2, R>(  stream0 : Stream<T1>,
                                                stream1 : Stream<T2>,
                                                func : Function2<T1, T2, R>
                                                ) : Stream<R> {
        var time = -1.0;
        var value : Option<T1> = None;

        create(function(pulse : Pulse<T1>) : Propagation<T1> {
            time = pulse.time();
            value = pulse.value().toOption();

            return Negate;
        }, Some(CollectionsUtil.toCollection(stream0)));

        return create(function(pulse : Pulse<T2>) : Propagation<R> {
            return if (time == pulse.time()) {
                Propagate(pulse.withValue(func(value.get(), pulse.value())));
            } else {
                Negate;
            }
        }, Some(CollectionsUtil.toCollection(stream1)));
    }
}
