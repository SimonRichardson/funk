package funk.future;

import funk.either.Either;
import funk.errors.FunkError;
import funk.option.Option;

import massive.munit.Assert;
import massive.munit.AssertExtensions;

using massive.munit.Assert;
using massive.munit.AssertExtensions;

class DeferredTest {

	private var deferred : Deferred<Int>;

	@Before
	public function setup() {
		deferred = new Deferred<Int>();
	}

	@After
	public function tearDown() {
		deferred = null;
	}

	@Test
	public function when_calling_attempt__should_return_not_null() : Void {
		deferred.attempt().isNotNull();
	}

	@Test
	public function when_calling_attempt__should_return_either() : Void {
		deferred.attempt().isType(IEither);
	}

	@Test
	public function when_calling_attempt__should_return_left() : Void {
		deferred.attempt().isLeft().isTrue();
	}

	@Test
	public function when_calling_attempt__should_return_left_after_abort() : Void {
		deferred.abort();
		deferred.attempt().isLeft().isTrue();
	}

	@Test
	public function when_calling_attempt__should_return_left_after_reject() : Void {
		deferred.reject(new FunkError());
		deferred.attempt().isLeft().isTrue();
	}

	@Test
	public function when_calling_attempt__should_return_right_after_resolve() : Void {
		deferred.resolve(1);
		deferred.attempt().isRight().isTrue();
	}

	@Test
	public function when_calling_get__should_return_not_null() : Void {
		deferred.get().isNotNull();
	}

	@Test
	public function when_calling_get__should_return_option() : Void {
		deferred.get().isType(IOption);
	}

	@Test
	public function when_calling_get__should_return_None() : Void {
		deferred.get().isEmpty().isTrue();
	}

	@Test
	public function when_calling_get__should_return_None_after_abort() : Void {
		deferred.abort();
		deferred.get().isEmpty().isTrue();
	}

	@Test
	public function when_calling_get__should_return_None_after_reject() : Void {
		deferred.reject(new FunkError());
		deferred.get().isEmpty().isTrue();
	}

	@Test
	public function when_calling_get__should_return_Some_after_resolve() : Void {
		deferred.resolve(1);
		deferred.get().isDefined().isTrue();
	}

	@Test
	public function when_asking_for_a_promise__should_create_a_valid_promise() : Void {
		deferred.promise().isNotNull();
	}

	@Test
	public function when_adding_then__should_return_the_same_promise() : Void {
		var promise : Promise<Int> = deferred.promise();
		promise.then(function(value){
			Assert.fail("fail if called");
		}).areEqual(promise);
	}

	@Test
	public function when_adding_then__should_calling_resolve_dispatch_completed() : Void {
		var called : Bool = false;
		var promise : Promise<Int> = deferred.promise();
		promise.then(function(value){
			called = true;
		});
		deferred.resolve(1);
		called.isTrue();
	}

	@Test
	public function when_adding_then__should_calling_abort_not_dispatch_completed() : Void {
		var called : Bool = false;
		var promise : Promise<Int> = deferred.promise();
		promise.then(function(value){
			Assert.fail("fail if called");
		});
		deferred.abort();
		called.isFalse();
	}

	@Test
	public function when_adding_then__should_calling_reject_not_dispatch_completed() : Void {
		var called : Bool = false;
		var promise : Promise<Int> = deferred.promise();
		promise.then(function(value){
			Assert.fail("fail if called");
		});
		deferred.reject(new FunkError());
		called.isFalse();
	}

	@Test
	public function when_adding_but__should_return_the_same_promise() : Void {
		var promise : Promise<Int> = deferred.promise();
		promise.but(function(value){
			Assert.fail("fail if called");
		}).areEqual(promise);
	}

	@Test
	public function when_adding_but__should_calling_resolve_not_dispatch_completed() : Void {
		var called : Bool = false;
		var promise : Promise<Int> = deferred.promise();
		promise.but(function(value){
			Assert.fail("fail if called");
		});
		deferred.resolve(1);
		called.isFalse();
	}

	@Test
	public function when_adding_but__should_calling_abort_not_dispatch_completed() : Void {
		var called : Bool = false;
		var promise : Promise<Int> = deferred.promise();
		promise.but(function(value){
			Assert.fail("fail if called");
		});
		deferred.abort();
		called.isFalse();
	}

	@Test
	public function when_adding_but__should_calling_reject_dispatch_completed() : Void {
		var called : Bool = false;
		var promise : Promise<Int> = deferred.promise();
		promise.but(function(value){
			called = true;
		});
		deferred.reject(new FunkError());
		called.isTrue();
	}

	@Test
	public function when_adding_when__should_return_the_same_promise() : Void {
		var promise : Promise<Int> = deferred.promise();
		promise.when(function(value){
			Assert.fail("fail if called");
		}).areEqual(promise);
	}

	@Test
	public function when_adding_when__should_calling_resolve_dispatch_completed() : Void {
		var called : Bool = false;
		var promise : Promise<Int> = deferred.promise();
		promise.when(function(value){
			called = true;
		});
		deferred.resolve(1);
		called.isTrue();
	}

	@Test
	public function when_adding_when__should_calling_abort_dispatch_completed() : Void {
		var called : Bool = false;
		var promise : Promise<Int> = deferred.promise();
		promise.when(function(value){
			called = true;
		});
		deferred.abort();
		called.isTrue();
	}

	@Test
	public function when_adding_when__should_calling_reject_dispatch_completed() : Void {
		var called : Bool = false;
		var promise : Promise<Int> = deferred.promise();
		promise.when(function(value){
			called = true;
		});
		deferred.reject(new FunkError());
		called.isTrue();
	}
}