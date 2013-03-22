package funk.collections;

import funk.collections.CollectionTestBase;
import funk.collections.extensions.ReducibleTestBase;

using funk.collections.Collection;
using funk.collections.CollectionUtil;
using massive.munit.Assert;

class CollectionReducibleTest extends ReducibleTestBase {

    @Before
    public function setup() : Void {
        var collection : Collection<Int> = [1, 2, 3];
        reducible = collection;
    }
}
