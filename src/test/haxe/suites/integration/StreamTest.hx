package suites.integration;

import funk.reactive.Propagation;
import funk.reactive.Pulse;
import funk.reactive.Stream;
import funk.reactive.Streams;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

class StreamTest {

	@Test
	public function when_creating_a_stream__should_adding_a_source_not_pass_stream_values() : Void {
		var stream0 = Streams.create(function(pulse) {
			return Propagate(pulse);
		});

		var stream1 = Streams.create(function(pulse) {
			return Negate;
		}, [stream0]);

		var values1 = stream1.values();

		stream0.emit(1);
		stream0.emit(2);

		values1.valuesEqualsIterable([]);
	}

	@Test
	public function when_creating_a_stream__should_adding_a_source_pass_stream_values() : Void {
		var stream0 = Streams.create(function(pulse) {
			return Propagate(pulse);
		});

		var stream1 = Streams.create(function(pulse) {
			return Propagate(pulse);
		}, [stream0]);

		var values1 = stream1.values();

		stream0.emit(1);
		stream0.emit(2);

		values1.valuesEqualsIterable([1, 2]);
	}

	@Test
	public function when_creating_a_stream__should_adding_two_sources_pass_stream_values() : Void {
		var stream0 = Streams.create(function(pulse) {
			return Propagate(pulse);
		});

		var stream1 = Streams.create(function(pulse) {
			return Propagate(pulse);
		}, [stream0]);

		var stream2 = Streams.create(function(pulse) {
			return Propagate(pulse);
		}, [stream0]);

		var values1 = stream1.values();
		var values2 = stream2.values();

		stream0.emit(1);
		stream0.emit(2);

		values1.valuesEqualsIterable([1, 2]);
		values2.valuesEqualsIterable([1, 2]);
	}

}
