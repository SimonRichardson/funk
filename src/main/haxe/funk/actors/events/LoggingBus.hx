package funk.actors.events;

import funk.Funk;
import funk.actors.ActorSystem;
import funk.actors.events.EventBus;
import funk.types.extensions.EnumValues;
import haxe.ds.ObjectMap;

using StringTools;
using funk.io.logging.Log;
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

        _loggers = Nil;
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

    @:allow(funk.actors)
    private function setupDefaultLoggers(system : ActorSystem, level : LogLevel<AnyRef>) : Void {
        _loggers = _loggers.prepend(addLogger(system, StdOutLogger, level, 'StdOut'));
    }

    private function addLogger( system : ActorSystem,
                                logClass : Class<Actor>,
                                logLevel : LogLevel<AnyRef>,
                                logName : String
                                ) : ActorRef {
        var className = AnyTypes.getName(logClass).replace('.', '_');
        var name = 'log-${system.name()}-${className}-$logName';
        var actor = system.systemActorOf(new Props(logClass), name);

        var bits = LogLevelTypes.bits();
        var from = logLevel.bit();

        for(i in bits.iterator()) if (from >= i) subscribe(actor, LogLevelTypes.index(i));

        publish(Debug(Data('$logName, logger ${name} started')));

        return actor;
    }
}

class StdOutLogger extends Actor {

    public function new() {
        super();
    }

    override public function receive(value : AnyRef) : Void {
        switch(Type.typeof(value)) {
            case TEnum(e) if(e == LogLevel):
                var logLevel : LogLevel<AnyRef> = cast value;
                LogTypes.log(logLevel);
            case _:
        }
    }
}
