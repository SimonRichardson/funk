package funk.types;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.collections.extensions.CollectionsUtil;
import funk.types.Deferred;
import funk.types.Promise;
import funk.types.Either;
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
	public function when_calling_values__should_return_not_null() : Void {
		deferred.values().isNotNull();
	}

	@Test
	public function when_calling_values__should_be_0() : Void {
		deferred.values().size().areEqual(0);
	}

	@Test
	public function when_calling_values_after_resolve__should_be_1() : Void {
		deferred.resolve(1);
		deferred.values().size().areEqual(1);
	}

	@Test
	public function when_calling_values_with_last_after_resolve__should_be_1() : Void {
		deferred.resolve(1);
		deferred.values().last().get().areEqual(1);
	}

	@Test
	public function when_calling_values_with_last_after_resolve_twice__should_throw_an_error() : Void {
		deferred.resolve(1);

		var called = false;
		try {
			deferred.resolve(2);
		} catch (error : Dynamic) {
			called = true;
		}
		called.isTrue();
	}

	@Test
	public function when_calling_attempt__should_return_not_null() : Void {
		deferred.attempt().isNotNull();
	}

	@Test
	public function when_calling_attempt__should_return_either() : Void {
		deferred.attempt().areEqual(Left(Errors.NoSuchElementError));
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
		deferred.reject(Errors.Error('Rejected'));
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
		deferred.get().areEqual(None);
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
		deferred.reject(Errors.Error('Rejected'));
		deferred.get().isEmpty().isTrue();
	}

	@Test
	public function when_calling_get__should_return_Some_after_resolve() : Void {
		deferred.resolve(1);
		deferred.get().isDefined().isTrue();
	}

	@Test
	public function when_asking_for_a_future__should_create_a_valid_promise() : Void {
		deferred.promise().isNotNull();
	}

	@Test
	public function when_calling_progress__should_not_throw_an_error() : Void {
		deferred.progress(1.0);
	}

	@Test
	public function when_calling_progress_after_resolve__should_throw_an_error() : Void {
		deferred.resolve(1);

		var called = false;
		try {
			deferred.progress(1.0);
		} catch (error : Dynamic) {
			called = true;
		}
		called.isTrue();
	}
}
