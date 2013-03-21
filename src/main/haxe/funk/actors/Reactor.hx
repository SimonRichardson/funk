package funk.actors;

import funk.reactives.Stream;
import funk.types.AnyRef;
import funk.types.Option;

class Rector {

    private var _stream : Stream<AnyRef>;

    public function new(actor : ActorRef) {
        var stream = StreamTypes.indentity(None);
    }

    public function react() : Stream<AnyRef> {
        return _stream;
    }
}
