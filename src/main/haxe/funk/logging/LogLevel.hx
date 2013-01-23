package funk.logging;

enum LogLevel<T> {
    Trace(value : T);
    Debug(value : T);
    Info(value : T);
    Warn(value : T);
    Error(value : T);
    Fatal(value : T);
}
