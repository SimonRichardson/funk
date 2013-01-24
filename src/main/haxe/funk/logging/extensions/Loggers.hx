package funk.logging.extensions;

import funk.logging.Log;
import funk.logging.Logger;
import funk.logging.LogLevel;
import funk.reactive.Stream;
import funk.types.Tuple2;

using funk.logging.extensions.LogLevels;
using funk.logging.extensions.LogValues;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Tuples2;

class Loggers {

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

        _zippedStream = Streams.identity(None);

        zippedStreamIn.foreach(function(tuple) {
            var level0 = tuple._1();
            var level1 = tuple._2();

            var t = tuple2(level0.value().data(), level1.value().data());

            var logLevel = switch(level0) {
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