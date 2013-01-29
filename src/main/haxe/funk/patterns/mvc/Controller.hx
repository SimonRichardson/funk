package funk.patterns.mvc;

import funk.patterns.mvc.Choices;
import funk.types.Promise;

class Controller<T, K> {

	private var _model : Model<T, K>;

	public function new(model : Model<T, K>) {
		_model = model;
	}

    public function get() : Promise<T> {
        return cast _model.send(Get).to(Some(_model));
    }

	public function model() : Model<T, K> {
		return _model;
	}
}
