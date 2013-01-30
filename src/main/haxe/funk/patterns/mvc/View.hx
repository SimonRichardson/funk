package funk.patterns.mvc;

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
	}

	private function model() : Model<T, K> {
		return _model;
	}
}
