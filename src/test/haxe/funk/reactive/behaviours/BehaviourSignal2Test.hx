package funk.reactive.behaviours;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

import funk.reactive.behaviours.BehaviourSignal2;
import funk.signal.Signal2;
import funk.tuple.Tuple2;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

using funk.reactive.behaviours.BehaviourSignal2;
using funk.tuple.Tuple2;

class BehaviourSignal2Test {

	private var signal : Signal2<Int, Int>;
	private var actual : StreamValues<ITuple2<Int, Int>>;

	@Before
	public function setup() : Void {
		signal = new Signal2<Int, Int>();
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
		signal.dispatch(1, 2);

		actual.valuesEqualsIterable([tuple2(1, 2).toInstance()]);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_size_2() : Void {
		signal.dispatch(1, 2);
		signal.dispatch(3, 4);

		actual.size.areEqual(2);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_values() : Void {
		signal.dispatch(1, 2);
		signal.dispatch(3, 4);

		actual.valuesEqualsIterable([tuple2(1, 2).toInstance(), tuple2(3, 4).toInstance()]);
	}
}
