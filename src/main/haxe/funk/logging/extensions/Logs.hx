package funk.logging.extensions;

import funk.logging.Log;
import funk.logging.LogLevel;
import funk.reactive.Stream;
import funk.types.Tuple2;

using funk.logging.extensions.LogLevels;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Tuples2;

class Logs {

	public static function log<T>(output : LogLevel<T>) : LogLevel<T> {
		Log.streamIn().dispatch(output);
		return output;
	}

    public static function debug<T>(output : T) : T {
        log(Debug(Data(output)));
        return output;
    }

    public static function debugWithValue<T>(output : T, value : String) : T {
        log(Debug(DataWithValue(output, value)));
        return output;
    }
}
