package funk.logging.extensions;

import funk.logging.LogLevel;

class LogLevels {

    public static function value<T>(level : LogLevel<T>) : T {
        return Type.enumParameters(level)[0];
    }
}
