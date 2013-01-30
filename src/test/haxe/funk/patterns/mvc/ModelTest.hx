package funk.patterns.mvc;

import funk.collections.immutable.List;
import funk.types.Option;
import funk.types.Promise;
import funk.types.extensions.Promises;

using funk.collections.immutable.extensions.Lists;
using funk.collections.immutable.extensions.ListsUtil;

class ModelTest {

	@Test
	public function test() {
		var model = new MockModel();
		var controller = new MockController(model);
		var view = new MockView(model);

		controller.get().then(function (message) {
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

	override private function get() : Promise<Option<String>> {
		return Promises.dispatch(_list.headOption());
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
