package funk.io.logging;

import funk.io.logging.LogLevel;
import funk.reactive.Stream;

class Log {

	private static var defaultLogger : Logger<Dynamic>;

	public static function init() {
		defaultLogger = new Logger(Tag("Default"));
	}

	public static function logger() : Logger<Dynamic> {
		return defaultLogger;
	}

	public static function streamIn() : Stream<LogLevel<Dynamic>> {
		return defaultLogger.streamIn();
	}

	public static function streamOut() : Stream<Message<Dynamic>> {
		return defaultLogger.streamOut();
	}
}
