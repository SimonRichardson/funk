package funk.io.logging;

import funk.types.Any;
import funk.types.AnyRef;
import funk.io.logging.LogLevel;
import haxe.PosInfos;

using funk.types.Option;

enum LogValue<T> {
    Data(level : LogLevel, data : T, ?pos : PosInfos);
    DataWithValue(level : LogLevel, data : T, value : String, ?pos : PosInfos);
}

class LogValueTypes {

    public static function level<T>(logValue : LogValue<T>) : LogLevel return Type.enumParameters(logValue)[0];

    public static function data<T>(logValue : LogValue<T>) : T return Type.enumParameters(logValue)[1];

    public static function value<T>(logValue : LogValue<T>) : Option<String> {
        return switch(logValue) {
            case Data(_, _, _): None;
            case DataWithValue(_, _, val, _): Some(val);
        };
    }

    public static function values<T>(logValue : LogValue<T>) : String {
        return '${data(logValue)}${value(logValue).getOrElse(function() return "")}';
    }

    public static function toString<T>(logValue : LogValue<T>) : String {
        return switch(logValue) {
            case Data(level, data, pos):
                '${LogLevelTypes.toString(level)} ${AnyTypes.toString(data)}\n${pos}';
            case DataWithValue(level, data, value, pos):
                '${LogLevelTypes.toString(level)} ${AnyTypes.toString(data)}${value}\n${pos}';
        };
    }
}
