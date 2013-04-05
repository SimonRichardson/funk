package funk.actors.events;

import funk.Funk;
import funk.actors.ActorSystem;
import funk.actors.events.EventBus;
import funk.types.extensions.EnumValues;
import haxe.ds.ObjectMap;

using funk.io.logging.LogLevel;
using funk.io.logging.LogValue;
using funk.io.logging.Logging;
using funk.types.Any;
using funk.types.AnyRef;
using funk.types.Tuple2;
using funk.collections.immutable.List;

class LoggingBus extends EventBus {

    private var _loggers : List<ActorRef>;

    private var _logLevel : LogLevel<AnyRef>;

    public function new() {
        super();

        _logLevel = Trace(Data({}));
    }

    public function setLogLevel(level : LogLevel<AnyRef>) : Void {
        var bits = LogLevelTypes.bits();

        var from = _logLevel.bit();
        var to = level.bit();

        for(i in bits.iterator()) {
            _loggers.foreach(function(log) {
                if (i > from && i <= to) subscribe(log, LogLevelTypes.index(i));
                else unsubscribe(log, LogLevelTypes.index(i));
            });
        }
        
        _logLevel = level;
    }
}
