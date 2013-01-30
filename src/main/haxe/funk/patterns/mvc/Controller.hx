package funk.patterns.mvc;

import funk.actors.Message;
import funk.patterns.mvc.Choices;
import funk.types.Promise;

using funk.actors.extensions.Actors;

class Controller<T, K> {

	private var _model : Model<T, K>;

	public function new(model : Model<T, K>) {
		_model = model;
	}

	public function add<R>(value : T) : Promise<Message<R>> {
        return _model.dispatch(Add(value));
    }

    public function addAt<R>(value : T, key : K) : Promise<Message<R>> {
    	return _model.dispatch(AddAt(value, key));
    }

    public function get<R>() : Promise<Message<R>> {
        return _model.dispatch(Get);
    }

    public function getAt<R>(key : K) : Promise<Message<R>> {
    	return _model.dispatch(GetAt(key));
    }

	public function model() : Model<T, K> {
		return _model;
	}
}
