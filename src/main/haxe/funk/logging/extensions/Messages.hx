package funk.logging.extensions;

import funk.logging.Log;
import funk.logging.LogLevel;
import funk.logging.Message;

class Messages {

    public static function category<T>(message : Message<T>) : Category {
        return Type.enumParameters(message)[0];
    }

    public static function logLevel<T>(message : Message<T>) : LogLevel<T> {
        return Type.enumParameters(message)[1];
    }
}
