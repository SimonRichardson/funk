package funk.collections;

import funk.collections.CollectionsTestBase;
import funk.collections.extensions.Collections;
import funk.collections.extensions.CollectionsUtil;
import funk.collections.extensions.Parallels;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;


using funk.collections.extensions.CollectionsUtil;
using funk.collections.extensions.Parallels;
using funk.collections.extensions.Collections;
using massive.munit.Assert;

class ParallelTest {

	private var actual : Collection<Float>;

	@Before
	public function setup () {
		var a = [];
		for (i in 1...99999) {
			a.push(i + 0.0);
		}
		actual = a.toCollection();
	}

	// Count

	@AsyncTest
	public function when_count__should_count_should_return_99999(asyncFactory : AsyncFactory) : Void {
		var future = actual.count(function (a) {
			return true;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			var result = -1.0;
			future.then(function (value) {
				result = value;
			});
			result.areEqual(actual.size());
		}, 400), 390);
	}

	@AsyncTest
	public function when_count__should_count_should_return_0(asyncFactory : AsyncFactory) : Void {
		var future = actual.count(function (a) {
			return false;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			var result = -1.0;
			future.then(function (value) {
				result = value;
			});
			result.areEqual(0);
		}, 400), 390);
	}

	@AsyncTest
	public function when_count__should_count_should_return_half_of_actual_size(asyncFactory : AsyncFactory) : Void {
		var future = actual.count(function (a) {
			return a % 2 == 0.0;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			var result = -1.0;
			future.then(function (value) {
				result = value;
			});
			result.areEqual(Math.floor(actual.size() / 2));
		}, 400), 390);
	}

	// Fold Left

	@AsyncTest
	public function when_foldLeft__should_foldLeft_should_return_4999850001(asyncFactory : AsyncFactory) : Void {
		var future = actual.foldLeft(0.0, function (a, b) {
			return a + b;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			var result = -1.0;
			future.then(function (value) {
				result = value;
			});
			result.areEqual(4999850001.0);
		}, 400), 390);
	}

	@AsyncTest
	public function when_foldLeft__should_foldLeft_should_return_4999850002(asyncFactory : AsyncFactory) : Void {
		var future = actual.foldLeft(1.0, function (a, b) {
			return a + b;
		});
		
		Timer.delay(asyncFactory.createHandler(this, function () {
			var result = -1.0;
			future.then(function (value) {
				result = value;
			});
			result.areEqual(4999850002.0);
		}, 400), 390);
	}

	@AsyncTest
	public function when_foldLeft__should_call_foldLeft(asyncFactory : AsyncFactory) : Void {
		var future = actual.foldLeft(0.0, function (a, b) {
			return 0.0;
		});
		
		Timer.delay(asyncFactory.createHandler(this, function () {
			var result = -1.0;
			future.then(function (value) {
				result = value;
			});
			result.areEqual(0.0);
		}, 400), 390);
	}

	// Foreach

	@AsyncTest
	public function when_foreach__should_count_should_be_called_99999(asyncFactory : AsyncFactory) : Void {
		// TODO (Simon) : Make this atomic.
		var result = 0;
		actual.foreach(function (a) {
			result++;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(actual.size());
		}, 400), 390);
	}
}
