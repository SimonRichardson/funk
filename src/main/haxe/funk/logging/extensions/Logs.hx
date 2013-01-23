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
		Log.streamIn().emit(output);
		return output;
	}

    public static function debug<T>(output : T) : T {
        return log(Debug(output)).value();
    }

    public static function debugWithValue<T1, T2>(output : T1, value : T2) : T1 {
        return log(Debug(tuple2(output, value))).value()._1();
    }
}
