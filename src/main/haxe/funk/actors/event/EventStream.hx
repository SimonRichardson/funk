package funk.actors.event;

import funk.Funk;
import funk.actors.ActorSystem;

using funk.types.Any;
using funk.types.AnyRef;

class EventStream {

    public function new() {
    }

    public static function fromActorSystem(system : ActorSystem) : EventStream {
        return system.eventStream();
    }

    public function dispatch(event : AnyRef) : Void {
        trace(event);
    }
}
