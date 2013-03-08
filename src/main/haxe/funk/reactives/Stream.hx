package funk.reactives;

import funk.reactives.Propagation;
import funk.reactives.Stream;
import funk.reactives.Process;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Predicate2;

using funk.types.Option;
using funk.collections.Collection;
using funk.collections.CollectionUtil;
using funk.collections.immutable.List;
using funk.types.Tuple2;
using funk.reactives.Pulse;

class Stream<T> {

	public var weakRef(get_weakRef, set_weakRef) : Bool;

	private var _rank : Int;

    private var _weakRef : Bool;

	private var _propagator : Function1<Pulse<T>, Propagation<T>>;

	private var _listeners : Array<Stream<T>>;

    private var _finishedListeners : List<Function0<Void>>;

	public function new(propagator : Function1<Pulse<T>, Propagation<T>>) {
		_rank = Rank.next();
		_propagator = propagator;
		_listeners = [];

        _weakRef = false;

        _finishedListeners = Nil;
	}

    public function attach(listener : Stream<T>) : Void {
        _listeners.push(listener);

        if(_rank > listener._rank) {
            var listeners : Array<Stream<T>> = [listener];

            while(listeners.length > 0) {
                var item = listeners.shift();

                item._rank = Rank.next();

                var itemListeners = item._listeners;
                if(itemListeners.length > 0) {
                    listeners = listeners.concat(itemListeners);
                }
            }
        }
    }

    public function detach(listener : Stream<T>, ?weakReference : Bool = false): Bool {
        var removed = false;

        var index = _listeners.length;
        while(--index > -1) {
            if(_listeners[index] == listener) {
                _listeners.splice(index, 1);
                removed = true;
                break;
            }
        }

        if(weakReference && _listeners.length == 0) {
            weakRef = true;
        }

        return removed;
    }

    public function dispatch(value : T) : Stream<T> {
        var time = Process.stamp();
        var pulse = Pulse(time, value);

        // This will propagate through all listeners
        var queue = new PriorityQueue<{stream: Stream<T>, pulse: Pulse<T>}>();
        queue.insert(_rank, {
            stream: this,
            pulse: pulse
        });

        while (queue.size() > 0) {
            var keyValue = queue.pop().value;

            var stream = keyValue.stream;
            var pulse  = keyValue.pulse;

            switch (stream._propagator(pulse)) {
                case Propagate(p): {
                    var weak = true;

                    for (listener in stream._listeners) {
                        weak = weak && listener.weakRef;

                        var index = listener._rank;
                        queue.insert(index, {stream: listener, pulse: p});
                    }

                    if(stream._listeners.length > 0 && weak) {
                        stream.weakRef = true;
                    }
                }

                case Negate:
            }
        }

        return this;
    }

    public function finish() : Void {
        weakRef = true;
        // TODO : We should prevent it from coming back.
    }

    public function whenFinishedDo(func : Function0<Void>) : Void {
        if(_weakRef) {
            func();
        } else {
            if (_finishedListeners.indexOf(func) < 0) {
                _finishedListeners = _finishedListeners.prepend(func);
            }
        }
    }

	public function get_weakRef() : Bool {
        return _weakRef;
    }

    public function set_weakRef(value : Bool) : Bool {
        if(_weakRef != value) {
            _weakRef = value;

            if(_weakRef) {
                _finishedListeners.foreach(function(func) func());
                _finishedListeners = Nil;
            }
        }

        return value;
    }
}

class StreamTypes {

    private static function toCollection<T>(stream : Stream<T>) : Collection<Stream<T>> {
        return [stream].toCollection();
    }

