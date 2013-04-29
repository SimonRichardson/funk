package funk.ds;

import funk.ds.CollectionTestBase;
import funk.ds.extensions.DropableTestBase;

using funk.ds.Collection;
using funk.ds.CollectionUtil;
using massive.munit.Assert;

class CollectionDropableTest extends DropableTestBase {

    @Before
    public function setup() : Void {
        var collection : Collection<Int> = [1, 2, 3];
        dropable = collection;
    }
}
