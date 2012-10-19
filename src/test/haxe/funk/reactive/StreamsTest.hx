package funk.reactive;

import massive.munit.Assert;
import massive.munit.AssertExtensions;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

class StreamsTest {

	private static var MAX_TIMEOUT : Int = 2000;

	@Before
	public function setup() {
	}

	@After
	public function tearDown() {
	}

	@AsyncTest
	public function when_creating_a_random_stream__should_result_in_a_random_stream(asyncFactory : AsyncFactory) : Void {
		var stream = Streams.random(Signals.constant(1));
		
		var randoms = stream.toArray();		

		// Async
		Timer.delay(asyncFactory.createHandler(this, function(){
			stream.finish();

			Assert.isTrue(randoms.length > 1);

		}, MAX_TIMEOUT), 40);
	}
}