    public static function bindTo<T, E>(func : Function1<T, Void>, stream : Stream<E>) : Stream<E> {
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
                stream.dispatch(pulse.value());
            }, behaviour.value());

            return Negate;
        }, toCollection(stream));

        return out;
    }

    public static function constant<T1, T2>(stream : Stream<T1>, value : T2) : Stream<T2> {
        return map(stream, function(v) {
            return value;
        });
    }

    @:noUsing
    public static function create<T1, T2>(  pulse: Function1<Pulse<T1>, Propagation<T2>>,
                                            sources: Collection<Stream<T1>>
                                            ) : Stream<T2> {
        var stream = new Stream<T2>(cast pulse);

        sources.foreach(function (source : Stream<T1>) {
            switch(source.toOption()) {
                case Some(val): val.attach(cast stream);
                case None:
            }
        });
    
        return stream;
    }

    public static function delay<T>(stream : Stream<T>, behaviour : Behaviour<Int>) : Stream<T> {
        var out : Stream<T> = identity(None);

        create(function(pulse : Pulse<T>) : Propagation<T> {
            StreamTypes.dispatchWithDelay(out, pulse.value(), behaviour.value());

            return Negate;
        }, toCollection(stream));

        return out;
    }

    public static function dispatchWithDelay<T>(stream : Stream<T>, value : T, delay : Int) : Stream<T> {
        Process.start(function() {
            stream.dispatch(value);
        }, delay);

        return stream;
    }

    public static function flatMap<T1, T2>(stream : Stream<T1>, func : Function1<T1, Stream<T2>>) : Stream<T2> {
        var previous : Option<Stream<T2>> = None;
        var out = identity(None);

        create(function(pulse : Pulse<T1>) : Propagation<T2> {
            previous.foreach(function(s) {
                s.detach(out);
            });
            previous = func(pulse.value()).toOption();
            previous.foreach(function(s) {
                s.attach(out);
            });

            return Negate;
        }, toCollection(stream));

        return out;
    }

    public static function foreach<T>(stream : Stream<T>, func : Function1<T, Void>) : Stream<T> {
        create(function(pulse : Pulse<T>) : Propagation<T> {
            func(pulse.value());

            return Negate;
        }, toCollection(stream));

        return stream;
    }

    public static function identity<T>(sources: Option<Collection<Stream<T>>>) : Stream<T> {
        return create(function(pulse) {
                return Propagate(pulse);
            }, sources.getOrElse(function() return CollectionUtil.zero()));
    }

    public static function map<T1, T2>(stream : Stream<T1>, func : Function1<T1, T2>) : Stream<T2> {
        return create(function(pulse : Pulse<T1>) : Propagation<T2> {
            return Propagate(pulse.map(func));
        }, toCollection(stream));
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
                Funk.error(IllegalOperationError("Received a value that wasn't expected " + pulse.value));
                Negate;
            } else {
                sent = true;
                Propagate(pulse);
            }
        }, CollectionUtil.zero());

        stream.dispatch(value);

        return stream;
    }

    public static function random(time : Behaviour<Float>) : Stream<Float> {
        var timerStream : Stream<Float> = timer(time);
        var mapStream : Stream<Float> = map(timerStream, function(value) {
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
        var mapStream : Stream<Float> = map(timerStream, function(value) {
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
        }, toCollection(stream));
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
        }, toCollection(stream));
    }

    public static function timer(time : Behaviour<Float>) : Stream<Float> {
        var stream : Stream<Float> = identity(None);
        var task : Option<Task> = None;

        stream.whenFinishedDo(function() {
            task = Process.stop(task);
        });

        var pulser : Function0<Void> = null;
        pulser = function() {
            stream.dispatch(Process.stamp());

            task = Process.stop(task);

            if(!stream.weakRef) {
                task = Process.start(pulser, time.value());
            }
        };

        task = Process.start(pulser, time.value());

        return stream;
    }

    public static function values<T>(stream : Stream<T>) : Collection<T> {
        var list : List<T> = Nil;

        var collection = new StreamValues<T>(Some(function() {
            return list;
        }));

        foreach(stream, function(value : T) : Void {
            list = list.append(value);
        });

        return collection;
    }

    public static function zero<T>() : Stream<T> {
        return create(function(pulse : Pulse<T>) : Propagation<T> {
                Funk.error(IllegalOperationError("Received a value that wasn't expected " + pulse.value()));
                return Negate;
            }, CollectionUtil.zero());
    }

    public static function zip<T1, T2>(stream0 : Stream<T1>, stream1 : Stream<T2>) : Stream<Tuple2<T1, T2>> {
        return zipWith(stream0, stream1, function (a, b) {
            var tuple : Tuple2<T1, T2> = tuple2(a, b);
            return tuple;
        });
    }

    public static function zipAny<T1, T2>(stream0 : Stream<T1>, stream1 : Stream<T2>) : Stream<Tuple2<T1, T2>> {
        return zipWith(stream0, stream1, function (a, b) {
            var tuple : Tuple2<T1, T2> = tuple2(a, b);
            return tuple;
        }, function (t0, t1) {
            return true;
        });
    }

    public static function zipWith<T1, T2, R>(  stream0 : Stream<T1>,
                                                stream1 : Stream<T2>,
                                                func : Function2<T1, T2, R>,
                                                ?guard : Predicate2<Float, Float> = null
                                                ) : Stream<R> {
        var time = -1.0;
        var value : Option<T1> = None;

        var guarded = if (null == guard) {
            function (t0, t1) {
                return t0 == t1;
            }
        } else {
            guard;
        }

        create(function(pulse : Pulse<T1>) : Propagation<T1> {
            time = pulse.time();
            value = pulse.value().toOption();

            return Negate;
        }, toCollection(stream0));

        return create(function(pulse : Pulse<T2>) : Propagation<R> {
            return if (guarded(time, pulse.time())) {
                Propagate(pulse.withValue(func(value.get(), pulse.value())));
            } else {
                Negate;
            }
        }, toCollection(stream1));
    }
}


private class Rank {

	private static var _value : Int = 0;

    public static function last(): Int {
        return _value;
    }

    public static function next(): Int {
        return _value++;
    }
}

private typedef KeyValue<T> = {
    key: Int,
    value: T
};

private class PriorityQueue<T> {

    private var _values : Array<KeyValue<T>>;

    public function new() {
        _values = [];
    }

    public function insert(index : Int, value : T) : Void {
        var keyValue = {
            key: index,
            value: value
        };

        var added = false;

        for (i in 0..._values.length) {
            var val = _values[i];

            if (index > val.key) {
                added = true;

                _values.insert(i, keyValue);

                break;
            }
        }

        if (!added) {
            _values.push(keyValue);
        }
    }

    public function pop() : KeyValue<T> {
        return _values.pop();
    }

    public function size(): Int {
        return _values.length;
    }
}
