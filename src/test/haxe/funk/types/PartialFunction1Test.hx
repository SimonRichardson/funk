package funk.types;

using funk.types.PartialFunction1;
using massive.munit.Assert;

class PartialFunction1Test {


    @Test
    public function when() : Void {
        var partial = Partial1(function(v) return v > 0, function(v) return v * v).asPartialFunction();
        partial.isDefinedAt(2).isTrue();
    }
}
