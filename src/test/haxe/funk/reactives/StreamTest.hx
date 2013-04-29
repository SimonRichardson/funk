package funk.reactives;

using funk.reactives.Behaviour;
using funk.types.Tuple2;
using funk.types.Option;
using funk.ds.Collection;
using funk.reactives.Stream;
using massive.munit.Assert;
using unit.Asserts;

class StreamTest extends ProcessAsyncBase {

    private var stream : Stream<Dynamic>;

    @Before
    override public function setup() {
        super.setup();

        stream = StreamTypes.identity(None);
    }

    @After
    override public function tearDown() {
        super.tearDown();

        stream = null;
    }

    @Test
    public function when_creating_a_stream__should_calling_foreach_equal_7() : Void {
        var counter = 0;

        var eventStream = stream.foreach(function(v) {
            counter++;
        });

        for(item in [1, 2, 3, 4, 5, 6, 7]) {
            stream.dispatch(item);
        }

        counter.areEqual(7);
    }

    @Test
    public function when_creating_a_stream__should_calling_values() : Void {
        var values = stream.values();

        for(item in [1, 2, 3, 4, 5]) {
            stream.dispatch(item);
        }

        values.areIterablesEqual([1, 2, 3, 4, 5]);
    }

    @Test
    public function when_creating_a_stream__should_calling_constant_with_3_return_3_3_3() : Void {
        var total = 3;
        var values = stream.constant(total).values();

        for(index in 0...total) {
            stream.dispatch(index);
        }

        values.areIterablesEqual([3, 3, 3]);
    }

    @Test
    public function when_creating_a_stream__should_stream_be_empty() : Void {
        var values = stream.values();
        values.size().areEqual(0);
    }

    @Test
    public function when_creating_a_stream__should_calling_emit_result_in_same_1() : Void {
        var value = 1.1;

        var values = stream.values();
        stream.dispatch(value);
        values.last().areEqual(Some(value));
    }

    @Test
    public function when_creating_a_stream__should_calling_emit_result_in_same_string() : Void {
        var value = "string";

        var values = stream.values();
        stream.dispatch(value);
        values.last().areEqual(Some(value));
    }

    @Test
    public function when_creating_a_stream__should_calling_emit_result_in_same_instance() : Void {
        var value = {};

        var values = stream.values();
        stream.dispatch(value);
        values.last().areEqual(Some(value));
    }

    @Test
    public function when_creating_stream_with_true__should_return_value_of_true() : Void {
        var result : Bool = stream.startsWith(true).value();
        result.isTrue();
    }

    @Test
    public function when_creating_stream__should_calling_map_mutliply_each_value_by_2() : Void {
        var mapped = stream.map(function(v){
            return v * 2;
        });

        var values = mapped.values();

        for(item in [1, 2, 3, 4, 5, 6, 7]) {
            stream.dispatch(item);
        }

        values.areIterablesEqual([2, 4, 6, 8, 10, 12, 14]);
    }

    @Test
    public function when_creating_a_stream__should_calling_flatMap_with_3_streams_emit_first_stream_with_123() : Void {
        var stream0 = StreamTypes.identity(None);
        var stream1 = StreamTypes.identity(None);
        var stream2 = StreamTypes.identity(None);

        var bound = stream.flatMap(function(x) {
            return switch(x) {
                case 0: stream0;
                case 1: stream1;
                case 2: stream2;
                case _: null;
            };
        });

        var values = bound.values();

        stream.dispatch(0);
        stream0.dispatch(123);

        values.last().areEqual(Some(123));
    }

    @Test
    public function when_creating_a_stream__should_calling_flatMap_with_3_streams_emit_third_stream_with_789() : Void {
        var stream0 = StreamTypes.identity(None);
        var stream1 = StreamTypes.identity(None);
        var stream2 = StreamTypes.identity(None);

        var bound = stream.flatMap(function(x) {
            return switch(x) {
                case 0: stream0;
                case 1: stream1;
                case 2: stream2;
                case _: null;
            };
        });

        var values = bound.values();

        stream.dispatch(2);
        stream2.dispatch(789);

        values.last().areEqual(Some(789));
    }

