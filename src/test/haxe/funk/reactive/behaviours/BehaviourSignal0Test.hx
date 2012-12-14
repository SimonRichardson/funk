package funk.reactive.behaviours;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.reactive.behaviours.BehaviourSignal0;
import funk.reactive.extensions.Behaviours;
import funk.signals.Signal0;
import funk.types.Tuple1;
import funk.types.extensions.Tuples1;
import massive.munit.Assert;
import unit.Asserts;

using massive.munit.Assert;
using unit.Asserts;
using funk.collections.extensions.Collections;
using funk.reactive.behaviours.BehaviourSignal0;
using funk.reactive.extensions.Behaviours;
using funk.types.extensions.Tuples1;

class BehaviourSignal0Test {

	private var signal : Signal0;
	private var actual : Collection<Tuple1<Unit>>;

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
		actual.size().areEqual(0);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_new_values() : Void {
		signal.dispatch();

		actual.areIterablesEqual([tuple1(Unit)]);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_size_2() : Void {
		signal.dispatch();
		signal.dispatch();

		actual.size().areEqual(2);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_values() : Void {
		signal.dispatch();
		signal.dispatch();

		actual.areIterablesEqual([tuple1(Unit), tuple1(Unit)]);
	}
}
