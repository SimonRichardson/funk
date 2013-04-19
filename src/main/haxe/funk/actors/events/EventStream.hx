package funk.actors.events;

import funk.Funk;
import funk.actors.ActorSystem;
import funk.actors.events.EventBus;
import haxe.ds.ObjectMap;
import funk.io.logging.LogLevel;
import funk.io.logging.LogValue;

using funk.io.logging.Logging;
using funk.types.Any;
using funk.types.AnyRef;
using funk.types.Tuple2;
using funk.collections.immutable.List;

class EventStream extends LoggingBus {

    private var _debug : Bool;

    public function new(debug : Bool = false) {
        super();

        _debug = debug;
    }

    override public function subscribe(subscriber : Subscriber, to : Classifier) : Bool {
        if (!subscriber.toBool()) Funk.error(ArgumentError('subscriber is null'));
        if (_debug) publish(Data(Debug, '${this.simpleName()}, subscribing ${subscriber} to channel ${to}'));
        return super.subscribe(subscriber, to);
    }

    override public function unsubscribe(subscriber : Subscriber, from : Classifier) : Bool {
        if (!subscriber.toBool()) Funk.error(ArgumentError('subscriber is null'));
        var result = super.unsubscribe(subscriber, from);
        if (_debug) publish(Data(Debug, '${this.simpleName()}, unsubscribing ${subscriber} from channel ${from}'));
        return result;
    }

    override public function unsubscribeFromAll(subscriber : Subscriber) : Void {
        if (!subscriber.toBool()) Funk.error(ArgumentError('subscriber is null'));
        super.unsubscribeFromAll(subscriber);
        if (_debug) publish(Data(Debug, '${this.simpleName()}, unsubscribing ${subscriber} from all channels'));
    }

    override private function publishEvent(event : Event, subscriber : Subscriber) : Void {
        if (subscriber.isTerminated()) unsubscribeFromAll(subscriber);
        else subscriber.send(event);
    }
}
