package funk.logging;

import funk.logging.Log;
import funk.logging.LogLevel;

enum Message<T> {
    Message(tag : Tag, message : LogLevel<T>);
}
