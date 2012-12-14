package funk.reactive.behaviours;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.reactive.behaviours.BehaviourSignal3;
import funk.reactive.extensions.Behaviours;
import funk.signals.Signal3;
import funk.types.Tuple3;
import funk.types.extensions.Tuples3;
import massive.munit.Assert;
import unit.Asserts;

using massive.munit.Assert;
using unit.Asserts;
using funk.collections.extensions.Collections;
using funk.reactive.behaviours.BehaviourSignal3;
using funk.reactive.extensions.Behaviours;
using funk.types.extensions.Tuples3;

class BehaviourSignal3Test {

	private var signal : Signal3<Int, Int, Int>;
	private var actual : Collection<Tuple3<Int, Int, Int>>;

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
		actual.size().areEqual(0);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_new_values() : Void {
		signal.dispatch(1, 2, 3);

		actual.areIterablesEqual([tuple3(1, 2, 3)]);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_size_2() : Void {
		signal.dispatch(1, 2, 3);
		signal.dispatch(4, 5, 6);

		actual.size().areEqual(2);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_values() : Void {
		signal.dispatch(1, 2, 3);
		signal.dispatch(4, 5, 6);

		actual.areIterablesEqual([tuple3(1, 2, 3), tuple3(4, 5, 6)]);
	}
}
