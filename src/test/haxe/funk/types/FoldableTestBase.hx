package funk.types;

using funk.types.Option;
using funk.types.Foldable;
using massive.munit.Assert;

class FoldableTestBase {

    public var foldable : Foldable<Int>;

    @Test
    public function with_foldable_foldLeft_should_fold_to_add_to_7() : Void {
        var actual = foldable.foldLeft(1, function(a, b) return a + b);
        Assert.areEqual(actual, Some(7));
    }

    @Test
    public function with_foldable_foldLeft_should_fold_to_add_to_16() : Void {
        var actual = foldable.foldLeft(10, function(a, b) return a + b);
        Assert.areEqual(actual, Some(16));
    }

    @Test
    public function with_foldable_foldRight_should_fold_to_add_to_7() : Void {
        var actual = foldable.foldRight(1, function(a, b) return a + b);
        Assert.areEqual(actual, Some(7));
    }

    @Test
    public function with_foldable_foldRight_should_fold_to_add_to_16() : Void {
        var actual = foldable.foldRight(10, function(a, b) return a + b);
        Assert.areEqual(actual, Some(16));
    }
}
