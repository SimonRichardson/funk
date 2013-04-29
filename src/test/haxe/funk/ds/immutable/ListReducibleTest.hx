package funk.ds.immutable;

import funk.ds.CollectionTestBase;
import funk.ds.extensions.ReducibleTestBase;

using funk.ds.Collection;
using funk.ds.CollectionUtil;
using massive.munit.Assert;

class ListReducibleTest extends ReducibleTestBase {

    @Before
    public function setup() : Void {
        var list : List<Int> = [1, 2, 3];
        reducible = list;
    }
}
