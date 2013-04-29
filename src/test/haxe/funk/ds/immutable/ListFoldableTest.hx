package funk.ds.immutable;

import funk.ds.CollectionTestBase;
import funk.ds.extensions.FoldableTestBase;

using funk.ds.Collection;
using funk.ds.CollectionUtil;
using massive.munit.Assert;

class ListFoldableTest extends FoldableTestBase {

    @Before
    public function setup() : Void {
        var list : List<Int> = [1, 2, 3];
        foldable = list;
    }
}
