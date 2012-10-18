package funk.reactive;

import massive.munit.Assert;
import massive.munit.AssertExtensions;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

class CollectionsTest {

	private static var MAX_TIMEOUT : Int = 500;

	@AsyncTest
	public function when_creating_a_stream__should_calling_emitWithDelay(asyncFactory:AsyncFactory) : Void {
		var stream = Collections.toStream([1, 2], Signals.constant(1));
		var array = stream.toArray();

		stream.emitWithDelay(3, 4);

		// Async
		Timer.delay(asyncFactory.createHandler(this, function(){

			array.pop().areEqual(3);
			
		}, MAX_TIMEOUT), 40);
	}

	@AsyncTest
	public function when_creating_a_stream_from_a_collection__should_calling_first_value_be_1(asyncFactory:AsyncFactory) : Void {
		var stream = Collections.toStream([1, 2], Signals.constant(1));
		var array = stream.toArray();

		// Async
		Timer.delay(asyncFactory.createHandler(this, function(){

			array.shift().areEqual(1);

		}, MAX_TIMEOUT), 40);
	}

	@AsyncTest
	public function when_creating_a_stream_from_a_collection__should_calling_second_value_be_2(asyncFactory:AsyncFactory) : Void {
		var stream = Collections.toStream([1, 2], Signals.constant(1));
		var array = stream.toArray();

		// Async
		Timer.delay(asyncFactory.createHandler(this, function(){
			
			array.shift();
			array.shift().areEqual(2);

		}, MAX_TIMEOUT), 40);
	}

	@AsyncTest
	public function when_creating_a_stream_from_a_collection__should_stream_length_be_2(asyncFactory:AsyncFactory) : Void {
		var stream = Collections.toStream([1, 2], Signals.constant(1));
		var array = stream.toArray();

		// Async
		Timer.delay(asyncFactory.createHandler(this, function(){
			
			array.length.areEqual(2);

		}, MAX_TIMEOUT), 40);
	}

	@AsyncTest
	public function when_creating_a_stream_from_a_collection__should_merging_streams_equal_result(asyncFactory:AsyncFactory) : Void {
		var stream = Collections.toStream([1, 2, 3, 4], Signals.constant(1));
		var streams = [stream, stream.delay(Signals.constant(20))];
		var merged = Streams.merge(streams).toArray();

		// Async
		Timer.delay(asyncFactory.createHandler(this, function(){
			
			merged.arrayEquals([1, 2, 3, 4, 1, 2, 3, 4]);

		}, MAX_TIMEOUT), 40);
	}
}