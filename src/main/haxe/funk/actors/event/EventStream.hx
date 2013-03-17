package funk.actors.event;

using funk.actors.ActorSystem;
using funk.actors.event.EventBus;

class EventStream extends LookupClassification {

    public function new() {
        super();
    }

    public static function fromActorSystem(system : ActorSystem) : EventStream {
        return system.eventStream();
    }

    override public function subscribe<T>(subscriber : ActorRef, channel : Class<T>) : Bool {
        if (!AnyTypes.toBool(subscriber)) Funk.Errors(ArgumentError("subscriber is null"));
        return super.subscribe(subscriber, channel);
    }

    override public function unsubscribe<T>(subscriber : ActorRef, ?channel : Class<T>) : Bool {
        if (!AnyTypes.toBool(subscriber)) Funk.Errors(ArgumentError("subscriber is null"));
        return super.unsubscribe(subscriber);
    }

    override public function publish<T>(event : T, subscriber : ActorRef) : Void {
        if (subscriber.isTerminated()) unsubscribe(subscriber);
        else subscriber.tell(event);
    }
}
