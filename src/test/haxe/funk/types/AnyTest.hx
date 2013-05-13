package funk.types;

import funk.types.Any;
import funk.types.Wildcard;

using massive.munit.Assert;

class AnyTest {

    @Test
    public function calling_isInstanceOf_null_is_bool() : Void {
        AnyTypes.isInstanceOf(null, Bool).isFalse();
    }

    @Test
    public function calling_isInstanceOf_null_is_null() : Void {
        AnyTypes.isInstanceOf(null, null).isFalse();
    }

    @Test
    public function calling_isInstanceOf_true_is_bool() : Void {
        AnyTypes.isInstanceOf(true, Bool).isTrue();
    }

    @Test
    public function calling_isInstanceOf_false_is_bool() : Void {
        AnyTypes.isInstanceOf(false, Bool).isTrue();
    }

    @Test
    public function calling_isInstanceOf_empty_string_is_string() : Void {
        AnyTypes.isInstanceOf("", String).isTrue();
    }

    @Test
    public function calling_isInstanceOf_non_empty_string_is_string() : Void {
        AnyTypes.isInstanceOf("some text", String).isTrue();
    }

    @Test
    public function calling_isInstanceOf_0_is_Int() : Void {
        AnyTypes.isInstanceOf(0, Int).isTrue();
    }

    @Test
    public function calling_isInstanceOf_1_is_Int() : Void {
        AnyTypes.isInstanceOf(1, Int).isTrue();
    }

    @Test
    public function calling_isInstanceOf_2147483648_is_Int() : Void {
        AnyTypes.isInstanceOf(2147483647, Int).isTrue();
    }

    #if !cpp
    @Test
    public function calling_isInstanceOf_2147483649_is_not_Int() : Void {
        AnyTypes.isInstanceOf(2147483648, Int).isFalse();
    }
    #end

    @Test
    public function calling_isInstanceOf_minus_1_is_Int() : Void {
        AnyTypes.isInstanceOf(-1, Int).isTrue();
    }

    @Test
    public function calling_isInstanceOf_minus_2147483648_is_Int() : Void {
        AnyTypes.isInstanceOf(-2147483647, Int).isTrue();
    }

    @Test
    public function calling_isInstanceOf_minus_2147483649_is_not_Int() : Void {
        AnyTypes.isInstanceOf(-2147483648, Int).isTrue();
    }

    @Test
    public function calling_isInstanceOf_0_is_Float() : Void {
        AnyTypes.isInstanceOf(0.0, Float).isTrue();
    }

    @Test
    public function calling_isInstanceOf_1_is_Float() : Void {
        AnyTypes.isInstanceOf(1.0, Float).isTrue();
    }

    @Test
    public function calling_isInstanceOf_2147483648_is_Float() : Void {
        AnyTypes.isInstanceOf(2147483647.0, Float).isTrue();
    }

    @Test
    public function calling_isInstanceOf_2147483649_is_Float_2() : Void {
        AnyTypes.isInstanceOf(2147483648.0, Float).isTrue();
    }

    @Test
    public function calling_isInstanceOf_minus_1_is_Float() : Void {
        AnyTypes.isInstanceOf(-1.0, Float).isTrue();
    }

    @Test
    public function calling_isInstanceOf_minus_2147483648_is_Float() : Void {
        AnyTypes.isInstanceOf(-2147483647.0, Float).isTrue();
    }

    @Test
    public function calling_isInstanceOf_minus_2147483649_is_Float_2() : Void {
        AnyTypes.isInstanceOf(-2147483648.0, Float).isTrue();
    }

    @Test
    public function calling_isInstanceOf_test_is_Test() : Void {
        AnyTypes.isInstanceOf(new Test(), Test).isTrue();
    }

    @Test
    public function calling_isInstanceOf_dynamic_is_not_Test() : Void {
        AnyTypes.isInstanceOf({}, Test).isFalse();
    }

    @Test
    public function calling_isInstanceOf_subTest_is_SubTest() : Void {
        AnyTypes.isInstanceOf(new SubTest(), SubTest).isTrue();
    }

    @Test
    public function calling_isInstanceOf_subTest_is_Test() : Void {
        AnyTypes.isInstanceOf(new SubTest(), Test).isTrue();
    }

    @Test
    public function calling_isInstanceOf_interfaceSubTest_is_SubTest() : Void {
        AnyTypes.isInstanceOf(new InterfaceSubTest(), SubTest).isTrue();
    }

    @Test
    public function calling_isInstanceOf_interfaceSubTest_is_Test() : Void {
        AnyTypes.isInstanceOf(new InterfaceSubTest(), Test).isTrue();
    }

    @Test
    public function calling_isInstanceOf_interfaceSubTest_is_ITest() : Void {
        AnyTypes.isInstanceOf(new InterfaceSubTest(), ITest).isTrue();
    }

    @Test
    public function calling_isValueOf_matching_EnumValues_with_no_parameters() : Void {
        AnyTypes.isValueOf(A, A).isTrue();
    }

    @Test
    public function calling_isValueOf_matching_Enum_and_EnumValue() : Void {
        AnyTypes.isValueOf(A, TestEnum).isTrue();
    }

    @Test
    public function calling_isValueOf_matching_EnumValues_with_different_parameters() : Void {
        AnyTypes.isValueOf(B(1), B(2)).isFalse();
    }

    @Test
    public function calling_isValueOf_matching_EnumValues_with_wildcard_parameters() : Void {
        AnyTypes.isValueOf(C(1, 2), TestEnum).isTrue();
    }
}

private class Test {

    public function new() {}
}

private class SubTest extends Test {

    public function new() {
        super();
    }
}

private interface ITest {
}

private class InterfaceSubTest extends SubTest implements ITest {

    public function new() {
        super();
    }
}

private enum TestEnum {
    A;
    B(value : Int);
    C(value0 : Int, value1 : Int);
}
