package funk.logging.extensions;

import funk.logging.Log;
import funk.reactive.Stream;

using funk.reactive.extensions.Streams;

class Logs {

	public static function log<T>(output : T) : T {
		Log.streamIn().emit(output);
		return output;
	}

	public static function logWithValue<T1, T2>(output : T1, value : T2) : T1 {
		Log.streamIn().emit(Std.string(output) + Std.string(value));
		return output;
	}
}