package funk.logging;

import funk.logging.LogLevel;
import funk.reactive.Stream;

enum Category {
	Actor;
	Default;
	Net;
	Other(name : String);
}

class Log {

	private static var defaultLogger : Logger<Dynamic>;

	public static function init() {
		defaultLogger = new Logger(Default);
	}

	public static function streamIn() : Stream<LogLevel<Dynamic>> {
		return defaultLogger.streamIn();
	}

	public static function streamOut() : Stream<Message<Dynamic>> {
		return defaultLogger.streamOut();
	}
}
