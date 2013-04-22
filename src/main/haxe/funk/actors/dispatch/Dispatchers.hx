package funk.actors.dispatch;

import funk.actors.dispatch.Dispatcher;
import funk.actors.events.EventStream;
import funk.actors.events.LoggingBus;
import funk.types.Any;

using funk.collections.immutable.List;
using funk.types.Option;

@:keep
class Dispatchers {

    public static var DefaultDispatcherId : String = "funk.actors.default-dispatcher";

    private var _dispatchers : List<Dispatcher>;

    private var _defaultGlobalDispatcher : Dispatcher;

    public function new(system : ActorSystem) {
        var scheduler = system.scheduler();
        if (!AnyTypes.toBool(scheduler)) Funk.error(ArgumentError());

        var prerequisites = new MessageDispatcherPrerequisites(system.scheduler(), system.eventStream());

        _dispatchers = Nil;
        _dispatchers = _dispatchers.prepend(new MessageDispatcher(DefaultDispatcherId, prerequisites));

        _defaultGlobalDispatcher = find(DefaultDispatcherId);
    }

    public function find(id : String) : Dispatcher {
        var opt = _dispatchers.find(function(value) return value.name() == id);
        return switch (opt) {
            case Some(dispatcher): dispatcher;
            case _: defaultGlobalDispatcher();
        }
    }

    public function defaultGlobalDispatcher() : Dispatcher return _defaultGlobalDispatcher;
}

private class MessageDispatcherPrerequisites implements DispatcherPrerequisites {

    private var _scheduler : Scheduler;

    private var _eventStream : EventStream;

    public function new(scheduler : Scheduler, eventStream : EventStream) {
        _scheduler = scheduler;
        _eventStream = eventStream;
    }

    public function scheduler() : Scheduler return _scheduler;

    public function eventStream() : EventStream return _eventStream;
}
