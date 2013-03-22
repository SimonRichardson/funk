package funk.collections.immutable;

import funk.collections.CollectionTestBase;
import funk.collections.extensions.ReducibleTestBase;

using funk.collections.Collection;
using funk.collections.CollectionUtil;
using massive.munit.Assert;

class ListReducibleTest extends ReducibleTestBase {

    @Before
    public function setup() : Void {
        var list : List<Int> = [1, 2, 3];
        reducible = list;
    }
}
