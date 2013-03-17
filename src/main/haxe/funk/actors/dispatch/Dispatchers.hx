package funk.actors.dispatch;

import funk.actors.dispatch.Dispatcher;
import funk.actors.dispatch.MessageDispatcher;

class Dispatchers {

    public static var DefaultDispatcherId : String = "funk.actor.default-dispatcher";

    private var _dispatchers : List<MessageDispatcher>;

    private var _defaultGlobalDispatcher : MessageDispatcher;

    public function new() {
        _dispatchers = Nil;
        _defaultGlobalDispatcher = lookup(DefaultDispatcherId);
    }

    public function lookup(id : String) : MessageDispatcher {
        var opt = _dispatchers.find(function(value) return value.name() == id);
        return switch(opt) {
            case Some(dispatcher): dispatcher;
            case _:
                // TODO (Simon) : Notify about falling back to default.
                defaultGlobalDispatcher();
        }
    }

    public function defaultGlobalDispatcher() : MessageDispatcher return _defaultGlobalDispatcher;
}
