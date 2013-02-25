package funk.actors.types.mvc;

import funk.collections.immutable.List;
import haxe.ds.Option;
import funk.types.Promise;
import funk.types.extensions.Promises;

using funk.actors.extensions.Messages;
using funk.collections.immutable.extensions.Lists;
using funk.collections.immutable.extensions.ListsUtil;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Options;
using massive.munit.Assert;
using unit.Asserts;

class ModelTest {

	private var model : MockModel;

	private var controller : MockController;

	private var view : MockView;

	@Before
	public function setup() {
		model = new MockModel();
		controller = new MockController();
		view = new MockView();

		controller.model = model;
		view.model = model;
	}

	@Test
	public function when_calling_add_should_return_actual_value() {
		var expected = 'Hello';
		var actual = '';

		controller.add(expected).then(function (message) {
			actual = message.body().get();
		});

		actual.areEqual(expected);
	}

	@Test
	public function when_calling_addAt_1_should_return_actual_value() {
		var expected = 'Hello';
		var actual = '';

		controller.addAt(expected, 1).then(function (message) {
			actual = message.body().get();
		});

		actual.areEqual(expected);
	}

	@Test
	public function when_calling_addAll_should_return_actual_value() {
		var expected = Cons('1', Cons('2', Cons('3', Nil)));
		var actual = Nil;

		controller.addAll(expected).then(function (message) {
			actual = message.body().get();
		});

		actual.areEqual(expected);
	}

	@Test
	public function when_calling_get_should_return_actual_value() {
		var expected = 'H';
		var actual = '';

		controller.get().then(function (message) {
			actual = message.body().get();
		});

		actual.areEqual(expected);
	}

	@Test
	public function when_calling_getAt_should_return_actual_value() {
		var expected = 'o';
		var actual = '';

		controller.getAt(4).then(function (message) {
			actual = message.body().get();
		});

		actual.areEqual(expected);
	}

	@Test
	public function when_calling_remove_should_return_actual_value() {
		var expected = 'w';
		var actual = '';

		controller.remove(expected).then(function (message) {
			actual = message.body().get();
		});

		actual.areEqual(expected);
	}

	@Test
	public function when_calling_removeAt_should_return_actual_value() {
		var expected = 'o';
		var actual = '';

		controller.removeAt(4).then(function (message) {
			actual = message.body().get();
		});

		actual.areEqual(expected);
	}

	@Test
	public function when_calling_removeAll_should_return_actual_value() {
		var expected = 'Hello, world!'.toList();
		var actual = '';

		controller.removeAll().then(function (message) {
			actual = message.body().get();
		});

		actual.areEqual(expected);
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

	override private function addAll(value : List<String>) : Promise<Option<List<String>>> {
		_list = _list.appendAll(value);
		return Promises.dispatch(value.toOption());
	}

	override private function get() : Promise<Option<String>> {
		return Promises.dispatch(_list.headOption());
	}

	override private function getAt(value : Int) : Promise<Option<String>> {
		return Promises.dispatch(_list.get(value));
	}

	override private function remove(value : String) : Promise<Option<String>> {
		_list = _list.filter(function(val) {
			return val == value;
		});
		return Promises.dispatch(_list.find(function(val) {
			return val == value;
		}));
	}

	override private function removeAt(key : Int) : Promise<Option<String>> {
		return switch(_list.get(key)) {
			case Some(value):
				_list = _list.filter(function(val) {
					return value == val;
				});
				Promises.dispatch(value.toOption());
			case None: Promises.dispatch(None);
		}
	}

	override private function removeAll() : Promise<Option<List<String>>> {
		var list = _list;
		_list = Nil;
		return Promises.dispatch(list.toOption());
	}

	override private function data<R>() : Option<R> {
		return cast Some(_list);
	}
}

private class MockController extends Controller<String, Int> {

	public function new() {
		super();
	}
}

private class MockView extends View<String, Int> {

	public function new() {
		super();
	}
}
