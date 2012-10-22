package funk.signal;

import funk.errors.AbstractMethodError;
import massive.munit.Assert;
import massive.munit.AssertExtensions;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

class SignalTest {

	private var signal : Signal;

	@Before
	public function setup() {
		signal = new Signal();
	}

	@After
	public function tearDown() {
		signal = null;
	}

	@Test
	public function when_creating_a_signal__should_not_be_null() : Void {
		signal.isNotNull();
	}

	@Test
	public function when_creating_a_signal__should_size_be_minus_1() : Void {
		signal.size.areEqual(-1);
	}

	@Test
	public function when_creating_a_signal__should_productArity_be_minus_1() : Void {
		signal.productArity.areEqual(-1);
	}

	@Test
	public function when_creating_a_signal__should_productPrefix_be_Signal() : Void {
		signal.productPrefix.areEqual("Signal");
	}

	@Test
	public function when_creating_a_signal__should_calling_productElement_throw_error() : Void {
		var called = try {
			signal.productElement(0);
			false;
		} catch(error : AbstractMethodError) {
			true;
		}
		called.isTrue();
	}

}
