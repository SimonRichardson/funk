package funk.future;

import funk.either.Either;
import funk.errors.FunkError;
import funk.future.Deferred;
import funk.future.Future;

import massive.munit.Assert;
import util.AssertExtensions;

using massive.munit.Assert;
using util.AssertExtensions;

class FutureTest {

	private var deferred : Deferred<Int>;

	private var future : Future<Int>;

	@Before
	public function setup() {
		deferred = new Deferred<Int>();
		future = deferred.future();
	}

	@After
	public function tearDown() {
		deferred = null;
		future = null;
	}

	@Test
	public function when_adding_then__should_return_the_same_future() : Void {
		future.then(function(value){
			Assert.fail("fail if called");
		}).areEqual(future);
	}

	@Test
	public function when_adding_then__should_calling_resolve_dispatch_completed() : Void {
		var called : Bool = false;
		future.then(function(value){
			called = true;
		});
		deferred.resolve(1);
		called.isTrue();
	}

	@Test
	public function when_adding_then__should_calling_abort_not_dispatch_completed() : Void {
		var called : Bool = false;
		future.then(function(value){
			Assert.fail("fail if called");
		});
		deferred.abort();
		called.isFalse();
	}

	@Test
	public function when_adding_then__should_calling_reject_not_dispatch_completed() : Void {
		var called : Bool = false;
		future.then(function(value){
			Assert.fail("fail if called");
		});
		deferred.reject(new FunkError());
		called.isFalse();
	}

	@Test
	public function when_adding_but__should_return_the_same_future() : Void {
		future.but(function(value){
			Assert.fail("fail if called");
		}).areEqual(future);
	}

	@Test
	public function when_adding_but__should_calling_resolve_not_dispatch_completed() : Void {
		var called : Bool = false;
		future.but(function(value){
			Assert.fail("fail if called");
		});
		deferred.resolve(1);
		called.isFalse();
	}

	@Test
	public function when_adding_but__should_calling_abort_not_dispatch_completed() : Void {
		var called : Bool = false;
		future.but(function(value){
			Assert.fail("fail if called");
		});
		deferred.abort();
		called.isFalse();
	}

	@Test
	public function when_adding_but__should_calling_reject_dispatch_completed() : Void {
		var called : Bool = false;
		future.but(function(value){
			called = true;
		});
		deferred.reject(new FunkError());
		called.isTrue();
	}

	@Test
	public function when_adding_but_after_reject__should_calling_reject_dispatch_completed() : Void {
		var called : Bool = false;
		deferred.reject(new FunkError());
		future.but(function(value){
			called = true;
		});
		called.isTrue();
	}

	@Test
	public function when_adding_when__should_return_the_same_future() : Void {
		future.when(function(value){
			Assert.fail("fail if called");
		}).areEqual(future);
	}

	@Test
	public function when_adding_when__should_calling_resolve_dispatch_completed() : Void {
		var called : Bool = false;
		future.when(function(value){
			called = true;
		});
		deferred.resolve(1);
		called.isTrue();
	}

	@Test
	public function when_adding_when__should_calling_abort_dispatch_completed() : Void {
		var called : Bool = false;
		future.when(function(value){
			called = true;
		});
		deferred.abort();
		called.isTrue();
	}

	@Test
	public function when_adding_when__should_calling_reject_dispatch_completed() : Void {
		var called : Bool = false;
		future.when(function(value){
			called = true;
		});
		deferred.reject(new FunkError());
		called.isTrue();
	}


	@Test
	public function when_adding_then__should_calling_resolve_should_dispatch_value() : Void {
		var actual : Int = 1;
		var expected : Int = -1;
		future.then(function(value){
			expected = value;
		});
		deferred.resolve(actual);
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_then_after_resolve__should_calling_resolve_should_dispatch_value() : Void {
		var actual : Int = 1;
		var expected : Int = -1;
		deferred.resolve(actual);
		future.then(function(value){
			expected = value;
		});
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_then_twice__should_calling_resolve_should_dispatch_value() : Void {
		var expected0 : Int = -1;
		var expected1 : Int = -1;

		future.then(function(value){
			expected0 = value;
		});
		future.then(function(value){
			expected1 = value;
		});

		deferred.resolve(1);

		expected0.areEqual(expected1);
	}

	@Test
	public function when_adding_when__should_calling_resolve_should_dispatch_value() : Void {
		var actual : Int = 1;
		var expected : Int = -1;
		future.when(function(value){
			expected = value.right().get();
		});
		deferred.resolve(actual);
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_when__should_calling_reject_should_dispatch_value() : Void {
		var actual = new FunkError();
		var expected = null;
		future.when(function(value){
			expected = value.left().get();
		});
		deferred.reject(actual);
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_when_after_reject__should_calling_reject_should_dispatch_value() : Void {
		var actual = new FunkError();
		var expected = null;
		deferred.reject(actual);
		future.when(function(value){
			expected = value.left().get();
		});
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_when_after_resolve__should_calling_resolve_should_dispatch_value() : Void {
		var actual : Int = 1;
		var expected : Int = -1;
		deferred.resolve(actual);
		future.when(function(value){
			expected = value.right().get();
		});
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_when_twice__should_calling_resolve_should_dispatch_value() : Void {
		var expected0 : Int = -1;
		var expected1 : Int = -1;

		future.when(function(value){
			expected0 = value.right().get();
		});
		future.when(function(value){
			expected1 = value.right().get();
		});

		deferred.resolve(1);

		expected0.areEqual(expected1);
	}

	@Test
	public function when_adding_progress__should_call_progress() : Void {
		var called : Bool = false;
		future.progress(function(value){
			called = true;
		});
		deferred.progress(1.0);
		called.isTrue();
	}

	@Test
	public function when_adding_progress_after_resolve__should_not_call_progress() : Void {
		var called : Bool = false;
		future.progress(function(value){
			called = true;
		});
		deferred.resolve(1);
		deferred.progress(1.0);
		called.isFalse();
	}
}
