package funk.reactive.behaviours;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

import funk.reactive.behaviours.BehaviourSignal1;
import funk.signal.Signal1;
import funk.tuple.Tuple1;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

using funk.reactive.behaviours.BehaviourSignal1;
using funk.tuple.Tuple1;

class BehaviourSignal1Test {

	private var signal : Signal1<Int>;
	private var actual : StreamValues<ITuple1<Int>>;

	@Before
	public function setup() : Void {
		signal = new Signal1<Int>();
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
		signal.dispatch(1);

		actual.valuesEqualsIterable([tuple1(1).toInstance()]);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_size_2() : Void {
		signal.dispatch(1);
		signal.dispatch(2);

		actual.size.areEqual(2);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_values() : Void {
		signal.dispatch(1);
		signal.dispatch(2);

		actual.valuesEqualsIterable([tuple1(1).toInstance(), tuple1(2).toInstance()]);
	}
}
