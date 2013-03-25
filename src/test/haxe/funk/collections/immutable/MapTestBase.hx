package funk.collections.immutable;

using massive.munit.Assert;
using funk.collections.immutable.Map;

class MapTestBase {

    public var alpha : Map<String, String>;

    @Test
    public function map_should_not_be_empty() : Void {
        alpha.isEmpty().isFalse();
    }
}
