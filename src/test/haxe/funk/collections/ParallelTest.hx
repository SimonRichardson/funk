package funk.collections;

import funk.collections.CollectionsTestBase;
import funk.collections.extensions.CollectionsUtil;
import funk.collections.extensions.Parallels;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using funk.collections.extensions.CollectionsUtil;
using funk.collections.extensions.Parallels;
using massive.munit.Assert;

class ParallelTest {

	private var actual : Collection<Float>;

	@Before
	public function setup () {
		var a = [];
		for (i in 0...99999) {
			a.push(i + 0.0);
		}
		actual = a.toCollection();
	}

	@AsyncTest
	public function when_foldLeft__should_foldLeft_should_return_10(asyncFactory : AsyncFactory) : Void {
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
	public function when_foldLeft__should_foldLeft_should_return_11(asyncFactory : AsyncFactory) : Void {
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
}
