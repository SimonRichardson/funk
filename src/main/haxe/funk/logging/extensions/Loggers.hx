package funk.logging.extensions;

import funk.logging.Log;
import funk.logging.Logger;
import funk.logging.LogLevel;
import funk.reactive.Stream;
import funk.types.Tuple2;

using funk.logging.extensions.LogLevels;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Tuples2;

class Loggers {

    public static function pipe<T>(logger : Logger<T>, ouput : Output<T>) : Void {
        ouput.add(logger.streamOut());
    }

    public static function zip<T1, T2>(logger0 : Logger<T1>, logger1 : Logger<T2>) : Logger<Tuple2<T1, T2>> {
        return new ZippedLogger(logger0.category(), logger0.streamIn().zip(logger1.streamIn()));
    }
}

private class ZippedLogger<T1, T2> extends Logger<Tuple2<T1, T2>> {

    private var _zippedStream : Stream<LogLevel<Tuple2<T1, T2>>>;

    public function new(category : Category, zippedStreamIn : Stream<Tuple2<LogLevel<T1>, LogLevel<T2>>>) {
        super(category);

        _zippedStream = Streams.identity(None);

        zippedStreamIn.foreach(function(tuple) {
            var level = tuple._1();

            var t = tuple2(tuple._1().value(), tuple._2().value());

            var logLevel = switch(level) {
                case Trace(_): Trace(t);
                case Debug(_): Debug(t);
                case Info(_): Info(t);
                case Warn(_): Warn(t);
                case Error(_): Error(t);
                case Fatal(_): Fatal(t);
            }

            _zippedStream.dispatch(logLevel);
        });
    }

    override public function streamIn() : Stream<LogLevel<Tuple2<T1, T2>>> {
        return _zippedStream;
    }
}
