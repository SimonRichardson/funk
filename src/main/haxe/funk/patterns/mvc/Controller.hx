package funk.patterns.mvc;

class Controller<T> {
	
	private var _model : Model<T>;

	public function new(model : Model<T>) {
		_model = model;
	}

	public function model() : Model<T> {
		return _model;
	}
}