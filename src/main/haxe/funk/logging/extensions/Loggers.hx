package funk.logging.extensions;

import funk.logging.Logger;
import funk.logging.LogLevel;
import funk.reactive.Stream;
import funk.types.Tuple2;

using funk.reactive.extensions.Streams;

class Loggers {

    public static function pipe<T>(logger : Logger<T>, ouput : Output<T>) : Void {
        ouput.add(logger.streamOut());
    }

    public static function zip<T1, T2>(logger0 : Logger<T1>, logger1 : Logger<T2>) : Logger<Tuple2<T1, T2>> {
        return new ZippedLogger(logger0.streamIn().zip(logger1.streamIn()));
    }
}

private class ZippedLogger extends Logger {

    private var _zippedStreamIn : Stream<LogLevel<T>>;

    public function new(streamIn : Stream<LogLevel<T>>) {
        super();

        _zippedStreamIn = streamIn;
    }

    override public function streamIn() : Stream<LogLevel<T>> {
        return _zippedStreamIn;
    }
}
