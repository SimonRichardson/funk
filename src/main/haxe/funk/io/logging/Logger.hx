package funk.io.logging;

import funk.io.logging.Log;

using funk.collections.CollectionUtil;
using funk.io.logging.LogLevel;
using funk.io.logging.LogValue;
using funk.types.Option;
using funk.types.Tuple2;
using funk.reactives.Stream;

class Logger<T> {

    public var logLevel(get_logLevel, set_logLevel) : Int;

    private var _tag : Tag;

    private var _streamIn : Stream<LogLevel<T>>;

    private var _streamOut : Stream<Message<T>>;

    private var _logLevel : Int;

    public function new(tag : Tag) {
        _tag = tag;
        _logLevel = 1;

        _streamIn = StreamTypes.identity(None);
        _streamOut = StreamTypes.identity(None);

        init();
    }

    @:overridable
    private function init() : Void {
        function(value : LogLevel<T>) {
            // TODO (Simon) : It should be possible to intercept this and then map the value.
            if (value.bit() >= logLevel) {
                streamOut().dispatch(Message(tag(), value));
            }
        }.bindTo(streamIn());
    }

    public function tag() : Tag {
        return _tag;
    }

    public function streamIn() : Stream<LogLevel<T>> {
        return _streamIn;
    }

    public function streamOut() : Stream<Message<T>> {
        return _streamOut;
    }

    private function get_logLevel() : Int {
        return _logLevel;
    }

    private function set_logLevel(value : Int) : Int {
        _logLevel = value;
        return _logLevel;
    }
}

class LoggerTypes {

    public static function pipe<T>(logger : Logger<T>, ouput : Output<T>) : Void {
        ouput.add(logger.streamOut());
    }

    public static function zip<T1, T2>(logger0 : Logger<T1>, logger1 : Logger<T2>) : Logger<Tuple2<T1, T2>> {
        return new ZippedLogger(logger0.tag(), logger0.streamIn().zipAny(logger1.streamIn()));
    }
}

private class ZippedLogger<T1, T2> extends Logger<Tuple2<T1, T2>> {

    private var _zippedStream : Stream<LogLevel<Tuple2<T1, T2>>>;

    public function new(tag : Tag, zippedStreamIn : Stream<Tuple2<LogLevel<T1>, LogLevel<T2>>>) {
        super(tag);

        _zippedStream = StreamTypes.identity(None);

        zippedStreamIn.foreach(function(tuple) {
            var level0 : LogLevel<T1> = tuple._1();
            var level1 : LogLevel<T2> = tuple._2();

            var t = tuple2(level0.value().data(), level1.value().data());

            var logLevel : LogLevel<Tuple2<T1, T2>> = switch(level0) {
                case Trace(_): Trace(Data(t));
                case Debug(_): Debug(Data(t));
                case Info(_): Info(Data(t));
                case Warn(_): Warn(Data(t));
                case Error(_): Error(Data(t));
                case Fatal(_): Fatal(Data(t));
            }

            _zippedStream.dispatch(logLevel);
        });

        init();
    }

    override public function streamIn() : Stream<LogLevel<Tuple2<T1, T2>>> {
        return _zippedStream;
    }
}
