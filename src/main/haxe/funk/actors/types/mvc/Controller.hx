package funk.actors.types.mvc;

import funk.actors.Message;
import funk.actors.types.mvc.Model;
import funk.collections.immutable.List;
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

    public function addAll<R>(value : List<T>) : Promise<Message<R>> {
        return model.dispatch(AddAll(value));
    }

    public function get<R>() : Promise<Message<R>> {
        return model.dispatch(Get);
    }

    public function findByKey<R>(key : K) : Promise<Message<R>> {
        return model.dispatch(FindByKey(key));
    }

    public function findByValue<R>(value : T) : Promise<Message<R>> {
        return model.dispatch(FindByValue(value));
    }

    public function getAt<R>(key : K) : Promise<Message<R>> {
    	return model.dispatch(GetAt(key));
    }

    public function getAll<R>() : Promise<Message<R>> {
        return model.dispatch(GetAll);
    }

    public function remove<R>(value : T) : Promise<Message<R>> {
        return model.dispatch(Remove(value));
    }

    public function removeAt<R>(key : K) : Promise<Message<R>> {
        return model.dispatch(RemoveAt(key));
    }

    public function removeAll<R>() : Promise<Message<R>> {
        return model.dispatch(RemoveAll);
    }

    public function sync<R>() : Promise<Message<R>> {
        return model.dispatch(Sync);
    }

    public function update<R>(a : T, b : T) : Promise<Message<R>> {
        return model.dispatch(Update(a, b));
    }

    public function updateAll<R>(value : T) : Promise<Message<R>> {
        return model.dispatch(UpdateAll(value));
    }

    public function updateAt<R>(value : T, key : K) : Promise<Message<R>> {
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
