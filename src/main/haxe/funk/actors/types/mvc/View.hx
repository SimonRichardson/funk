package funk.actors.types.mvc;

import funk.actors.Actor;
import funk.actors.Message;
import funk.types.Promise;

using funk.actors.extensions.Actors;
using funk.reactive.extensions.Streams;

class View<T, K> extends Actor<T> {

    private var _model : Model<T, K>;

	public function new(model : Model<T, K>) {
        super();

		_model = model;
		_model.react().foreach(handle);
	}

	private function handle<R>(value : R) : Void {
		
	}

	private function model() : Model<T, K> {
		return _model;
	}
}
