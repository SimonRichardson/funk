package funk.patterns.mvc;

class ModelTest {

	@Test
	public function test() {
		var model = new MockModel();
		var controller = new MockController(model);
		var view = new MockView(model);

		controller.get().then(function (value) {
			trace(value);
		});
	}
}

private class MockModel<T> extends Model<T, Int> {

	public function new() {
		super();
	}
}

private class MockController<T> extends Controller<T, Int> {

	public function new(model : Model<T, Int>) {
		super(model);
	}
}

private class MockView<T> extends View<T, Int> {

	public function new(model : Model<T, Int>) {
		super(model);
	}
}
