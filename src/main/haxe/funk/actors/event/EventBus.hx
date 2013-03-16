package funk.actors.event;

using funk.types.Tuple2;

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
        _subscribers = _subscribers.prepend(tuple2(to, subscriber));
    }

    public function unsubscribe<T>(subscriber : ActorRef, ?from : Class<T>) : Bool {
        _subscribers = _subscribers.filterNot(function(tuple : Tuple2<Class<ActorRef>, ActorRef>) {
            return (tuple._2() == subscriber && (!AnyTypes.toBool(from) || tuple._1() == from));
        });
    }

    public function publish<T>(event : T, subscriber : ActorRef) : Void {
    }

    public function publishEvent<T>(event : T) : Void {
        var list = _subscribers.filter(function(tuple : Tuple2<Class<ActorRef>, ActorRef>) {
            return tuple._1() == event;
        });
        while(list.isNonEmpty()) {
            var head = list.head();
            publish(event, head);
            list = list.tail();
        }
    }
}
