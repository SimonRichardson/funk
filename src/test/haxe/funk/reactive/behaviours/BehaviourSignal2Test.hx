package funk.reactive.behaviours;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.reactive.behaviours.BehaviourSignal2;
import funk.reactive.extensions.Behaviours;
import funk.signal.Signal2;
import funk.types.Tuple2;
import funk.types.extensions.Tuples2;
import massive.munit.Assert;
import unit.Asserts;

using massive.munit.Assert;
using unit.Asserts;
using funk.collections.extensions.Collections;
using funk.reactive.behaviours.BehaviourSignal2;
using funk.reactive.extensions.Behaviours;
using funk.types.extensions.Tuples2;

class BehaviourSignal2Test {

	private var signal : Signal2<Int, Int>;
	private var actual : Collection<Tuple2<Int, Int>>;

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
		actual.size().areEqual(0);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_new_values() : Void {
		signal.dispatch(1, 2);

		actual.areIterablesEqual([tuple2(1, 2)]);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_size_2() : Void {
		signal.dispatch(1, 2);
		signal.dispatch(3, 4);

		actual.size().areEqual(2);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_values() : Void {
		signal.dispatch(1, 2);
		signal.dispatch(3, 4);

		actual.areIterablesEqual([tuple2(1, 2), tuple2(3, 4)]);
	}
}
