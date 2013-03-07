package funk.reactive;

import funk.reactive.Stream;
import funk.reactive.extensions.Behaviours;
import funk.reactive.extensions.Streams;
import massive.munit.Assert;
import unit.Asserts;

using funk.reactive.extensions.Streams;
using massive.munit.Assert;
using unit.Asserts;

class StreamsTest extends ProcessAsyncBase {

	private var stream : Stream<Dynamic>;

	@Before
	override public function setup() {
		super.setup();

		stream = Streams.random(Behaviours.constant(1.0));
	}

	@After
	override public function tearDown() {
		stream = null;
	}

	@Test
	public function when_creating_a_random_stream__should_not_be_null() : Void {
		stream.isNotNull();
	}

	@Test
	public function when_creating_a_random_stream__should_result_in_a_random_stream() : Void {
		var randoms = stream.values();

		advanceProcessByWithIncrements(1, 4);

		randoms.size().areEqual(4);
	}
}
