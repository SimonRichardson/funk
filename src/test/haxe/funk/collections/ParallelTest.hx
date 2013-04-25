package funk.collections;

import funk.collections.CollectionTestBase;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using funk.types.Option;
using funk.collections.Collection;
using funk.collections.CollectionUtil;
using funk.collections.Parallel;
using massive.munit.Assert;

class ParallelTest {

    private var expected : Collection<Float>;

    private static inline var TOTAL : Int = 99999;

    private static inline var TIMEOUT : Int = 4000;

    @BeforeClass
    public function setup () {
        var a = [];
        for (i in 0...TOTAL) {
            a[i] = i + 1.0;
        }
        expected = a.toCollection();
    }

    // Count

    @AsyncTest
    public function when_count__should_count_should_return_99999(asyncFactory : AsyncFactory) : Void {
        var promise = expected.count(function (a) {
            return true;
        });

        var actual = -1.0;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(TOTAL);
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_count__should_count_should_return_0(asyncFactory : AsyncFactory) : Void {
        var promise = expected.count(function (a) {
            return false;
        });

        var actual = -1.0;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(0);
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_count__should_count_should_return_half_of_expected_size(asyncFactory : AsyncFactory) : Void {
        var promise = expected.count(function (a) {
            return a % 2 == 0.0;
        });

        var actual = -1.0;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Math.floor(TOTAL / 2));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    // Filter

    @AsyncTest
    public function when_filter__should_filter_should_return_99999(asyncFactory : AsyncFactory) : Void {
        var promise = expected.filter(function (a) {
            return true;
        });

        var actual : Collection<Float> = null;

        var handler = asyncFactory.createHandler(this, function () {
            actual.size().areEqual(TOTAL);
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_filter__should_filter_should_return_0(asyncFactory : AsyncFactory) : Void {
        var promise = expected.filter(function (a) {
            return false;
        });

        var actual : Collection<Float> = null;

        var handler = asyncFactory.createHandler(this, function () {
            actual.size().areEqual(0);
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_filter__should_filter_should_return_half_of_expected_size(asyncFactory : AsyncFactory) : Void {
        var promise = expected.filter(function (a) {
            return a % 2 == 0.0;
        });

        var actual : Collection<Float> = null;

        var handler = asyncFactory.createHandler(this, function () {
            actual.size().areEqual(Math.floor(TOTAL / 2));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    // Filter Not

    @AsyncTest
    public function when_filterNot__should_filterNot_should_return_99999(asyncFactory : AsyncFactory) : Void {
        var promise = expected.filterNot(function (a) {
            return false;
        });

        var actual : Collection<Float> = null;

        var handler = asyncFactory.createHandler(this, function () {
            actual.size().areEqual(TOTAL);
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_filterNot__should_filterNot_should_return_0(asyncFactory : AsyncFactory) : Void {
        var promise = expected.filterNot(function (a) {
            return true;
        });

        var actual : Collection<Float> = null;

        var handler = asyncFactory.createHandler(this, function () {
            actual.size().areEqual(0);
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_filterNot__should_filterNot_should_return_half_of_expected_size(asyncFactory : AsyncFactory) : Void {
        var promise = expected.filterNot(function (a) {
            return a % 2 != 0.0;
        });

        var actual : Collection<Float> = null;

        var handler = asyncFactory.createHandler(this, function () {
            actual.size().areEqual(Math.floor(TOTAL / 2));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    // Fold Left

    @AsyncTest
    public function when_foldLeft__should_foldLeft_should_return_4999950000(asyncFactory : AsyncFactory) : Void {
        var promise = expected.foldLeft(0.0, function (a, b) {
            return a + b;
        });

        var actual = None;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Some(4999950000.0));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_foldLeft__should_foldLeft_should_return_4999950001(asyncFactory : AsyncFactory) : Void {
        var promise = expected.foldLeft(1.0, function (a, b) {
            return a + b;
        });

        var actual = None;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Some(4999950001.0));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_foldLeft__should_call_foldLeft(asyncFactory : AsyncFactory) : Void {
        var promise = expected.foldLeft(0.0, function (a, b) {
            return 0.0;
        });

        var actual = None;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Some(0.0));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    // Fold Right

    @AsyncTest
    public function when_foldRight__should_foldRight_should_return_4999950000(asyncFactory : AsyncFactory) : Void {
        var promise = expected.foldRight(0.0, function (a, b) {
            return a + b;
        });

        var actual = None;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Some(4999950000.0));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_foldRight__should_foldRight_should_return_4999950001(asyncFactory : AsyncFactory) : Void {
        var promise = expected.foldRight(1.0, function (a, b) {
            return a + b;
        });

        var actual = None;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Some(4999950001.0));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_foldRight__should_call_foldRight(asyncFactory : AsyncFactory) : Void {
        var promise = expected.foldRight(0.0, function (a, b) {
            return 0.0;
        });

        var actual = None;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Some(0.0));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    // Foreach

    @xAsyncTest
    public function when_foreach__should_count_should_be_called_99999(asyncFactory : AsyncFactory) : Void {

        //
        //
        // TODO : Work out how to unit test this one, as the foreach is run in parallel.
        //
        //

        var actual = 0;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(expected.size());
        }, TIMEOUT);

        expected.foreach(function (a) {
            actual++;
        });
    }

    // Map

    @AsyncTest
    public function when_map__should_map_should_return_99999(asyncFactory : AsyncFactory) : Void {
        var promise = expected.map(function (a) {
            return true;
        });

        var actual : Collection<Bool> = null;

        var handler = asyncFactory.createHandler(this, function () {
            actual.size().areEqual(TOTAL);
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_map__should_map_get_0_return_float(asyncFactory : AsyncFactory) : Void {
        var promise = expected.map(function (a) {
            return a + 1.1;
        });

        var actual : Collection<Float> = null;

        var handler = asyncFactory.createHandler(this, function () {
            actual.get(0).areEqual(Some(2.1));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_map__should_map_get_0_return_some_float(asyncFactory : AsyncFactory) : Void {
        var promise = expected.map(function (a) : Option<Float> {
            return Some(a + 1.1);
        });

        var actual : Collection<Option<Float>> = null;

        var handler = asyncFactory.createHandler(this, function () {
            actual.get(0).get().areEqual(Some(2.1));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    // Reduce Left

    @AsyncTest
    public function when_reduceLeft__should_reduceLeft_should_return_4999950000(asyncFactory : AsyncFactory) : Void {
        var promise = expected.reduceLeft(function (a, b) {
            return a + b;
        });

        var actual = None;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Some(4999950000.0));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_reduceLeft__should_call_reduceLeft(asyncFactory : AsyncFactory) : Void {
        var promise = expected.reduceLeft(function (a, b) {
            return 0.0;
        });

        var actual = None;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Some(0.0));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    // Reduce Right

    @AsyncTest
    public function when_reduceRight__should_reduceRight_should_return_4999950000(asyncFactory : AsyncFactory) : Void {
        var promise = expected.reduceRight(function (a, b) {
            return a + b;
        });

        var actual = None;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Some(4999950000.0));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }

    @AsyncTest
    public function when_reduceRight__should_call_reduceRight(asyncFactory : AsyncFactory) : Void {
        var promise = expected.reduceRight(function (a, b) {
            return 0.0;
        });

        var actual = None;

        var handler = asyncFactory.createHandler(this, function () {
            actual.areEqual(Some(0.0));
        }, TIMEOUT);

        promise.then(function (value) {
            actual = value;
            handler();
        });
    }
}
