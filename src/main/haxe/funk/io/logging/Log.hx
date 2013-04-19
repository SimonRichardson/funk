package funk.io.logging;

import funk.io.logging.LogLevel;
import funk.io.logging.LogValue;
import funk.reactives.Stream;
import funk.types.AnyRef;

class Log {

    private static var defaultLogger : Logger<AnyRef>;

    public static function init() : Logger<AnyRef> {
        defaultLogger = new Logger(Tag("Default"), Trace);
        return defaultLogger;
    }

    public static function logger() : Logger<AnyRef> return defaultLogger;

    public static function streamIn() : Stream<LogValue<AnyRef>> return defaultLogger.streamIn();

    public static function streamOut() : Stream<Message<AnyRef>> return defaultLogger.streamOut();

    public static function log<T>(output : LogValue<T>) : LogValue<T> {
        Log.streamIn().dispatch(output);
        return output;
    }

    public static function trace<T>(output : T) : T {
        log(Data(Trace, output));
        return output;
    }

    public static function traceWithValue<T>(output : T, value : String) : T {
        log(DataWithValue(Trace, output, value));
        return output;
    }

    public static function debug<T>(output : T) : T {
        log(Data(Debug, output));
        return output;
    }

    public static function debugWithValue<T>(output : T, value : String) : T {
        log(DataWithValue(Debug, output, value));
        return output;
    }

    public static function info<T>(output : T) : T {
        log(Data(Info, output));
        return output;
    }

    public static function infoWithValue<T>(output : T, value : String) : T {
        log(DataWithValue(Info, output, value));
        return output;
    }

    public static function warn<T>(output : T) : T {
        log(Data(Warn, output));
        return output;
    }

    public static function warnWithValue<T>(output : T, value : String) : T {
        log(DataWithValue(Warn, output, value));
        return output;
    }

    public static function error<T>(output : T) : T {
        log(Data(Error, output));
        return output;
    }

    public static function errorWithValue<T>(output : T, value : String) : T {
        log(DataWithValue(Error, output, value));
        return output;
    }

    public static function fatal<T>(output : T) : T {
        log(Data(Fatal, output));
        return output;
    }

    public static function fatalWithValue<T>(output : T, value : String) : T {
        log(DataWithValue(Fatal, output, value));
        return output;
    }
}
