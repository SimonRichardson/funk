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
	public function when_creating_a_new_stream__should_emit_new_values() : Void {

		var signal = new Signal1<Int>();
		var values = signal.signal();

		var actual = values.toArray();

		signal.dispatch(1);

		actual.arrayEquals([tuple1(1).toInstance()]);
	}

}
