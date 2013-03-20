package funk.actors.event;

using funk.types.extensions.EnumValues;
using funk.types.Tuple2;
using funk.types.Any;
using funk.types.AnyRef;
using funk.types.Option;
using funk.collections.immutable.List;

typedef EventBus = {

    function subscribe(subscriber : ActorRef, to : Enum<AnyRef>) : Bool;

    function unsubscribe(subscriber : ActorRef, from : Enum<AnyRef>) : Bool;

    function publish(event : EnumValue, subscriber : ActorRef) : Void;
};

class LookupClassification {

    private var _subscribers : List<Tuple2<Enum<AnyRef>, ActorRef>>;

    public function new() {
        _subscribers = Nil;
    }

    public function subscribe(subscriber : ActorRef, to : Enum<AnyRef>) : Bool {
        var found = _subscribers.find(function(tuple) {
            return (tuple._2() == subscriber && (!AnyTypes.toBool(to) || tuple._1() == to));
        });

        return if (found.isEmpty()) {
            _subscribers = _subscribers.prepend(tuple2(to, subscriber));
            true;
        } else false;
    }

    public function unsubscribe(subscriber : ActorRef, ?from : Enum<AnyRef>) : Bool {
        var original = _subscribers;
        _subscribers = original.filterNot(function(tuple : Tuple2<Enum<AnyRef>, ActorRef>) {
            return (tuple._2() == subscriber && (!AnyTypes.toBool(from) || tuple._1() == from));
        });
        return _subscribers == original;
    }

    public function publish(event : EnumValue, subscriber : ActorRef) : Void {
    }

    public function publishEvent(event : EnumValue) : Void {
        var list = _subscribers.filter(function(tuple : Tuple2<Enum<AnyRef>, ActorRef>) : Bool {
            return tuple._1() == classify(event);
        });

        while(list.nonEmpty()) {
            var head = list.head();
            publish(event, head._2());
            list = list.tail();
        }
    }

    private function classify(event : EnumValue) : Enum<AnyRef> {
        return event.getEnum();
    }
}
