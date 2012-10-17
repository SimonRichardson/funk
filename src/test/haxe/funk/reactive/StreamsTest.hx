package funk.reactive;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

class StreamsTest {

	private var stream : Stream<Dynamic>;

	@Before
	public function setup() {
		stream = Streams.identity();
	}

	@After
	public function tearDown() {
		stream = null;
	}

	@Test
	public function when_creating_a_stream__should_calling_foreach_equal_7() : Void {
		var counter = 0;

		var eventStream = stream.forEach(function(v) {
			counter++;
		});

		var iter : Iterable<Int> = [1, 2, 3, 4, 5, 6, 7];
		var result = eventStream.toArray();
    	for(item in iter) {
        	stream.emit(item);
    	}

    	counter.areEqual(7);
	}

	@Test
	public function when_creating_a_stream__should_calling_toArray() : Void {
		var array = stream.toArray();

        var iter: Iterable<Int> = [1, 2, 3, 4, 5];
        for(item in iter) {
        	stream.emit(item);
        }

        array.arrayEquals([1, 2, 3, 4, 5]);
	}

	@Test
	public function when_creating_a_stream__should_calling_constant_with_3_return_3_3_3() : Void {
		var total = 3;
		var array = stream.constant(total).toArray();

        for(index in 0...total) {
        	stream.emit(index);
        }

        array.arrayEquals([3, 3, 3]);
	}

	@Test
	public function when_creating_a_stream__should_calling_bind_with_3_streams() : Void {
		var stream0 = Streams.identity();
		var stream1 = Streams.identity();
		var stream2 = Streams.identity();

		var bound = stream.bind(function(x) {
			return switch(x) {
				case 0: stream0;
				case 1: stream1;
				case 2: stream2;
			};
		});

		var array = bound.toArray();

		stream.emit(0);
		stream0.emit(123);

		array.pop().areEqual(123);
	}
}
