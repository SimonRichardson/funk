package funk.io.logging;

import funk.io.logging.Log;
import funk.io.logging.LogValue;
import funk.io.logging.Tag;
import funk.types.extensions.EnumValues;

enum Message<T> {
    Message(tag : Tag, message : LogValue<T>);
}

class MessageTypes {

    public static function tag<T>(message : Message<T>) : Tag return EnumValues.getValueByIndex(message, 0);

    public static function value<T>(message : Message<T>) : LogValue<T> return EnumValues.getValueByIndex(message, 1);

    public static function toString<T>(message : Message<T>) : String {
        return '${TagTypes.toString(tag(message))}${LogValueTypes.toString(value(message))}';
    }
}
