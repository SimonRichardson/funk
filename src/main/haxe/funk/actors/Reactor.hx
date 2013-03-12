package funk.actors;

class Rector {

	private var _stream : Stream<T>;

    public function new(actor : ActorRef) {
    	var stream = StreamTypes.indentity(None);

    	actor.recieve(function(value) {
    		stream.dispatch(value);
    	});
    }

    public function react<T>() : Stream<T> {
        return _stream;
    }
}
