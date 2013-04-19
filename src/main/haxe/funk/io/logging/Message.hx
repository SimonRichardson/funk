package funk.io.logging;

import funk.io.logging.Log;
import funk.io.logging.LogValue;
import funk.io.logging.Tag;

enum Message<T> {
    Message(tag : Tag, message : LogValue<T>);
}

class MessageTypes {

    public static function tag<T>(message : Message<T>) : Tag return Type.enumParameters(message)[0];

    public static function value<T>(message : Message<T>) : LogValue<T> {
        return Type.enumParameters(message)[1];
    }

    public static function toString<T>(message : Message<T>) : String {
        return '${TagTypes.toString(tag(message))}${LogValueTypes.toString(value(message))}';
    }
}
