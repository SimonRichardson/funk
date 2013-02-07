package funk.io.logging;

import funk.io.logging.LogLevel;
import funk.io.logging.outputs.TraceOutput;
import funk.reactive.Stream;
import funk.types.Tuple2;

using funk.io.logging.extensions.Logs;
using funk.io.logging.extensions.Loggers;
using funk.io.logging.extensions.LogLevels;
using funk.io.logging.extensions.LogValues;
using funk.io.logging.extensions.Messages;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Tuples2;
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

		Log.streamOut().foreach(function (message) {
			actual = message.logLevel().value().toString();
		});

		expected.debug();

		actual.areEqual(expected);
	}

	@Test
	public function should_calling_log_call_the_output_stream_with_mapped_value() {
		var expected = "Hello, world!";
		var actual = "";

		Log.streamOut().foreach(function (message) {
			actual = message.logLevel().value().toString();
		});

		"Hello".debugWithValue(", world!");

		actual.areEqual(expected);
	}

	@Test
	public function should_creating_two_loggers_zipped_together__should_ouput_to_one_log() {
		var logger0 = new Logger(Tag("Logger0"));
		var logger1 = new Logger(Tag("Logger1"));

		var expected = "(1, 2)";
		var actual = "";

		var logger2 = logger0.zip(logger1);
		logger2.streamOut().foreach(function (message) {
			var level : LogLevel<Tuple2<Int, Int>> = message.logLevel();
			var value : LogValue<Tuple2<Int, Int>> = level.value();

			actual = value.data().toString();
		});

		logger0.streamIn().dispatch(Debug(Data(1)));
		logger1.streamIn().dispatch(Debug(Data(2)));

		actual.areEqual(expected);
	}

}
