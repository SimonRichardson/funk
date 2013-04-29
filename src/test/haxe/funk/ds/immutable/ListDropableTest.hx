package funk.ds.immutable;

import funk.ds.CollectionTestBase;
import funk.ds.extensions.DropableTestBase;

using funk.ds.Collection;
using funk.ds.CollectionUtil;
using massive.munit.Assert;

class ListDropableTest extends DropableTestBase {

    @Before
    public function setup() : Void {
        var list : List<Int> = [1, 2, 3];
        dropable = list;
    }
}
