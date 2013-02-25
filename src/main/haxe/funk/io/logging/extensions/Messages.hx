package funk.io.logging.extensions;

import funk.io.logging.Log;
import funk.io.logging.LogLevel;
import funk.io.logging.Message;

using funk.io.logging.extensions.Tags;
using funk.io.logging.extensions.LogLevels;

class Messages {

    public static function tag<T>(message : Message<T>) : Tag {
        return Type.enumParameters(message)[0];
    }

    public static function logLevel<T>(message : Message<T>) : LogLevel<T> {
        return Type.enumParameters(message)[1];
    }

    public static function toString<T>(message : Message<T>) : String {
		return '${Tags.toString(tag(message))}${LogLevels.toString(logLevel(message))}';
	}
}
