package funk.ds.extensions;

using funk.types.Option;
using funk.ds.extensions.Reducible;
using massive.munit.Assert;

class ReducibleTestBase {

    public var reducible : Reducible<Int>;

    @Test
    public function with_reducible_reduceLeft_should_reduce_to_add_to_7() : Void {
        var actual = reducible.reduceLeft(function(a, b) return a + b);
        Assert.areEqual(actual, Some(6));
    }

    @Test
    public function with_reducible_reduceRight_should_reduce_to_add_to_7() : Void {
        var actual = reducible.reduceRight(function(a, b) return a + b);
        Assert.areEqual(actual, Some(6));
    }
}
