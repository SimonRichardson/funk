package funk.collections;

import funk.collections.CollectionsTestBase;
import funk.collections.extensions.Collections;
import funk.collections.extensions.CollectionsUtil;
import funk.collections.extensions.Parallels;
import funk.types.Option;
import funk.types.extensions.Options;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;


using funk.collections.extensions.CollectionsUtil;
using funk.collections.extensions.Parallels;
using funk.collections.extensions.Collections;
using funk.types.extensions.Options;
using massive.munit.Assert;

class ParallelTest {

	private var actual : Collection<Float>;

	private static inline var TOTAL : Int = 99999;

	private static inline var MIN_TIMEOUT : Int = 490;

	private static inline var MAX_TIMEOUT : Int = 500;

	@BeforeClass
	public function setup () {
		var a = [];
		for (i in 0...TOTAL) {
			a.push(i + 1.0);
		}
		actual = a.toCollection();
	}

	// Count

	@AsyncTest
	public function when_count__should_count_should_return_99999(asyncFactory : AsyncFactory) : Void {
		var promise = actual.count(function (a) {
			return true;
		});

		var result = -1.0;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(TOTAL);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_count__should_count_should_return_0(asyncFactory : AsyncFactory) : Void {
		var promise = actual.count(function (a) {
			return false;
		});

		var result = -1.0;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(0);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_count__should_count_should_return_half_of_actual_size(asyncFactory : AsyncFactory) : Void {
		var promise = actual.count(function (a) {
			return a % 2 == 0.0;
		});

		var result = -1.0;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Math.floor(TOTAL / 2));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	// Filter

	@AsyncTest
	public function when_filter__should_filter_should_return_99999(asyncFactory : AsyncFactory) : Void {
		var promise = actual.filter(function (a) {
			return true;
		});

		var result = null;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.size().areEqual(TOTAL);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_filter__should_filter_should_return_0(asyncFactory : AsyncFactory) : Void {
		var promise = actual.filter(function (a) {
			return false;
		});

		var result = null;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.size().areEqual(0);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_filter__should_filter_should_return_half_of_actual_size(asyncFactory : AsyncFactory) : Void {
		var promise = actual.filter(function (a) {
			return a % 2 == 0.0;
		});

		var result = null;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.size().areEqual(Math.floor(TOTAL / 2));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	// Filter Not

	@AsyncTest
	public function when_filterNot__should_filterNot_should_return_99999(asyncFactory : AsyncFactory) : Void {
		var promise = actual.filterNot(function (a) {
			return false;
		});

		var result = null;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.size().areEqual(TOTAL);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_filterNot__should_filterNot_should_return_0(asyncFactory : AsyncFactory) : Void {
		var promise = actual.filterNot(function (a) {
			return true;
		});

		var result = null;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.size().areEqual(0);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_filterNot__should_filterNot_should_return_half_of_actual_size(asyncFactory : AsyncFactory) : Void {
		var promise = actual.filterNot(function (a) {
			return a % 2 != 0.0;
		});

		var result = null;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.size().areEqual(Math.floor(TOTAL / 2));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	// Fold Left

	@AsyncTest
	public function when_foldLeft__should_foldLeft_should_return_4999950000(asyncFactory : AsyncFactory) : Void {
		var promise = actual.foldLeft(0.0, function (a, b) {
			return a + b;
		});

		var result = None;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Some(4999950000.0));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_foldLeft__should_foldLeft_should_return_4999950001(asyncFactory : AsyncFactory) : Void {
		var promise = actual.foldLeft(1.0, function (a, b) {
			return a + b;
		});

		var result = None;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Some(4999950001.0));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_foldLeft__should_call_foldLeft(asyncFactory : AsyncFactory) : Void {
		var promise = actual.foldLeft(0.0, function (a, b) {
			return 0.0;
		});

		var result = None;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Some(0.0));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	// Fold Left

	@AsyncTest
	public function when_foldRight__should_foldRight_should_return_4999950000(asyncFactory : AsyncFactory) : Void {
		var promise = actual.foldRight(0.0, function (a, b) {
			return a + b;
		});

		var result = None;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Some(4999950000.0));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_foldRight__should_foldLeft_should_return_4999950001(asyncFactory : AsyncFactory) : Void {
		var promise = actual.foldRight(1.0, function (a, b) {
			return a + b;
		});

		var result = None;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Some(4999950001.0));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_foldRight__should_call_foldRight(asyncFactory : AsyncFactory) : Void {
		var promise = actual.foldRight(0.0, function (a, b) {
			return 0.0;
		});

		var result = None;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Some(0.0));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	// Foreach

	@AsyncTest
	public function when_foreach__should_count_should_be_called_99999(asyncFactory : AsyncFactory) : Void {
		var result = 0;
		actual.foreach(function (a) {
			result++;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(actual.size());
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	// Map

	@AsyncTest
	public function when_map__should_map_should_return_99999(asyncFactory : AsyncFactory) : Void {
		var promise = actual.map(function (a) {
			return true;
		});

		var result = null;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.size().areEqual(TOTAL);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_map__should_map_get_0_return_float(asyncFactory : AsyncFactory) : Void {
		var promise = actual.map(function (a) {
			return a + 1.1;
		});

		var result = null;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.get(0).areEqual(Some(2.1));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_map__should_map_get_0_return_some_float(asyncFactory : AsyncFactory) : Void {
		var promise = actual.map(function (a) {
			return Some(a + 1.1);
		});

		var result = null;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.get(0).get().areEqual(Some(2.1));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	// Reduce Left

	@AsyncTest
	public function when_reduceLeft__should_reduceLeft_should_return_4999950000(asyncFactory : AsyncFactory) : Void {
		var promise = actual.reduceLeft(function (a, b) {
			return a + b;
		});

		var result = None;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Some(4999950000.0));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_reduceLeft__should_call_reduceLeft(asyncFactory : AsyncFactory) : Void {
		var promise = actual.reduceLeft(function (a, b) {
			return 0.0;
		});

		var result = None;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Some(0.0));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	// Reduce Right

	@AsyncTest
	public function when_reduceRight__should_reduceRight_should_return_4999950000(asyncFactory : AsyncFactory) : Void {
		var promise = actual.reduceRight(function (a, b) {
			return a + b;
		});

		var result = None;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Some(4999950000.0));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_reduceRight__should_call_reduceRight(asyncFactory : AsyncFactory) : Void {
		var promise = actual.reduceRight(function (a, b) {
			return 0.0;
		});

		var result = None;
		promise.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Some(0.0));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}
}
