package funk.ds;

import funk.ds.CollectionTestBase;
import funk.ds.extensions.FoldableTestBase;

using funk.ds.Collection;
using funk.ds.CollectionUtil;
using massive.munit.Assert;

class CollectionFoldableTest extends FoldableTestBase {

    @Before
    public function setup() : Void {
        var collection : Collection<Int> = [1, 2, 3];
        foldable = collection;
    }
}
