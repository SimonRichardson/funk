package funk.types;

using funk.types.PartialFunction1;
using massive.munit.Assert;

class PartialFunction1Test {


    @Test
    public function when_partial_isDefinedAt_2_should_be_true() : Void {
        var partial = Partial1(function(v) return v > 0, function(v) return v * v).fromPartial();
        partial.isDefinedAt(2).isTrue();
    }

    @Test
    public function when_partial_isDefinedAt_minus_2_should_be_false() : Void {
        var partial = Partial1(function(v) return v > 0, function(v) return v * v).fromPartial();
        partial.isDefinedAt(-2).isFalse();
    }

    @Test
    public function when_partial_call_with_2_should_be_4() : Void {
        var partial = Partial1(function(v) return v > 0, function(v) return v * v).fromPartial();
        Assert.areEqual(partial.apply(2), 4);
    }

    @Test
    public function when_partial_call_with_2_should_not_be_5() : Void {
        var partial = Partial1(function(v) return v > 0, function(v) return v * v).fromPartial();
        Assert.areNotEqual(partial.apply(2), 5);
    }

    @Test
    public function when_partial_call_with_minus_2_should_throw_error() : Void {
        var partial = Partial1(function(v) return v > 0, function(v) return v * v).fromPartial();
        var called = try { partial.apply(-2); false; } catch (e : Dynamic) true;
        called.isTrue();
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_isDefinedAt_1_should_be_true() : Void {
        var partial0 = Partial1(function(v) return v == 1, function(v) return v * v).fromPartial();
        var partial1 = Partial1(function(v) return v == 2, function(v) return v * v).fromPartial();
        var partial = partial0.orElse(partial1);
        partial.isDefinedAt(1).isTrue();
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_isDefinedAt_2_should_be_true() : Void {
        var partial0 = Partial1(function(v) return v == 1, function(v) return v * v).fromPartial();
        var partial1 = Partial1(function(v) return v == 2, function(v) return v * v).fromPartial();
        var partial = partial0.orElse(partial1);
        partial.isDefinedAt(2).isTrue();
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_isDefinedAt_minus_2_should_be_false() : Void {
        var partial0 = Partial1(function(v) return v == 1, function(v) return v * v).fromPartial();
        var partial1 = Partial1(function(v) return v == 2, function(v) return v * v).fromPartial();
        var partial = partial0.orElse(partial1);
        partial.isDefinedAt(-2).isFalse();
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_call_1_should_be_2() : Void {
        var partial0 = Partial1(function(v) return v == 1, function(v) return v * v).fromPartial();
        var partial1 = Partial1(function(v) return v == 2, function(v) return v * v).fromPartial();
        var partial = partial0.orElse(partial1);
        Assert.areEqual(partial.apply(1), 1);
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_call_2_should_be_4() : Void {
        var partial0 = Partial1(function(v) return v == 1, function(v) return v * v).fromPartial();
        var partial1 = Partial1(function(v) return v == 2, function(v) return v * v).fromPartial();
        var partial = partial0.orElse(partial1);
        Assert.areEqual(partial.apply(2), 4);
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_call_2_should_not_be_5() : Void {
        var partial0 = Partial1(function(v) return v == 1, function(v) return v * v).fromPartial();
        var partial1 = Partial1(function(v) return v == 2, function(v) return v * v).fromPartial();
        var partial = partial0.orElse(partial1);
        Assert.areNotEqual(partial.apply(2), 5);
    }

    @Test
    public function when_partial_orElse_with_other_partial_and_call_minus_2_should_throw_error() : Void {
        var partial0 = Partial1(function(v) return v == 1, function(v) return v * v).fromPartial();
        var partial1 = Partial1(function(v) return v == 2, function(v) return v * v).fromPartial();
        var partial = partial0.orElse(partial1);
        var called = try { partial.apply(-2); false; } catch(e : Dynamic) true;
        called.isTrue();
    }
}
