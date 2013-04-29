package funk.io.logging;

import funk.io.logging.Log;
import funk.io.logging.LogValue;

using funk.ds.immutable.List;
using funk.ds.immutable.ListUtil;

enum LogLevel {
    Trace;
    Debug;
    Info;
    Warn;
    Error;
    Fatal;
}

class LogLevelTypes {

    public static function bit(level : LogLevel) : Int {
        return switch (level) {
            case Trace: 1;
            case Debug: 2;
            case Info: 4;
            case Warn: 8;
            case Error: 16;
            case Fatal: 32;
        };
    }

    public static function bits() : List<Int> return [1, 2, 4, 8, 16, 32].toList();

    public static function index(value : Int) : LogLevel {
        return switch (value) {
            case 1: Trace;
            case 2: Debug;
            case 4: Info;
            case 8: Warn;
            case 16: Error;
            case 32: Fatal;
            case _: Funk.error(ArgumentError());
        };
    }

    public static function label(level : LogLevel) : String return Std.string(level);

    public static function toString(level : LogLevel) : String return '[${label(level)}]';
}
