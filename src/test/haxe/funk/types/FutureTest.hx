package funk.types;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.collections.extensions.CollectionsUtil;
import funk.types.Deferred;
import funk.types.Either;
import funk.types.Future;
import funk.types.Option;
import funk.types.extensions.Eithers;
import funk.types.extensions.Options;
import massive.munit.Assert;
import unit.Asserts;

using funk.collections.extensions.Collections;
using funk.collections.extensions.CollectionsUtil;
using funk.types.extensions.Eithers;
using funk.types.extensions.Options;
using massive.munit.Assert;
using unit.Asserts;

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
		deferred.reject(Errors.Error(''));
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
		deferred.reject(Errors.Error(''));
		called.isTrue();
	}

	@Test
	public function when_adding_but_after_reject__should_calling_reject_dispatch_completed() : Void {
		var called : Bool = false;
		deferred.reject(Errors.Error(''));
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
		deferred.reject(Errors.Error(''));
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
		var actual = Errors.Error('');
		var expected = null;
		future.when(function(value){
			expected = value.left().get();
		});
		deferred.reject(actual);
		expected.areEqual(actual);
	}

	@Test
	public function when_adding_when_after_reject__should_calling_reject_should_dispatch_value() : Void {
		var actual = Errors.Error('');
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
