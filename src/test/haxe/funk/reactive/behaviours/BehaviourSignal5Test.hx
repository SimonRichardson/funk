package funk.reactive.behaviours;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.reactive.behaviours.BehaviourSignal5;
import funk.reactive.extensions.Behaviours;
import funk.signal.Signal5;
import funk.types.Tuple5;
import funk.types.extensions.Tuples5;
import massive.munit.Assert;
import unit.Asserts;

using massive.munit.Assert;
using unit.Asserts;
using funk.collections.extensions.Collections;
using funk.reactive.behaviours.BehaviourSignal5;
using funk.reactive.extensions.Behaviours;
using funk.types.extensions.Tuples5;

class BehaviourSignal5Test {

	private var signal : Signal5<Int, Int, Int, Int, Int>;
	private var actual : Collection<Tuple5<Int, Int, Int, Int, Int>>;

	@Before
	public function setup() : Void {
		signal = new Signal5<Int, Int, Int, Int, Int>();
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
		signal.dispatch(1, 2, 3, 4, 5);

		actual.areIterablesEqual([tuple5(1, 2, 3, 4, 5)]);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_size_2() : Void {
		signal.dispatch(1, 2, 3, 4, 5);
		signal.dispatch(6, 7, 8, 9, 10);

		actual.size().areEqual(2);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_values() : Void {
		signal.dispatch(1, 2, 3, 4, 5);
		signal.dispatch(6, 7, 8, 9, 10);

		actual.areIterablesEqual([tuple5(1, 2, 3, 4, 5), tuple5(6, 7, 8, 9, 10)]);
	}
}
