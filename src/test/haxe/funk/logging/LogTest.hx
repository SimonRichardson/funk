package funk.logging;

import funk.reactive.Stream;

using funk.logging.extensions.Logs;
using funk.logging.extensions.LogLevels;
using funk.logging.extensions.Messages;
using funk.reactive.extensions.Streams;
using massive.munit.Assert;
using unit.Asserts;


class LogTest {

	@BeforeClass
	public function setupBefore() {
		Log.init();
	}

	@Before
	public function setup() {
	}

	@Test
	public function should_calling_log_call_the_output_stream() {
		var expected = "Hello";
		var actual = "";

		Log.streamOut().foreach(function (value) {
			actual = value.logLevel().value();
		});

		expected.debug();

		actual.areEqual(expected);
	}

	@Test
	public function should_calling_log_call_the_output_stream_with_mapped_value() {
		var expected = "Hello, world!";
		var actual = "";

		Log.streamOut().foreach(function (value) {
			actual = value.logLevel().value().zip();
		});

		"Hello".debugWithValue(", world!");

		actual.areEqual(expected);
	}

}
