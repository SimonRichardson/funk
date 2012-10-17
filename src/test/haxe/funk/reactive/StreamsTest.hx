package funk.reactive;

import massive.munit.Assert;

using massive.munit.Assert;

class StreamsTest {

	@Test
	public function when_creating_a_stream__should_calling_foreach_equal_value_7() : Void {
		var counter = 0;

		var stream = Streams.identity();
		stream.forEach(function(v) {
			counter++;
		});


	}

}
