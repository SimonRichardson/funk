package funk.io.logging;

import funk.io.logging.Log;
import funk.io.logging.LogLevel;
import funk.io.logging.Tag;

enum Message<T> {
    Message(tag : Tag, message : LogLevel<T>);
}

class MessageTypes {

    public static function tag<T>(message : Message<T>) : Tag return Type.enumParameters(message)[0];

    public static function logLevel<T>(message : Message<T>) : LogLevel<T> {
        return Type.enumParameters(message)[1];
    }

    public static function toString<T>(message : Message<T>) : String {
        return '${TagTypes.toString(tag(message))}${LogLevelTypes.toString(logLevel(message))}';
    }
}
