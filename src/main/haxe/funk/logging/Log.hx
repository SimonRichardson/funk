package funk.logging;

import funk.reactive.Stream;

enum Category {
	Actor;
	Default;
	Net;
	Other(name : String);
}

class Log {

	private static var defaultLogger : Logger;

	public static function init() { 
		defaultLogger = new Logger(Default);
	}

	public static function streamIn() : Stream<Dynamic> {
		return defaultLogger.streamIn();
	}

	public static function streamOut() : Stream<Dynamic> {
		return defaultLogger.streamOut();
	}
}