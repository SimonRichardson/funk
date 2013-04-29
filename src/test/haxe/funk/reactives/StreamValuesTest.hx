package funk.reactives;

import funk.ds.CollectionTestBase;
import funk.reactives.StreamValues;

using massive.munit.Assert;
using funk.types.Option;
using funk.types.Tuple2;

using funk.ds.Collection;
using funk.ds.CollectionUtil;
using funk.ds.immutable.List;
using unit.Asserts;

class StreamValuesTest extends CollectionTestBase {

    private var actualList : List<Int>;

    private var actualStream : StreamValues<Int>;

    @Before
    public function setup():Void {
        var alphaList : List<String> = Nil;
        var alphaStream = new StreamValues(Some(function() return alphaList));
        alphaList = alphaList.append('a');
        alphaList = alphaList.append('b');
        alphaList = alphaList.append('c');
        alphaList = alphaList.append('d');
        alphaList = alphaList.append('e');

        alpha = alphaStream;

        actualList = Nil;
        actualStream = new StreamValues(Some(function() return actualList));
        actualList = actualList.append(1);
        actualList = actualList.append(2);
        actualList = actualList.append(3);
        actualList = actualList.append(4);
        actualList = actualList.append(5);

        actual = actualStream;
        actualTotal = 5;

        // TODO (Simon) : Swap this out for actual stream values
        complex = [
                    [1, 2, 3].toCollection(),
                    [4, 5].toCollection(),
                    [6].toCollection(),
                    [7, 8, 9].toCollection()
                    ].toCollection();

        var otherList : List<Int> = Nil;
        var otherStream = new StreamValues(Some(function() return otherList));
        otherList = otherList.append(6);
        otherList = otherList.append(7);
        otherList = otherList.append(8);
        otherList = otherList.append(9);

        other = otherStream;
        otherTotal = 4;

        empty = new StreamValues(None);
        emptyTotal = 0;

        name = 'Collection';
        emptyName = 'Collection';
    }

    @Test
    public function when_creating_a_list__should_adding_more_items_add_more_items() : Void {
        actualList = actualList.append(5);
        actualStream.size().areEqual(6);
    }

    @Test
    public function when_drop__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.dropLeft(1);
        actualList = actualList.append(5);
        stream.size().areEqual(4);
    }

    @Test
    public function when_dropRight__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.dropRight(1);
        actualList = actualList.append(5);
        stream.size().areEqual(4);
    }

    @Test
    public function when_dropWhile__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.dropWhile(function(value) {
            return value < 2;
        });
        actualList = actualList.append(5);
        stream.size().areEqual(4);
    }

    @Test
    public function when_filter__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.filter(function(value) {
            return value != 1;
        });
        actualList = actualList.append(5);
        stream.size().areEqual(4);
    }

    @Test
    public function when_filterNot__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.filterNot(function(value) {
            return value == 1;
        });
        actualList = actualList.append(5);
        stream.size().areEqual(4);
    }

    @Test
    public function when_flatMap__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.flatMap(function(value) {
            return [value].toCollection();
        });
        actualList = actualList.append(5);
        stream.size().areEqual(5);
    }

    @Test
    public function when_map__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.map(function(value) {
            return value;
        });
        actualList = actualList.append(5);
        stream.size().areEqual(5);
    }

    @Test
    public function when_prepend__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.prepend(6);
        actualList = actualList.append(5);
        stream.size().areEqual(6);
    }

    @Test
    public function when_prependAll__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.prependAll([6, 7, 8].toCollection());
        actualList = actualList.append(5);
        stream.size().areEqual(8);
    }

    @Test
    public function when_append__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.append(6);
        actualList = actualList.append(5);
        stream.size().areEqual(6);
    }

    @Test
    public function when_appendAll__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.appendAll([6, 7, 8].toCollection());
        actualList = actualList.append(5);
        stream.size().areEqual(8);
    }

    @Test
    public function when_take__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.takeLeft(1);
        actualList = actualList.append(5);
        stream.size().areEqual(1);
    }

    @Test
    public function when_takeRight__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.takeRight(1);
        actualList = actualList.append(5);
        stream.size().areEqual(1);
    }

    @Test
    public function when_takeWhile__should_adding_more_items_should_not_add_values_to_stream() : Void {
        var stream = actualStream.takeWhile(function(value) {
            return value < 1;
        });
        actualList = actualList.append(5);
        stream.size().areEqual(0);
    }
}
