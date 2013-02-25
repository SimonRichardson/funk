package funk.types;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.collections.extensions.CollectionsUtil;
import funk.types.Attempt;
import funk.types.Deferred;
import funk.types.Promise;
import funk.types.Option;
import massive.munit.Assert;
import unit.Asserts;

using funk.collections.extensions.Collections;
using funk.collections.extensions.CollectionsUtil;
using funk.types.extensions.Attempts;
using funk.types.extensions.Options;
using funk.types.extensions.Promises;
using massive.munit.Assert;
using unit.Asserts;

class PromiseTest {

	private var deferred : Deferred<Int>;

	private var promise : Promise<Int>;

	@Before
	public function setup() {
		deferred = new Deferred<Int>();
		promise = deferred.promise();
	}

	@After
	public function tearDown() {
		deferred = null;
		promise = null;
	}

	@Test
	public function when_adding_then__should_return_the_same_future() : Void {
		promise.then(function(value){
			Assert.fail("fail if called");
		}).areEqual(promise);
	}

	@Test
	public function when_adding_then__should_calling_resolve_dispatch_completed() : Void {
		var called : Bool = false;
		promise.then(function(value){
			called = true;
		});
		deferred.resolve(1);
		called.isTrue();
	}

	@Test
	public function when_adding_then__should_calling_abort_not_dispatch_completed() : Void {
		var called : Bool = false;
		promise.then(function(value){
			Assert.fail("fail if called");
		});
		deferred.abort();
		called.isFalse();
	}

	@Test
	public function when_adding_then__should_calling_reject_not_dispatch_completed() : Void {
		var called : Bool = false;
		promise.then(function(value){
			Assert.fail("fail if called");
		});
		deferred.reject(Errors.Error(''));
		called.isFalse();
	}

	@Test
	public function when_adding_but__should_return_the_same_future() : Void {
		promise.but(function(value){
			Assert.fail("fail if called");
		}).areEqual(promise);
	}

	@Test
	public function when_adding_but__should_calling_resolve_not_dispatch_completed() : Void {
		var called : Bool = false;
		promise.but(function(value){
			Assert.fail("fail if called");
		});
		deferred.resolve(1);
		called.isFalse();
	}

	@Test
	public function when_adding_but__should_calling_abort_not_dispatch_completed() : Void {
		var called : Bool = false;
		promise.but(function(value){
			Assert.fail("fail if called");
		});
		deferred.abort();
		called.isFalse();
	}

	@Test
	public function when_adding_but__should_calling_reject_dispatch_completed() : Void {
		var called : Bool = false;
		promise.but(function(value){
			called = true;
		});
		deferred.reject(Errors.Error(''));
		called.isTrue();
	}

	@Test
	public function when_adding_but_after_reject__should_calling_reject_dispatch_completed() : Void {
		var called : Bool = false;
		deferred.reject(Errors.Error(''));
		promise.but(function(value){
			called = true;
		});
		called.isTrue();
	}

	@Test
	public function when_adding_when__should_return_the_same_future() : Void {
		promise.when(function(value){
			Assert.fail("fail if called");
		}).areEqual(promise);
	}

	@Test
	public function when_adding_when__should_calling_resolve_dispatch_completed() : Void {
		var called : Bool = false;
		promise.when(function(value){
			called = true;
		});
		deferred.resolve(1);
		called.isTrue();
	}

	@Test
	public function when_adding_when__should_calling_abort_dispatch_completed() : Void {
		var called : Bool = false;
		promise.when(function(value){
			called = true;
		});
		deferred.abort();
		called.isTrue();
	}

	@Test
	public function when_adding_when__should_calling_reject_dispatch_completed() : Void {
		var called : Bool = false;
		promise.when(function(value){
			called = true;
		});
		deferred.reject(Errors.Error(''));
		called.isTrue();
	}


	@Test
	public function when_adding_then__should_calling_resolve_should_dispatch_value() : Void {
		var actual : Int = 1;
		var expected : Int = -1;
		promise.then(function(value){
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
		promise.then(function(value){
			expected = value;
		});
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_then_twice__should_calling_resolve_should_dispatch_value() : Void {
		var expected0 : Int = -1;
		var expected1 : Int = -1;

		promise.then(function(value){
			expected0 = value;
		});
		promise.then(function(value){
			expected1 = value;
		});

		deferred.resolve(1);

		expected0.areEqual(expected1);
	}

	@Test
	public function when_adding_when__should_calling_resolve_should_dispatch_value() : Void {
		var actual : Int = 1;
		var expected : Int = -1;
		promise.when(function(value){
			expected = value.success().get();
		});
		deferred.resolve(actual);
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_when__should_calling_reject_should_dispatch_value() : Void {
		var actual = Errors.Error('');
		var expected = null;
		promise.when(function(value){
			expected = value.failure().get();
		});
		deferred.reject(actual);
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_when_after_reject__should_calling_reject_should_dispatch_value() : Void {
		var actual = Errors.Error('');
		var expected = null;
		deferred.reject(actual);
		promise.when(function(value){
			expected = value.failure().get();
		});
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_when_after_resolve__should_calling_resolve_should_dispatch_value() : Void {
		var actual : Int = 1;
		var expected : Int = -1;
		deferred.resolve(actual);
		promise.when(function(value){
			expected = value.success().get();
		});
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_when_twice__should_calling_resolve_should_dispatch_value() : Void {
		var expected0 : Int = -1;
		var expected1 : Int = -1;

		promise.when(function(value){
			expected0 = value.success().get();
		});
		promise.when(function(value){
			expected1 = value.success().get();
		});

		deferred.resolve(1);

		expected0.areEqual(expected1);
	}

	@Test
	public function when_adding_progress__should_call_progress() : Void {
		var called : Bool = false;
		promise.progress(function(value){
			called = true;
		});
		deferred.progress(1.0);
		called.isTrue();
	}

	@Test
	public function when_adding_progress_after_resolve__should_not_call_progress() : Void {
		var called : Bool = false;
		promise.progress(function(value){
		});
		deferred.resolve(1);

		try {
			deferred.progress(1.0);
		} catch (error : Dynamic) {
			called = true;
		}
		called.isTrue();
	}

	@Test
	public function when_chaining_promises__should_be_called() : Void {
		var called : Bool = false;
		promise._then(function (value) {
			return Std.string(value);
		}).then(function (value) {
			called = true;
		});
		deferred.resolve(1);
		called.isTrue();
	}

	@Test
	public function when_chaining_promises__should_pass_correctly_mapped_value() : Void {
		var expected : String = "_1_";
		var actual : String = "";
		promise._then(function (value) {
			return '_${Std.string(value)}_';
		}).then(function (value) {
			actual = value;
		});
		deferred.resolve(1);
		actual.areEqual(expected);
	}
}
