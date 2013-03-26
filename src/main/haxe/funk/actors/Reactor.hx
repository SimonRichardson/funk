package funk.actors;

import funk.reactives.Stream;
import funk.types.AnyRef;
import funk.types.Option;

@:final
class Rector extends Actor {

    private var _stream : Stream<AnyRef>;

    public function new(actor : ActorRef) {
        var stream = StreamTypes.indentity(None);
    }

    override public function receive(value : AnyRef) : Void stream.dispatch(value);

    public function react() : Stream<AnyRef> return _stream;
}
