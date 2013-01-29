package funk.patterns.mvc;

class ModelTest {

	@Test
	public function test() {
		var model = new MockModel();
		var controller = new MockController(model);
		var view = new MockView(model);

		controller.state(1);
	}
}

private class MockModel<T> extends Model<T> {

	public function new() {
		super();
	}

	override private function handle(deferred : Deferred, value : T) : Void {
		trace("NOWT");
	}
}

private class MockController<T> extends Controller<T> {

	public function new(model : Model<T>) {
		super(model);
	}

	public function state(value : T) : Void {
		model().send(GetState).to(model()).then(function (val : T) {
			if (val != value) {
				model().send(SetState(value)).to(model());
			}
		});
	}
}

private class MockView<T> extends View<T> {

	public function new(model : Model<T>) {
		super(model);
	}

	override private function handle(deferred : Deferred, value : T) : Void {
		trace("HERE");
	}
}