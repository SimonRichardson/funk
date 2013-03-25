package funk.collections.immutable;

using massive.munit.Assert;
using funk.types.Option;
using funk.collections.immutable.Map;

class MapTestBase {

    public var empty : Map<String, Int>;

    public var alpha : Map<String, Int>;

    @Test
    public function map_should_not_be_empty() : Void {
        alpha.isEmpty().isFalse();
    }

    @Test
    public function map_exists_should_be_valid_for_a() : Void {
        alpha.exists('a').isTrue();
    }

    @Test
    public function map_exists_should_be_valid_for_b() : Void {
        alpha.exists('b').isTrue();
    }

    @Test
    public function map_exists_should_be_valid_for_c() : Void {
        alpha.exists('c').isTrue();
    }

    @Test
    public function map_exists_should_not_be_valid_for_z() : Void {
        alpha.exists('z').isFalse();
    }

    @Test
    public function map_exists_should_contain_correct_value_a() : Void {
        alpha.get('a').areEqual(Some(1));
    }

    @Test
    public function map_exists_should_contain_correct_value_b() : Void {
        alpha.get('b').areEqual(Some(2));
    }

    @Test
    public function map_exists_should_contain_correct_value_c() : Void {
        alpha.get('c').areEqual(Some(3));
    }

    @Test
    public function map_exists_should_not_contain_correct_value_z() : Void {
        alpha.get('z').areEqual(None);
    }

    @Test
    public function map_remove_should_remove_a() : Void {
        var a = alpha;
        var b = alpha.remove('a');
        b.exists('a').isFalse();
    }

    @Test
    public function map_remove_should_remove_a_should_not_remove_value_from_old_reference() : Void {
        var a = alpha;
        var b = alpha.remove('a');
        a.exists('a').isTrue();
    }

    @Test
    public function map_toString_should_return_correct_value_for_empty_map() : Void {
        empty.toString().areEqual("Empty");
    }

    @Test
    public function map_toString_should_return_correct_value() : Void {
        #if js
        alpha.toString().areEqual("Map(c => 3, b => 2, a => 1)");
        #end
    }
}
