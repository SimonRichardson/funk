package funk.actors.types.mvc;

import funk.actors.Message;
import funk.actors.types.mvc.Model;
import funk.types.Promise;

using funk.actors.extensions.Actors;

class Controller<T, K> {

    public var model(get_model, set_model) : Model<T, K>;

	private var _model : Model<T, K>;

	public function new() {

	}

	public function add<R>(value : T) : Promise<Message<R>> {
        return model.dispatch(Add(value));
    }

    public function addAt<R>(value : T, key : K) : Promise<Message<R>> {
    	return model.dispatch(AddAt(value, key));
    }

    public function get<R>() : Promise<Message<R>> {
        return model.dispatch(Get);
    }

    public function getAt<R>(key : K) : Promise<Message<R>> {
    	return model.dispatch(GetAt(key));
    }

    private function remove<R>(value : T) : Promise<Message<R>> {
        return model.dispatch(Remove(value));
    }

    private function removeAt<R>(key : K) : Promise<Message<R>> {
        return model.dispatch(RemoveAt(key));
    }

    private function sync<R>() : Promise<Message<R>> {
        return model.dispatch(Sync);
    }

    private function update<R>(a : T, b : T) : Promise<Message<R>> {
        return model.dispatch(Update(a, b));
    }

    private function updateAt<R>(value : T, key : K) : Promise<Message<R>> {
        return model.dispatch(UpdateAt(value, key));
    }

    private function get_model() : Model<T, K> {
        return _model;
    }

    private function set_model(value : Model<T, K>) : Model<T, K> {
        _model = value;
        return _model;
    }
}
