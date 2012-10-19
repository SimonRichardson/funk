package funk.reactive;

import massive.munit.Assert;
import massive.munit.AssertExtensions;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

class StreamTest {

	private static var MAX_TIMEOUT : Int = 2000;

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
	public function when_creating_a_stream__should_stream_be_empty() : Void {
		var array = stream.toArray();
		array.length.areEqual(0);
	}

	@Test
	public function when_creating_a_stream__should_calling_emit_result_in_same_1() : Void {
		var value = 1.1;

		var array = stream.toArray();
		stream.emit(value);
		array.pop().areEqual(value);
	}

	@Test
	public function when_creating_a_stream__should_calling_emit_result_in_same_string() : Void {
		var value = "string";

		var array = stream.toArray();
		stream.emit(value);
		array.pop().areEqual(value);
	}

	@Test
	public function when_creating_a_stream__should_calling_emit_result_in_same_instance() : Void {
		var value = {};

		var array = stream.toArray();
		stream.emit(value);
		array.pop().areEqual(value);
	}

	@Test
	public function when_creating_stream_with_true__should_return_value_of_true() : Void {
		var result : Bool = stream.startsWith(true).value;
		result.isTrue();
	}

	@Test
	public function when_creating_stream__should_calling_map_mutliply_each_value_by_2() : Void {
		var mapped = stream.map(function(v){
			return v * 2;
		});

		var array = mapped.toArray();

		var iter: Iterable<Int> = [1, 2, 3, 4, 5, 6, 7];
        for(item in iter) {
        	stream.emit(item);
        }

        array.arrayEquals([2, 4, 6, 8, 10, 12, 14]);
	}

	@Test
	public function when_creating_a_stream__should_calling_flatMap_with_3_streams_emit_first_stream_with_123() : Void {
		var stream0 = Streams.identity();
		var stream1 = Streams.identity();
		var stream2 = Streams.identity();

		var bound = stream.flatMap(function(x) {
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

	@Test
	public function when_creating_a_stream__should_calling_flatMap_with_3_streams_emit_third_stream_with_789() : Void {
		var stream0 = Streams.identity();
		var stream1 = Streams.identity();
		var stream2 = Streams.identity();

		var bound = stream.flatMap(function(x) {
			return switch(x) {
				case 0: stream0;
				case 1: stream1;
				case 2: stream2;
			};
		});

		var array = bound.toArray();

		stream.emit(2);
		stream2.emit(789);

		array.pop().areEqual(789);
	}

	@Test
	public function when_creating_a_stream__should_calling_flatMap_with_3_streams_emit_on_stream_but_not_on_mapped() : Void {
		var stream0 = Streams.identity();
		var stream1 = Streams.identity();
		var stream2 = Streams.identity();

		var bound = stream.flatMap(function(x) {
			return switch(x) {
				case 0: stream0;
				case 1: stream1;
				case 2: stream2;
			};
		});

		var array = bound.toArray();

		stream.emit(0);

		array.length.areEqual(0);
	}

	@Test
	public function when_creating_a_stream__should_calling_zip_two_streams_together() : Void {
		var zipped = stream.zip(stream).map(function(tuple) {
			return tuple._1 * tuple._2;
		});

		var array = zipped.toArray();

		var iter: Iterable<Int> = [1, 2, 3, 4, 5, 6, 7];
        for(item in iter) {
        	stream.emit(item);
        }

        array.arrayEquals([1, 4, 9, 16, 25, 36, 49]);
	}

	@Test
	public function when_creating_a_stream__should_calling_shift_with_2_removes_2_items() : Void {
		var shifted = stream.shift(2);

		var array = shifted.toArray();

		var iter: Iterable<Int> = [1, 2, 3, 4, 5, 6, 7];
        for(item in iter) {
        	stream.emit(item);
        }

        array.arrayEquals([1, 2, 3, 4, 5]);	
	}

	@Test
	public function when_creating_a_stream__should_calling_shift_with_2_has_length_of_5() : Void {
		var shifted = stream.shift(2);

		var array = shifted.toArray();

		var iter: Iterable<Int> = [1, 2, 3, 4, 5, 6, 7];
        for(item in iter) {
        	stream.emit(item);
        }

        array.length.areEqual(5);
	}

	@Test
	public function when_creating_a_stream__should_calling_shift_with_5_removes_5_items() : Void {
		var shifted = stream.shift(5);

		var array = shifted.toArray();

		var iter: Iterable<Int> = [1, 2, 3, 4, 5, 6, 7];
        for(item in iter) {
        	stream.emit(item);
        }

        array.arrayEquals([1, 2]);	
	}

	@Test
	public function when_creating_a_stream__should_calling_shift_with_5_has_length_of_2() : Void {
		var shifted = stream.shift(5);

		var array = shifted.toArray();

		var iter: Iterable<Int> = [1, 2, 3, 4, 5, 6, 7];
        for(item in iter) {
        	stream.emit(item);
        }

        array.length.areEqual(2);
	}

	@AsyncTest
	public function when_creating_a_stream__should_calm_not_allow_events_through(asyncFactory : AsyncFactory) : Void {
		var calmed = stream.calm(Signals.constant(100)).toArray();

		for(i in 0...4) {
			stream.emit(i);
		}

		// Async
		Timer.delay(asyncFactory.createHandler(this, function(){

			calmed.arrayEquals([]);

		}, MAX_TIMEOUT), 40);
	}

	// FIXME (Simon) : The result for this should be [3, 4, 5, 6, 7]
	@AsyncTest
	public function when_creating_a_stream__should_allow_events_through_after_calm(asyncFactory : AsyncFactory) : Void {
		var calmed = stream.calm(Signals.constant(10)).toArray();

		for(i in 0...4) {
			stream.emit(i);
		}

		Timer.delay(function() {
			for(i in 4...8) {
				stream.emit(i);
			}
		}, 20);

		// Async
		Timer.delay(asyncFactory.createHandler(this, function(){
			calmed.arrayEquals([3, 7]);

		}, MAX_TIMEOUT), 40);
	}
}
