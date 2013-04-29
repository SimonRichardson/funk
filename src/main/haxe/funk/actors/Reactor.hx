package funk.actors;

import funk.types.Any;
import funk.types.Option;

using funk.reactives.Stream;

class Reactor extends Actor {

    private var _stream : Stream<AnyRef>;

    public function new() {
        super();

        _stream = StreamTypes.identity(None);
    }

    @:final
    override public function receive(value : AnyRef) : Void {
        onReceive(value);
        _stream.dispatch(value);
    }

    public function onReceive(value : AnyRef) : Void {}

    public function react() : Stream<AnyRef> return _stream;
}
