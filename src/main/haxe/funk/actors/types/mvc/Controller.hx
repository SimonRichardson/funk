package funk.actors.types.mvc;

import funk.actors.Message;
import funk.actors.types.mvc.Model;
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

    private function remove<R>(value : T) : Promise<Message<R>> {
        return _model.dispatch(Remove(value));
    }

    private function removeAt<R>(key : K) : Promise<Message<R>> {
        return _model.dispatch(RemoveAt(key));
    }

    private function sync<R>() : Promise<Message<R>> {
        return _model.dispatch(Sync);
    }

    private function update<R>(a : T, b : T) : Promise<Message<R>> {
        return _model.dispatch(Update(a, b));
    }

    private function updateAt<R>(value : T, key : K) : Promise<Message<R>> {
        return _model.dispatch(UpdateAt(value, key));
    }

	public function model<R>() : Model<T, K> {
		return _model;
	}
}
