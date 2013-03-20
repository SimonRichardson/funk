package funk.actors.event;

import funk.Funk;
import funk.actors.ActorSystem;
import funk.actors.event.EventBus;

using funk.types.Any;
using funk.types.AnyRef;

class EventStream extends LookupClassification {

    public function new() {
        super();
    }

    public static function fromActorSystem(system : ActorSystem) : EventStream {
        return null;//system.eventStream();
    }

    override public function subscribe<T>(subscriber : ActorRef, channel : Enum<AnyRef>) : Bool {
        if (!AnyTypes.toBool(subscriber)) Funk.error(ArgumentError("subscriber is null"));
        return super.subscribe(subscriber, channel);
    }

    override public function unsubscribe<T>(subscriber : ActorRef, ?channel : Enum<AnyRef>) : Bool {
        if (!AnyTypes.toBool(subscriber)) Funk.error(ArgumentError("subscriber is null"));
        return super.unsubscribe(subscriber);
    }

    override public function publish(event : EnumValue, subscriber : ActorRef) : Void {
        if (subscriber.isTerminated()) unsubscribe(subscriber);
        else subscriber.tell(event, subscriber);
    }
}
