package funk.io.logging.extensions;

import funk.io.logging.Log;
import funk.io.logging.LogLevel;
import funk.types.extensions.Anys;

class LogLevels {

    public static function value<T>(level : LogLevel<T>) : LogValue<T> {
        return Type.enumParameters(level)[0];
    }

    public static function bit<T>(level : LogLevel<T>) : Int {
        return switch (level) {
            case Trace(_): 1;
            case Debug(_): 2;
            case Info(_): 4;
            case Warn(_): 8;
            case Error(_): 16;
            case Fatal(_): 32;
        };
    }

    public static function label<T>(level : LogLevel<T>) : String {
        return switch(level) {
            case Trace(_): "Trace";
            case Debug(_): "Debug";
            case Info(_): "Info";
            case Warn(_): "Warn";
            case Error(_): "Error";
            case Fatal(_): "Fatal";
        };
    }

    public static function toString<T>(level : LogLevel<T>) : String {
		return '[${label(level)}] ${LogValues.toString(value(level))}';
	}
}
