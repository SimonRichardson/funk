package funk.actors.events;

import funk.Funk;
import funk.actors.ActorSystem;
import haxe.ds.StringMap;

using funk.types.Any;
using funk.types.Tuple2;
using funk.types.Option;
using funk.collections.immutable.Map;
using funk.collections.immutable.List;

typedef Event = AnyRef;
typedef Classifier = AnyRef;
typedef Subscriber = ActorRef;

class EventBus {

    private var _subscriptions : Map<String, List<Subscriber>>;

    public function new() {
        _subscriptions = Empty;
    }

    public function subscribe(subscriber : Subscriber, to : Classifier) : Bool {
        var result = true;
        var toName = AnyTypes.getName(to);
        var list = _subscriptions.exists(toName) ? _subscriptions.get(toName).get() : Nil;
        list = list.filterNot(function(value) return (value == subscriber));
        _subscriptions = _subscriptions.add(toName, list.append(subscriber));
        return true;
    }

    public function unsubscribe(subscriber : Subscriber, from : Classifier) : Bool {
        var fromName = AnyTypes.getName(from);
        return if (_subscriptions.exists(fromName)) {
            var sub0 = _subscriptions.exists(fromName) ? _subscriptions.get(fromName).get() : Nil;
            var sub1 = sub0.filterNot(function(value) return (value == subscriber));    
            _subscriptions = _subscriptions.add(fromName, sub1);
            sub0 != sub1;
        } else false;
    }

    public function unsubscribeFromAll(subscriber : Subscriber) : Void {
        var indices = _subscriptions.indices().iterator();
        var sub = _subscriptions;
        for(i in indices) {
            var list = sub.get(i).get();
            list = list.filterNot(function(value) return (value == subscriber));
            sub = sub.add(i, list);
        }
        _subscriptions = sub;
    }

    public function publish(event : Event) : Void {
        var c = classify(event);
        var list = _subscriptions.exists(c) ? _subscriptions.get(c).get() : Nil;
        // Faster to do it this way.
        while(list.nonEmpty()) {
            publishEvent(event, list.head());
            list = list.tail();
        }
    }

    private function publishEvent(event : Event, subscriber : Subscriber) : Void {}

    private function classify(event : Event) : Classifier return AnyTypes.getName(event);
}
