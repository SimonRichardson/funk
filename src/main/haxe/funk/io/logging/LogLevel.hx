package funk.io.logging;

import funk.io.logging.Log;
import funk.io.logging.LogValue;

using funk.collections.immutable.List;
using funk.collections.immutable.ListUtil;

enum LogLevel<T> {
    Trace(value : LogValue<T>);
    Debug(value : LogValue<T>);
    Info(value : LogValue<T>);
    Warn(value : LogValue<T>);
    Error(value : LogValue<T>);
    Fatal(value : LogValue<T>);
}

class LogLevelTypes {

    public static function value<T>(level : LogLevel<T>) : LogValue<T> {
        return Type.enumParameters(level)[0];
    }

    public static function bit<T>(level : LogLevel<T>) : Int {
        return switch (level) {
            case Trace(_): 1;
            case Debug(_): 2;
            case Info(_): 4;
            case Warn(_): 8;
            case Error(_): 16;
            case Fatal(_): 32;
        };
    }

    public static function bits() : List<Int> return [1, 2, 4, 8, 16, 32].toList();

    public static function index<T>(value : Int) : LogLevel<T> {
        return switch (value) {
            case 1: Trace(Data({}));
            case 2: Debug(Data({}));
            case 4: Info(Data({}));
            case 8: Warn(Data({}));
            case 16: Error(Data({}));
            case 32: Fatal(Data({}));
            case _: Funk.error(ArgumentError());
        };
    }

    public static function label<T>(level : LogLevel<T>) : String {
        return switch(level) {
            case Trace(_): "Trace";
            case Debug(_): "Debug";
            case Info(_): "Info";
            case Warn(_): "Warn";
            case Error(_): "Error";
            case Fatal(_): "Fatal";
        };
    }

    public static function toString<T>(level : LogLevel<T>) : String {
        return '[${label(level)}] ${LogValueTypes.toString(value(level))}';
    }
}
