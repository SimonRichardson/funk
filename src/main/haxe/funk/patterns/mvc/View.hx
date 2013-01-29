package funk.patterns.mvc;

class View<T> {
	
	public function new(model : Model<T>) {
		_model = model;
		_model.send(AddListener(this));
	}
}