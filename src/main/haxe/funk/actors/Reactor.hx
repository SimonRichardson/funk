package funk.actors;

class Rector {

    private var _stream : Stream<EnumValue>;

    public function new(actor : ActorRef) {
        var stream = StreamTypes.indentity(None);

        actor.recieve(function(value) {
            stream.dispatch(value);
        });
    }

    public function react() : Stream<EnumValue> {
        return _stream;
    }
}
