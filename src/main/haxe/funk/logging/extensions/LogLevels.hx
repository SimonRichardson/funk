package funk.logging.extensions;

import funk.logging.Log;
import funk.logging.LogLevel;
import funk.types.extensions.Anys;

class LogLevels {

    public static function value<T>(level : LogLevel<T>) : LogValue<T> {
        return Type.enumParameters(level)[0];
    }

    public static function toString<T>(level : LogLevel<T>) : String {
    	var name = switch(level) {
    		case Trace(_): "Trace";
		    case Debug(_): "Debug";
		    case Info(_): "Info";
		    case Warn(_): "Warn";
		    case Error(_): "Error";
		    case Fatal(_): "Fatal";
    	};
		return Std.format("[${name}] ${LogValues.toString(value(level))}");
	}
}
