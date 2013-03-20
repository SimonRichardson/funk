package funk.actors.dispatch;

using funk.actors.dispatch.Dispatcher;
using funk.actors.dispatch.MessageDispatcher;
using funk.actors.Scheduler;
using funk.actors.dispatch.Mailbox;
using funk.actors.event.EventStream;
using funk.collections.immutable.List;
using funk.types.Option;

class Dispatchers {

    public static var DefaultDispatcherId : String = "funk.actor.default-dispatcher";

    private var _scheduler : Scheduler;

    private var _eventStream : EventStream;

    private var _deadLetterMailbox : Mailbox;

    private var _dispatchers : List<MessageDispatcher>;

    private var _defaultGlobalDispatcher : MessageDispatcher;

    public function new(eventStream : EventStream, deadLetterMailbox : Mailbox, scheduler : Scheduler) {
        _eventStream = eventStream;
        _deadLetterMailbox = deadLetterMailbox;
        _scheduler = scheduler;

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
