package funk.io.logging;

import funk.io.logging.Log;
import funk.io.logging.LogLevel;

enum Message<T> {
    Message(tag : Tag, message : LogLevel<T>);
}
