package funk.io.logging;

import funk.types.Any;

using funk.types.Option;

enum LogValue<T> {
    Data(data : T);
    DataWithValue(data : T, value : String);
}

class LogValueTypes {

    public static function data<T>(logValue : LogValue<T>) : T {
        return Type.enumParameters(logValue)[0];
    }

    public static function value<T>(logValue : LogValue<T>) : Option<String> {
        return switch(logValue) {
            case Data(_): None;
            case DataWithValue(_, val): Some(val);
        };
    }

    public static function toString<T>(logValue : LogValue<T>) : String {
        return switch(logValue) {
            case Data(data): AnyTypes.toString(data);
            case DataWithValue(data, value): '${AnyTypes.toString(data)}${value}';
        };
    }
}
