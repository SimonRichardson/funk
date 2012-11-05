package funk.reactive.behaviours;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

import funk.reactive.behaviours.BehaviourSignal4;
import funk.signal.Signal4;
import funk.tuple.Tuple4;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

using funk.reactive.behaviours.BehaviourSignal4;
using funk.tuple.Tuple4;

class BehaviourSignal4Test {

	private var signal : Signal4<Int, Int, Int, Int>;
	private var actual : StreamValues<ITuple4<Int, Int, Int, Int>>;

	@Before
	public function setup() : Void {
		signal = new Signal4<Int, Int, Int, Int>();
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
		signal.dispatch(1, 2, 3, 4);

		actual.valuesEqualsIterable([tuple4(1, 2, 3, 4).toInstance()]);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_size_2() : Void {
		signal.dispatch(1, 2, 3, 4);
		signal.dispatch(5, 6, 7, 8);

		actual.size.areEqual(2);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_values() : Void {
		signal.dispatch(1, 2, 3, 4);
		signal.dispatch(5, 6, 7, 8);

		actual.valuesEqualsIterable([tuple4(1, 2, 3, 4).toInstance(), tuple4(5, 6, 7, 8).toInstance()]);
	}
}
