package funk.io.logging;

import funk.io.logging.Log;

using funk.ds.CollectionUtil;
using funk.io.logging.LogLevel;
using funk.io.logging.LogValue;
using funk.types.Option;
using funk.types.Tuple2;
using funk.reactives.Stream;

class Logger<T> {

    private var _tag : Tag;

    private var _streamIn : Stream<LogValue<T>>;

    private var _streamOut : Stream<Message<T>>;

    private var _logLevel : LogLevel;

    public function new(tag : Tag, logLevel : LogLevel) {
        _tag = tag;
        _logLevel = logLevel;

        _streamIn = StreamTypes.identity(None);
        _streamOut = StreamTypes.identity(None);

        init();
    }

    @:overridable
    private function init() : Void {
        var levelIndex = _logLevel.bit();
        function(value : LogValue<T>) {
            // TODO (Simon) : It should be possible to intercept this and then map the value.
            if (value.level().bit() >= levelIndex) streamOut().dispatch(Message(tag(), value));
        }.bindTo(streamIn());
    }

    public function tag() : Tag return _tag;

    public function logLevel() : LogLevel return _logLevel;

    public function streamIn() : Stream<LogValue<T>> return _streamIn;

    public function streamOut() : Stream<Message<T>> return _streamOut;
}

class LoggerTypes {

    public static function pipe<T>(logger : Logger<T>, ouput : Output<T>) : Void ouput.add(logger.streamOut());

    public static function zip<T1, T2>(logger0 : Logger<T1>, logger1 : Logger<T2>) : Logger<Tuple2<T1, T2>> {
        return new ZippedLogger(logger0.tag(), logger0.logLevel(), logger0.streamIn().zipAny(logger1.streamIn()));
    }
}

private class ZippedLogger<T1, T2> extends Logger<Tuple2<T1, T2>> {

    private var _zippedStream : Stream<LogValue<Tuple2<T1, T2>>>;

    public function new(tag : Tag, level : LogLevel, zippedStreamIn : Stream<Tuple2<LogValue<T1>, LogValue<T2>>>) {
        super(tag, level);

        _zippedStream = StreamTypes.identity(None);

        zippedStreamIn.foreach(function(tuple) {
            var value0 : LogValue<T1> = tuple._1();
            var value1 : LogValue<T2> = tuple._2();

            var tup = tuple2(value0.data(), value1.data());

            _zippedStream.dispatch(Data(value0.level(), tup));
        });

        init();
    }

    override public function streamIn() : Stream<LogValue<Tuple2<T1, T2>>> return _zippedStream;
}
