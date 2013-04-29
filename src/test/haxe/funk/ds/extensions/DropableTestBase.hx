package funk.ds.extensions;

using funk.ds.Collection;
using funk.ds.extensions.Dropable;
using massive.munit.Assert;

class DropableTestBase {

    public var dropable : Dropable<Int>;

    @Test
    public function with_dropable_dropLeft_should_drop_1() : Void {
        var actual = dropable.dropLeft(1);
        Assert.areEqual(actual.size(), 2);
    }

    @Test
    public function with_dropable_dropLeft_should_drop_1_value_1_be_correct() : Void {
        var actual = dropable.dropLeft(1).iterator();
        Assert.areEqual(actual.next(), 2);
    }

    @Test
    public function with_dropable_dropLeft_should_drop_1_value_2_be_correct() : Void {
        var actual = dropable.dropLeft(1).iterator();
        actual.next();
        Assert.areEqual(actual.next(), 3);
    }

    @Test
    public function with_dropable_dropLeft_should_drop_10() : Void {
        var actual = dropable.dropLeft(10);
        Assert.areEqual(actual.size(), 0);
    }

    @Test
    public function with_dropable_dropRight_should_drop_1() : Void {
        var actual = dropable.dropRight(1);
        Assert.areEqual(actual.size(), 2);
    }

    @Test
    public function with_dropable_dropRight_should_drop_1_value_1_be_correct() : Void {
        var actual = dropable.dropRight(1).iterator();
        Assert.areEqual(actual.next(), 1);
    }

    @Test
    public function with_dropable_dropRight_should_drop_1_value_2_be_correct() : Void {
        var actual = dropable.dropRight(1).iterator();
        actual.next();
        Assert.areEqual(actual.next(), 2);
    }

    @Test
    public function with_dropable_dropRight_should_drop_10() : Void {
        var actual = dropable.dropRight(10);
        Assert.areEqual(actual.size(), 0);
    }
}
