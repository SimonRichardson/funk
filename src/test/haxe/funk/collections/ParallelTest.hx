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
		var future = actual.count(function (a) {
			return true;
		});

		var result = -1.0;
		future.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(TOTAL);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}
	
	@AsyncTest
	public function when_count__should_count_should_return_0(asyncFactory : AsyncFactory) : Void {
		var future = actual.count(function (a) {
			return false;
		});

		var result = -1.0;
		future.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(0);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_count__should_count_should_return_half_of_actual_size(asyncFactory : AsyncFactory) : Void {
		var future = actual.count(function (a) {
			return a % 2 == 0.0;
		});

		var result = -1.0;
		future.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(Math.floor(TOTAL / 2));
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	// Fold Left

	@AsyncTest
	public function when_foldLeft__should_foldLeft_should_return_4999950000(asyncFactory : AsyncFactory) : Void {
		var future = actual.foldLeft(0.0, function (a, b) {
			return a + b;
		});

		var result = -1.0;
		future.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {			
			result.areEqual(4999950000.0);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_foldLeft__should_foldLeft_should_return_4999950001(asyncFactory : AsyncFactory) : Void {
		var future = actual.foldLeft(1.0, function (a, b) {
			return a + b;
		});
		
		var result = -1.0;
		future.then(function (value) {
			result = value;
		});

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(4999950001.0);
		}, MAX_TIMEOUT), MIN_TIMEOUT);
	}

	@AsyncTest
	public function when_foldLeft__should_call_foldLeft(asyncFactory : AsyncFactory) : Void {
		var future = actual.foldLeft(0.0, function (a, b) {
			return 0.0;
		});
		
		var result = -1.0;
		future.then(function (value) {
			result = value;
		});	

		Timer.delay(asyncFactory.createHandler(this, function () {
			result.areEqual(0.0);
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
}
