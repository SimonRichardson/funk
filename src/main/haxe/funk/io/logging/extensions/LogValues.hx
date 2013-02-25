package funk.io.logging.extensions;

import funk.io.logging.Log;
import funk.io.logging.LogLevel;
import haxe.ds.Option;
import funk.types.extensions.Anys;

class LogValues {

    public static function data<T>(logValue : LogValue<T>) : T {
        return Type.enumParameters(logValue)[0];
    }

    public static function value<T>(logValue : LogValue<T>) : Option<String> {
        return switch(logValue) {
            case Data(_): None;
            case DataWithValue(_, val): Some(val);
        };
    }

    public static function toString<T>(logValue : LogValue<T>) : String {
    	return switch(logValue) {
    		case Data(data): Anys.toString(data);
    		case DataWithValue(data, value): '${Anys.toString(data)}${value}';
    	};
	}
}
