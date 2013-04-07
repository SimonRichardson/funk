package funk.actors.dispatch;

import funk.actors.dispatch.Dispatcher;
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

        _dispatchers = Nil;
        _dispatchers = _dispatchers.prepend(new MessageDispatcher(DefaultDispatcherId, system.scheduler()));

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
