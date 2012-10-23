package funk.reactive.signals;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

import funk.reactive.signals.SignalSignal1;
import funk.signal.Signal1;
import funk.tuple.Tuple1;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

using funk.reactive.signals.SignalSignal1;
using funk.tuple.Tuple1;

class SignalSignal1Test {

	@Test
	public function when_creating_a_new_stream__should_not_be_null() : Void {

		var signal = new Signal1<Int>();
		var values = signal.signal();

		var actual = values.toStreamValues();

		actual.isNotNull();
	}

	@Test
	public function when_creating_a_new_stream__should_be_size_0() : Void {

		var signal = new Signal1<Int>();
		var values = signal.signal();

		var actual = values.toStreamValues();

		actual.size.areEqual(0);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_new_values() : Void {

		var signal = new Signal1<Int>();
		var values = signal.signal();

		var actual = values.toStreamValues();

		signal.dispatch(1);

		actual.streamValuesEqualsIterable([tuple1(1).toInstance()]);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_size_2() : Void {

		var signal = new Signal1<Int>();
		var values = signal.signal();

		var actual = values.toStreamValues();

		signal.dispatch(1);
		signal.dispatch(2);

		actual.size.areEqual(2);
	}

	@Test
	public function when_creating_a_new_stream__should_emit_2_new_values_be_values() : Void {

		var signal = new Signal1<Int>();
		var values = signal.signal();

		var actual = values.toStreamValues();

		signal.dispatch(1);
		signal.dispatch(2);

		actual.streamValuesEqualsIterable([tuple1(1).toInstance(), tuple1(2).toInstance()]);
	}
}
