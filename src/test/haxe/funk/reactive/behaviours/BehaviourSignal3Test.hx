package funk.reactive.behaviours;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

import funk.reactive.behaviours.BehaviourSignal3;
import funk.signal.Signal3;
import funk.tuple.Tuple3;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

using funk.reactive.behaviours.BehaviourSignal3;
using funk.tuple.Tuple3;

class BehaviourSignal3Test {

	private var signal : Signal3<Int, Int, Int>;
	private var actual : StreamValues<ITuple3<Int, Int, Int>>;

	@Before
	public function setup() : Void {
		signal = new Signal3<Int, Int, Int>();
		actual = signal.signal().values();
	}

	@After
	public function tearDown() : Void {
		actual = null;
	}

	@Test
	public function when_creating_a_new_stream__should_not_be_null() : Void {
		actual.isNotNull();
	}

	@Test
	public function when_creating_a_new_stream__should_be_size_0() : Void {
		actual.size.areEqual(0);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_new_values() : Void {
		signal.dispatch(1, 2, 3);

		actual.valuesEqualsIterable([tuple3(1, 2, 3).toInstance()]);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_size_2() : Void {
		signal.dispatch(1, 2, 3);
		signal.dispatch(4, 5, 6);

		actual.size.areEqual(2);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_values() : Void {
		signal.dispatch(1, 2, 3);
		signal.dispatch(4, 5, 6);

		actual.valuesEqualsIterable([tuple3(1, 2, 3).toInstance(), tuple3(4, 5, 6).toInstance()]);
	}
}
