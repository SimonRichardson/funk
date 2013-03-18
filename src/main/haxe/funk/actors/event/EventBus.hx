package funk.actors.event;

using funk.collections.immutable.List;
using funk.types.Tuple2;
using funk.types.Any;
using funk.types.AnyRef;

typedef EventBus = {

    function subscribe(subscriber : ActorRef) : Bool;

    function unsubscribe(subscriber : ActorRef) : Bool;

    function publish<T>(event : T, subscriber : ActorRef) : Void;
};

class LookupClassification {

    private var _subscribers : List<Tuple2<Class<ActorRef>, ActorRef>>;

    public function new() {
        _subscribers = Nil;
    }

    public function subscribe<T>(subscriber : ActorRef, to : Class<T>) : Bool {
        var found = _subscribers.find(function(tuple) {
            return (tuple._2() == subscriber && (!AnyTypes.toBool(to) || tuple._1() == to));
        });

        return if (!found) {
            _subscribers = _subscribers.prepend(tuple2(to, subscriber));
            true;
        } else false;
    }

    public function unsubscribe<T>(subscriber : ActorRef, ?from : Class<T>) : Bool {
        var original = _subscribers;
        _subscribers = original.filterNot(function(tuple : Tuple2<Class<ActorRef>, ActorRef>) {
            return (tuple._2() == subscriber && (!AnyTypes.toBool(from) || tuple._1() == from));
        });
        return _subscribers == original;
    }

    public function publish<T>(event : T, subscriber : ActorRef) : Void {
    }

    public function publishEvent<T>(event : T) : Void {
        var list = _subscribers.filter(function(tuple : Tuple2<Class<ActorRef>, ActorRef>) {
            return tuple._1() == event;
        });
        while(list.nonEmpty()) {
            var head = list.head();
            publish(event, head._2());
            list = list.tail();
        }
    }
}
