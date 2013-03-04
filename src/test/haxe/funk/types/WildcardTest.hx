package funk.types;

import funk.types.Wildcard;

using funk.collections.immutable.List;
using funk.types.extensions.Wildcards;
using massive.munit.Assert;

class WildcardTest {

    @Test
    public function when_calling_toBool__should_return_true() : Void {
        _.toBoolean(true).isTrue();
    }

    @Test
    public function when_calling_toBool_with_object__should_return_true() : Void {
        _.toBoolean({}).isTrue();
    }

    @Test
    public function when_calling_toBool_with_false__should_return_false() : Void {
        _.toBoolean(false).isFalse();
    }

    @Test
    public function when_calling_toBool_with_null__should_return_false() : Void {
        _.toBoolean(null).isFalse();
    }

    @Test
    public function when_calling_toList_with_string__should_return_list() : Void {
        _.toList("abcd").toString().areEqual("List(a, b, c, d)");
    }

    @Test
    public function when_calling_toLowerCase_with_ABCD__should_return_abcd() : Void {
        _.toLowerCase("ABCD").areEqual("abcd");
    }

    @Test
    public function when_calling_toString_with_1__should_return_1() : Void {
        _.toString(1).areEqual("1");
    }

    @Test
    public function when_calling_toLowerCase_with_abcd__should_return_ABCD() : Void {
        _.toUpperCase("abcd").areEqual("ABCD");
    }

    @Test
    public function when_calling_plus__should_return_value() : Void {
        _.plus_(1, 2).areEqual(3);
    }

    @Test
    public function when_calling_minus__should_return_value() : Void {
        _.minus_(1, 2).areEqual(-1);
    }

    @Test
    public function when_calling_multiply__should_return_value() : Void {
        _.multiply_(1, 2).areEqual(2);
    }

    @Test
    public function when_calling_divide__should_return_value() : Void {
        _.divide_(1, 2).areEqual(0.5);
    }

    @Test
    public function when_calling_modulo__should_return_value() : Void {
        _.modulo_(1, 2).areEqual(1);
    }

    @Test
    public function when_calling_lessThan__should_return_value() : Void {
        _.lessThan_(1, 2).isTrue();
    }

    @Test
    public function when_calling_lessEqual__should_return_value() : Void {
        _.lessEqual_(1, 2).isTrue();
    }

    @Test
    public function when_calling_greaterThan__should_return_value() : Void {
        _.greaterThan_(1, 2).isFalse();
    }

    @Test
    public function when_calling_greaterEqual__should_return_value() : Void {
        _.greaterEqual_(1, 2).isFalse();
    }

    @Test
    public function when_calling_equal_1_1__should_return_value() : Void {
        _.equal_(1, 1).isTrue();
    }

    @Test
    public function when_calling_equal_1_2__should_return_value() : Void {
        _.equal_(1, 2).isFalse();
    }

    @Test
    public function when_calling_equal_mock_objects_should_return_value() : Void {
        _.equal_({}, {}).isFalse();
    }

    @Test
    public function when_calling_notEqual_1_1__should_return_value() : Void {
        _.notEqual_(1, 1).isFalse();
    }

    @Test
    public function when_calling_notEqual_1_2__should_return_value() : Void {
        _.notEqual_(1, 2).isTrue();
    }

    @Test
    public function when_calling_binaryAnd__should_return_value() : Void {
        _.binaryAnd_(1, 2).areEqual(0);
    }

    @Test
    public function when_calling_binaryXor__should_return_value() : Void {
        _.binaryXor_(1, 2).areEqual(3);
    }
}
