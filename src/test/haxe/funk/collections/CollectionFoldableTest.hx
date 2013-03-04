package funk.collections;

import funk.collections.CollectionTestBase;
import funk.types.FoldableTestBase;

using funk.collections.Collection;
using funk.collections.CollectionUtil;
using massive.munit.Assert;

class CollectionFoldableTest extends FoldableTestBase {

    @Before
    public function setup() : Void {
        var collection : Collection<Int> = [1, 2, 3];
        foldable = collection;
    }
}
