package funk.patterns.mvc;

import funk.patterns.mvc.Choices;
import funk.types.Promise;

using funk.actors.extensions.Actors;

class Controller<T, K> {

	private var _model : Model<T, K>;

	public function new(model : Model<T, K>) {
		_model = model;
	}

	public function add(value : T) : Promise<T> {
        return cast _model.echo(Add(value));
    }

    public function addAt(value : T, key : K) : Promise<T> {
    	return cast _model.echo(AddAt(value, key));
    }

    public function get() : Promise<T> {
        return cast _model.echo(Get);
    }

    public function getAt(key : K) : Promise<T> {
    	return cast _model.echo(GetAt(key));
    }

	public function model() : Model<T, K> {
		return _model;
	}
}
