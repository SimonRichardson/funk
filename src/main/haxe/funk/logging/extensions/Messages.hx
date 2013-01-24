package funk.logging.extensions;

import funk.logging.Log;
import funk.logging.LogLevel;
import funk.logging.Message;

using funk.logging.extensions.Tags;
using funk.logging.extensions.LogLevels;

class Messages {

    public static function tag<T>(message : Message<T>) : Tag {
        return Type.enumParameters(message)[0];
    }

    public static function logLevel<T>(message : Message<T>) : LogLevel<T> {
        return Type.enumParameters(message)[1];
    }

    public static function toString<T>(message : Message<T>) : String {
		return Std.format("${Tags.toString(tag(message))}${LogLevels.toString(logLevel(message))}");
	}
}
