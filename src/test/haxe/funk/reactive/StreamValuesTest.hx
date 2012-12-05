package funk.reactive;

import funk.collections.CollectionsTestBase;
import funk.collections.extensions.CollectionsUtil;
import funk.reactive.StreamValues;
import funk.signal.Signal1;

using funk.collections.extensions.CollectionsUtil;

class StreamValuesTest extends CollectionsTestBase {

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

		var actualSignal = new Signal1<Int>();
		var actualStream = new StreamValues(Some(actualSignal));
		actualSignal.dispatch(1);
		actualSignal.dispatch(2);
		actualSignal.dispatch(3);
		actualSignal.dispatch(4);
		actualSignal.dispatch(5);

		actual = actualStream;
		actualTotal = 5;

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

	/*
	@Test
	override public function when_takeWhile__should_return_nil() : Void {
		// This isn't required for stream values so we'll test if it's empty
		actual.takeWhile(function(value : Int) : Bool {
			return false;
		}).isEmpty.isTrue();
	}

	@Test
	public function when_creating_a_list__should_adding_more_items_add_more_items() : Void {
		actualSignal.dispatch(5);
		actualStream.size.areEqual(5);
	}

	@Test
	public function when_drop__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.drop(1);
		actualSignal.dispatch(5);
		stream.size.areEqual(3);
	}

	@Test
	public function when_dropRight__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.dropRight(1);
		actualSignal.dispatch(5);
		stream.size.areEqual(3);
	}

	@Test
	public function when_dropWhile__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.dropWhile(function(value) {
			return value < 2;
		});
		actualSignal.dispatch(5);
		stream.size.areEqual(3);
	}

	@Test
	public function when_filter__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.filter(function(value) {
			return value != 1;
		});
		actualSignal.dispatch(5);
		stream.size.areEqual(3);
	}

	@Test
	public function when_filterNot__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.filterNot(function(value) {
			return value == 1;
		});
		actualSignal.dispatch(5);
		stream.size.areEqual(3);
	}

	@Test
	public function when_flatMap__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.flatMap(function(value) {
			return Nil.list().append(value);
		});
		actualSignal.dispatch(5);
		stream.size.areEqual(4);
	}

	@Test
	public function when_map__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.map(function(value) {
			return value;
		});
		actualSignal.dispatch(5);
		stream.size.areEqual(4);
	}

	@Test
	public function when_prepend__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.prepend(6);
		actualSignal.dispatch(5);
		stream.size.areEqual(5);
	}

	@Test
	public function when_prependAll__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var l : IList<Int> = ListUtil.toList([6, 7, 8]);
		var stream = actualStream.prependAll(l);
		actualSignal.dispatch(5);
		stream.size.areEqual(7);
	}

	@Test
	public function when_append__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.append(6);
		actualSignal.dispatch(5);
		stream.size.areEqual(5);
	}

	@Test
	public function when_appendAll__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.appendAll([6, 7, 8].toList());
		actualSignal.dispatch(5);
		stream.size.areEqual(7);
	}

	@Test
	public function when_take__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.take(1);
		actualSignal.dispatch(5);
		stream.size.areEqual(1);
	}

	@Test
	public function when_takeRight__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.takeRight(1);
		actualSignal.dispatch(5);
		stream.size.areEqual(1);
	}

	@Test
	public function when_takeWhile__should_adding_more_items_should_not_add_values_to_stream() : Void {
		var stream = actualStream.takeWhile(function(value) {
			return value < 2;
		});
		actualSignal.dispatch(5);
		stream.size.areEqual(0);
	}

	@Test
	override public function when_take__should_return_list() : Void {
		var values : StreamValues<Int> = cast actual.take(0);
		values.toList().areEqual(other);
	}

	@Test
	override public function when_takeRight__should_return_list() : Void {
		var values : StreamValues<Int> = cast actual.takeRight(0);
		values.toList().areEqual(other);
	}
	*/
}
