package funk.actors.types.mvc;

import funk.collections.immutable.List;
import funk.types.Option;
import funk.types.Promise;
import funk.types.extensions.Promises;

using funk.collections.immutable.extensions.Lists;
using funk.collections.immutable.extensions.ListsUtil;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Options;

class ModelTest {

	@Test
	public function test() {
		var model = new MockModel();
		var controller = new MockController(model);
		var view = new MockView(model);

		controller.addAt("Ducky", 1).then(function (message) {
			trace(message);
		});	
	}
}

private class MockModel extends Model<String, Int> {

	private var _list : List<String>;

	public function new() {
		super();

		_list = "Hello, world!".toList();
	}

	override private function add(value : String) : Promise<Option<String>> {
		_list = _list.append(value);
		return Promises.dispatch(value.toOption());
	}

	override private function addAt(value : String, key : Int) : Promise<Option<String>> {
		_list = _list.insert(value, key);
		return Promises.dispatch(value.toOption());
	}

	override private function get() : Promise<Option<String>> {
		return Promises.dispatch(_list.headOption());
	}

	override private function getAt(value : Int) : Promise<Option<String>> {
		return Promises.dispatch(_list.get(value));
	}

	override private function data<R>() : Option<R> {
		return cast Some(_list);
	}
}

private class MockController extends Controller<String, Int> {

	public function new(model : Model<String, Int>) {
		super(model);
	}
}

private class MockView extends View<String, Int> {

	public function new(model : Model<String, Int>) {
		super(model);
	}
}
