package funk.reactive.behaviours;

import massive.munit.Assert;
import util.AssertExtensions;

import funk.Funk;
import funk.reactive.behaviours.BehaviourSignal0;
import funk.signal.Signal0;
import funk.tuple.Tuple1;

using massive.munit.Assert;
using util.AssertExtensions;

using funk.reactive.behaviours.BehaviourSignal0;
using funk.tuple.Tuple1;

class BehaviourSignal0Test {

	private var signal : Signal0;
	private var actual : StreamValues<ITuple1<Unit>>;

	@Before
	public function setup() : Void {
		signal = new Signal0();
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
		signal.dispatch();

		actual.valuesEqualsIterable([tuple1(Unit).toInstance()]);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_size_2() : Void {
		signal.dispatch();
		signal.dispatch();

		actual.size.areEqual(2);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_values() : Void {
		signal.dispatch();
		signal.dispatch();

		actual.valuesEqualsIterable([tuple1(Unit).toInstance(), tuple1(Unit).toInstance()]);
	}
}
