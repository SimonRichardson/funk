package funk.io.logging;

import funk.io.logging.Log;

enum LogLevel<T> {
    Trace(value : LogValue<T>);
    Debug(value : LogValue<T>);
    Info(value : LogValue<T>);
    Warn(value : LogValue<T>);
    Error(value : LogValue<T>);
    Fatal(value : LogValue<T>);
}
