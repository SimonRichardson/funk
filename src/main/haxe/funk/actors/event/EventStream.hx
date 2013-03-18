package funk.actors.event;

import funk.Funk;

using funk.actors.ActorSystem;
using funk.actors.event.EventBus;
using funk.types.Any;

class EventStream extends LookupClassification {

    public function new() {
        super();
    }

    public static function fromActorSystem(system : ActorSystem) : EventStream {
        return system.eventStream();
    }

    override public function subscribe<T>(subscriber : ActorRef, channel : Class<T>) : Bool {
        if (!AnyTypes.toBool(subscriber)) Funk.error(ArgumentError("subscriber is null"));
        return super.subscribe(subscriber, channel);
    }

    override public function unsubscribe<T>(subscriber : ActorRef, ?channel : Class<T>) : Bool {
        if (!AnyTypes.toBool(subscriber)) Funk.error(ArgumentError("subscriber is null"));
        return super.unsubscribe(subscriber);
    }

    override public function publish(event : EnumValue, subscriber : ActorRef) : Void {
        if (subscriber.isTerminated()) unsubscribe(subscriber);
        else subscriber.tell(event);
    }
}
