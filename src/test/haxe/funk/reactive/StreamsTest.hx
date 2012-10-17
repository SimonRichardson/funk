package funk.reactive;

import massive.munit.Assert;

using massive.munit.Assert;

class StreamsTest {

	@Test
	public function when_creating_a_stream__should_calling_foreach_equal_value_7() : Void {
		var counter = 0;

		var stream = Streams.identity();
		var eventStream = stream.forEach(function(v) {
			trace(v);
			counter++;
		});

		var iter : Iterable<Int> = [1, 2, 3, 4, 5, 6, 7];
		var result = eventStream.toArray();
    	for (e in iter) {
        	stream.emit(e);
    	}

    	counter.areEqual(7);
	}


}