    @Test
    public function when_creating_a_stream__should_calling_flatMap_with_3_streams_emit_on_stream_but_not_on_mapped() : Void {
        var stream0 = StreamTypes.identity(None);
        var stream1 = StreamTypes.identity(None);
        var stream2 = StreamTypes.identity(None);

        var bound = stream.flatMap(function(x) {
            return switch(x) {
                case 0: stream0;
                case 1: stream1;
                case 2: stream2;
                case _: null;
            };
        });

        var values = bound.values();

        stream.dispatch(0);

        values.size().areEqual(0);
    }

    @Test
    public function when_creating_a_stream__should_calling_zip_two_streams_together() : Void {
        var zipped = stream.zip(stream).map(function(tuple) {
            return tuple._1() * tuple._2();
        });

        var values = zipped.values();

        for(item in [1, 2, 3, 4, 5, 6, 7]) {
            stream.dispatch(item);
        }

        values.areIterablesEqual([1, 4, 9, 16, 25, 36, 49]);
    }

    @Test
    public function when_creating_a_stream__should_calling_shift_with_2_removes_2_items() : Void {
        var shifted = stream.shift(2);

        var values = shifted.values();

        for(item in [1, 2, 3, 4, 5, 6, 7]) {
            stream.dispatch(item);
        }

        values.areIterablesEqual([1, 2, 3, 4, 5]);
    }

    @Test
    public function when_creating_a_stream__should_calling_shift_with_2_has_length_of_5() : Void {
        var shifted = stream.shift(2);

        var values = shifted.values();

        for(item in [1, 2, 3, 4, 5, 6, 7]) {
            stream.dispatch(item);
        }

        values.size().areEqual(5);
    }

    @Test
    public function when_creating_a_stream__should_calling_shift_with_5_removes_5_items() : Void {
        var shifted = stream.shift(5);

        var values = shifted.values();

        for(item in [1, 2, 3, 4, 5, 6, 7]) {
            stream.dispatch(item);
        }

        values.areIterablesEqual([1, 2]);
    }

    @Test
    public function when_creating_a_stream__should_calling_shift_with_5_has_length_of_2() : Void {
        var shifted = stream.shift(5);

        var values = shifted.values();

        for(item in [1, 2, 3, 4, 5, 6, 7]) {
            stream.dispatch(item);
        }

        values.size().areEqual(2);
    }

    @Test
    public function when_creating_a_stream__should_calm_not_allow_events_through_if_time_is_less_than_calm_amount() : Void {
        var calmed = stream.calm(BehaviourTypes.constant(2)).values();

        for(i in 0...4) {
            stream.dispatch(i);
        }

        advanceProcessBy(1, false);

        calmed.areIterablesEqual([]);
    }

    @Test
    public function when_creating_a_stream__should_calm_allow_last_event_through_if_time_is_greater_than_calm_amount() : Void {
        var calmed = stream.calm(BehaviourTypes.constant(1)).values();

        for(i in 0...4) {
            stream.dispatch(i);
        }

        advanceProcessBy(2, false);

        calmed.areIterablesEqual([3]);
    }

    @Test
    public function when_creating_a_stream__should_allow_events_through_after_calm() : Void {
        var calmed = stream.calm(BehaviourTypes.constant(1)).values();

        for(i in 0...4) {
            stream.dispatch(i);
        }

        advanceProcessBy(2, false);

        for(i in 4...8) {
            stream.dispatch(i);
        }

        advanceProcessBy(2, false);

        calmed.areIterablesEqual([3, 7]);
    }

    @Test
    public function when_creating_a_stream__should_allow_first_events_through_but_not_delayed_events() : Void {
        var calmed = stream.calm(BehaviourTypes.constant(1)).values();

        for(i in 0...4) {
            stream.dispatch(i);
        }

        advanceProcessBy(2, false);

        for(i in 4...8) {
            stream.dispatchWithDelay(i, 2);
        }

        calmed.areIterablesEqual([3]);
    }

    @Test
    public function when_creating_a_stream__should_allow_events_through_after_calm_using_emitWithDelay_which_is_higher_than_the_calm_amount() : Void {
        var calmed = stream.calm(BehaviourTypes.constant(1)).values();

        for(i in 0...4) {
            stream.dispatch(i);
        }

        advanceProcessBy(2, false);

        for(i in 4...8) {
            stream.dispatchWithDelay(i, 2);
            advanceProcessBy(2, false);
        }

        advanceProcessBy(2, false);

        calmed.areIterablesEqual([3, 4, 5, 6, 7]);
    }
}
