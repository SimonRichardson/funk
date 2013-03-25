package funk.collections.immutable;

using massive.munit.Assert;
using funk.collections.immutable.Map;

class MapTestBase {

    public var alpha : Map<String, Int>;

    @Test
    public function map_should_not_be_empty() : Void {
        alpha.isEmpty().isFalse();
    }

    @Test
    public function map_should_contain_correct_value_1() : Void {
        alpha.exists('a').isTrue();
    }

    @Test
    public function map_should_contain_correct_value_2() : Void {
        alpha.exists('b').isTrue();
    }
}
