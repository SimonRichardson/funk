package funk.io.logging;

import funk.io.logging.outputs.TraceOutput;

using funk.io.logging.Log;
using funk.io.logging.Logger;
using funk.io.logging.LogLevel;
using funk.io.logging.LogValue;
using funk.io.logging.Message;
using funk.reactives.Stream;
using funk.types.Tuple2;
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
            actual = message.value().values().toString();
        });

        expected.debug();

        actual.areEqual(expected);
    }

    @Test
    public function should_calling_log_call_the_output_stream_with_mapped_value() {
        var expected = "Hello, world!";
        var actual = "";

        Log.streamOut().foreach(function (message) {
            actual = message.value().values().toString();
        });

        "Hello".debugWithValue(", world!");

        actual.areEqual(expected);
    }

    @Test
    public function should_creating_two_loggers_zipped_together__should_ouput_to_one_log() {
        var logger0 = new Logger(Tag("Logger0"), Trace);
        var logger1 = new Logger(Tag("Logger1"), Trace);

        var expected = "(1, 2)";
        var actual = "";

        var logger2 = logger0.zip(logger1);
        logger2.streamOut().foreach(function (message) {
            var value : LogValue<Tuple2<Int, Int>> = message.value();

            actual = value.data().toString();
        });

        logger0.streamIn().dispatch(Data(Debug, 1));
        logger1.streamIn().dispatch(Data(Debug, 2));

        actual.areEqual(expected);
    }

}
