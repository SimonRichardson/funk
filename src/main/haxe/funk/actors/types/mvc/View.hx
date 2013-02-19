package funk.actors.types.mvc;

import funk.actors.Actor;
import funk.actors.Message;
import funk.types.Promise;
import funk.types.Tuple2;
import funk.actors.types.mvc.Model;

using funk.actors.extensions.Actors;
using funk.reactive.extensions.Streams;

class View<T, K> extends Actor<T> {

	public var model(get_model, set_model) : Model<T, K>;

    private var _model : Model<T, K>;

	public function new() {
        super();
	}

	private function handle<R>(value : Tuple2<Requests<T, K>, R>) : Void {

	}

	private function get_model() : Model<T, K> {
        return _model;
    }

    private function set_model(value : Model<T, K>) : Model<T, K> {
        _model = value;
        _model.react().foreach(cast handle);
        return _model;
    }
}
