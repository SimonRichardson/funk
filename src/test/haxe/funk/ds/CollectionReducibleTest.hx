package funk.ds;

import funk.ds.CollectionTestBase;
import funk.ds.extensions.ReducibleTestBase;

using funk.ds.Collection;
using funk.ds.CollectionUtil;
using massive.munit.Assert;

class CollectionReducibleTest extends ReducibleTestBase {

    @Before
    public function setup() : Void {
        var collection : Collection<Int> = [1, 2, 3];
        reducible = collection;
    }
}
