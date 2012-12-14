package funk.reactive;

import funk.collections.Collection;
import funk.collections.CollectionsTestBase;
import funk.collections.extensions.Collections;
import funk.collections.extensions.CollectionsUtil;
import funk.reactive.StreamValues;
import funk.signals.Signal1;
import funk.types.Option;
import funk.types.Tuple2;
import funk.types.extensions.Options;
import funk.types.extensions.Tuples2;
import massive.munit.Assert;
import unit.Asserts;

using massive.munit.Assert;
using funk.collections.extensions.Collections;
using funk.collections.extensions.CollectionsUtil;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;
using unit.Asserts;

class StreamValuesTest extends CollectionsTestBase {

	private var actualSignal : Signal1<Int>;

	private var actualStream : StreamValues<Int>;

	@Before
	public function setup():Void {
		var alphaSignal = new Signal1<String>();
		var alphaStream = new StreamValues(Some(alphaSignal));
		alphaSignal.dispatch('a');
		alphaSignal.dispatch('b');
		alphaSignal.dispatch('c');
		alphaSignal.dispatch('d');
		alphaSignal.dispatch('e');

		alpha = alphaStream;

		actualSignal = new Signal1<Int>();
		actualStream = new StreamValues(Some(actualSignal));
		actualSignal.dispatch(1);
		actualSignal.dispatch(2);
		actualSignal.dispatch(3);
		actualSignal.dispatch(4);
		actualSignal.dispatch(5);

		actual = actualStream;
		actualTotal = 5;

		// TODO (Simon) : Swap this out for actual stream values
		complex = [
					[1, 2, 3].toCollection(),
					[4, 5].toCollection(),
					[6].toCollection(),
					[7, 8, 9].toCollection()
					].toCollection();

		var otherSignal = new Signal1<Int>();
		var otherStream = new StreamValues(Some(otherSignal));
		otherSignal.dispatch(6);
		otherSignal.dispatch(7);
		otherSignal.dispatch(8);
		otherSignal.dispatch(9);

		other = otherStream;
		otherTotal = 4;

		empty = new StreamValues(None);
		emptyTotal = 0;

		name = 'Collection';
		emptyName = 'Collection';
	}

	@Test
	public function when_creating_a_list__should_adding_more_items_add_more_items() : Void {
		actualSignal.dispatch(5);
		actualStream.size().areEqual(6);
	}

	@Test
	public function when_drop__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.dropLeft(1);
		actualSignal.dispatch(5);
		stream.size().areEqual(4);
	}

	@Test
	public function when_dropRight__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.dropRight(1);
		actualSignal.dispatch(5);
		stream.size().areEqual(4);
	}

	@Test
	public function when_dropWhile__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.dropWhile(function(value) {
			return value < 2;
		});
		actualSignal.dispatch(5);
		stream.size().areEqual(4);
	}

	@Test
	public function when_filter__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.filter(function(value) {
			return value != 1;
		});
		actualSignal.dispatch(5);
		stream.size().areEqual(4);
	}

	@Test
	public function when_filterNot__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.filterNot(function(value) {
			return value == 1;
		});
		actualSignal.dispatch(5);
		stream.size().areEqual(4);
	}

	@Test
	public function when_flatMap__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.flatMap(function(value) {
			return [value].toCollection();
		});
		actualSignal.dispatch(5);
		stream.size().areEqual(5);
	}

	@Test
	public function when_map__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.map(function(value) {
			return value;
		});
		actualSignal.dispatch(5);
		stream.size().areEqual(5);
	}

	@Test
	public function when_prepend__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.prepend(6);
		actualSignal.dispatch(5);
		stream.size().areEqual(6);
	}

	@Test
	public function when_prependAll__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.prependAll([6, 7, 8].toCollection());
		actualSignal.dispatch(5);
		stream.size().areEqual(8);
	}

	@Test
	public function when_append__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.append(6);
		actualSignal.dispatch(5);
		stream.size().areEqual(6);
	}

	@Test
	public function when_appendAll__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.appendAll([6, 7, 8].toCollection());
		actualSignal.dispatch(5);
		stream.size().areEqual(8);
	}

	@Test
	public function when_take__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.takeLeft(1);
		actualSignal.dispatch(5);
		stream.size().areEqual(1);
	}

	@Test
	public function when_takeRight__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.takeRight(1);
		actualSignal.dispatch(5);
		stream.size().areEqual(1);
	}

	@Test
	public function when_takeWhile__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.takeWhile(function(value) {
			return value < 1;
		});
		actualSignal.dispatch(5);
		stream.size().areEqual(0);
	}
}
