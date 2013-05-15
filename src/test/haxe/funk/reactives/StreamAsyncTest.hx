package funk.reactives;

import massive.munit.async.AsyncFactory;

using funk.reactives.Behaviour;
using funk.types.Tuple2;
using funk.types.Option;
using funk.ds.Collection;
using funk.ds.CollectionUtil;
using funk.reactives.Stream;
using massive.munit.Assert;
using unit.Asserts;

class StreamAsyncTest {

    inline public static var TIMEOUT : Int = 500;

    @AsyncTest
    public function when_converting_a_function0_to_a_stream(asyncFactory : AsyncFactory) : Void {
        var actual = -1;
        var expected = 9;

        var handler : Dynamic = asyncFactory.createHandler(this, function() {
            actual.areEqual(expected);
        }, TIMEOUT);

        var a = [for(x in 0...9) x];
        var col = a.toCollection();
        col.size.asStream().foreach(function(x) {
            actual = expected;
            handler();
        });
    }
}
