package funk.types;

using funk.types.extensions.Strings;
using funk.types.Tuple1;
using massive.munit.Assert;

class StringsTest {

    @Test
    public function when_calling_uuid__creates_a_valid_uid() : Void {
        Strings.uuid().length.isNotNull();
    }

    @Test
    public function when_calling_uuid__creates_a_uid_of_length_36() : Void {
        Strings.uuid().length.areEqual(36);
    }

    @Test
    public function when_calling_uuid__creates_a_uid_that_is_unqiue() : Void {
        var m = [];
        for(i in 0...100) {
            m.push(Strings.uuid());
        }

        for(i in 0...m.length) {
            for(j in (i + 1)...m.length) {
                if (m[i] == m[j]) {
                    Assert.fail("Failed if called");
                }
            }
        }

        Assert.isTrue(true);
    }

    @Test
    public function when_calling_uuid_with_different_value__creates_a_uid_of_length_5() : Void {
        Strings.uuid('xxxxx').length.areEqual(5);
    }
}
