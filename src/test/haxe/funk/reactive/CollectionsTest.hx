package funk.reactive;

import massive.munit.Assert;
import util.AssertExtensions;
import massive.munit.util.Timer;

using massive.munit.Assert;
using util.AssertExtensions;

class CollectionsTest extends ProcessAsyncBase {

	@Test
	public function when_creating_an_empty_stream__should_size_be_zero() : Void {
		var stream = Collections.toStream([], Behaviours.constant(1));
		var values = stream.values();

		advanceProcessBy(1, false);

		values.size.areEqual(0);
	}

	@Test
	public function when_creating_an_empty_stream__should_calling_emitWithDelay_throw_error() : Void {
		var stream = Collections.toStream([], Behaviours.constant(1));
		var values = stream.values();

		var called = try {

			stream.emitWithDelay(3, 1);

			advanceProcessBy(1);

			false;
		} catch(error : Dynamic) {
			true;
		}

		called.isTrue();
	}

	@Test
	public function when_creating_a_stream__should_calling_emitWithDelay() : Void {
		var stream = Collections.toStream([1, 2], Behaviours.constant(1));
		var values = stream.values();

		stream.emitWithDelay(3, 1);

		advanceProcessBy(1);

		values.last.get().areEqual(3);
	}

	@Test
	public function when_creating_a_stream_from_a_collection__should_calling_first_value_be_1() : Void {
		var stream = Collections.toStream([1, 2], Behaviours.constant(1));
		var values = stream.values();

		advanceProcessBy(1);

		values.get(0).get().areEqual(1);
	}

	@Test
	public function when_creating_a_stream_from_a_collection__should_calling_second_value_be_2() : Void {
		var stream = Collections.toStream([1, 2], Behaviours.constant(1));
		var values = stream.values();

		advanceProcessByWithIncrements(1, 2);

		values.get(1).get().areEqual(2);
	}

	@Test
	public function when_creating_a_stream_from_a_collection__should_stream_length_be_1_after_first_iteration() : Void {
		var stream = Collections.toStream([1, 2], Behaviours.constant(1));
		var values = stream.values();

		advanceProcessBy(1);

		values.size.areEqual(1);
	}

	@Test
	public function when_creating_a_stream_from_a_collection__should_stream_length_be_2_after_second_iteration() : Void {
		var stream = Collections.toStream([1, 2], Behaviours.constant(1));
		var values = stream.values();

		advanceProcessByWithIncrements(1, 2);

		values.size.areEqual(2);
	}

	@Test
	public function when_creating_a_stream_from_a_collection__should_stream_length_be_10_after_tenth_iteration() : Void {
		var stream = Collections.toStream([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], Behaviours.constant(1));
		var values = stream.values();

		advanceProcessByWithIncrements(1, 10);

		values.size.areEqual(10);
	}

	@Test
	public function when_creating_a_stream_from_a_collection__should_merging_streams_equal_result() : Void {
		var stream = Collections.toStream([1, 2, 3, 4], Behaviours.constant(1));
		var streams = [stream, stream.delay(Behaviours.constant(5))];
		var merged = Streams.merge(streams).values();

		advanceProcessByWithIncrements(1, 4);
		advanceProcessBy(5);

		merged.valuesEqualsIterable([1, 2, 3, 4, 1, 2, 3, 4]);
	}

	@Test
	public function when_creating_a_stream_from_a_collection__should_calm_not_allow_events_through() : Void {
		var stream = Collections.toStream([1, 2, 3, 4], Behaviours.constant(1));
		var calmed = stream.calm(Behaviours.constant(5)).values();

		advanceProcessByWithIncrements(1, 4);

		calmed.valuesEqualsIterable([]);
	}
}
