package funk.patterns.mvc;

import funk.actors.Actor;
import funk.patterns.mvc.Observable;

using funk.actors.extensions.Actors;

class View<T, K> extends Actor<T, K> {

    private var _model : Model<T, K>;

	public function new(model : Model<T, K>) {
        super();

		_model = model;
		_model.dispatch(AddListener(this));
	}
}
