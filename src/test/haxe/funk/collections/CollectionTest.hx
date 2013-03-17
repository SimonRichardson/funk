package funk.collections;

import funk.collections.CollectionTestBase;

using funk.collections.Collection;
using funk.collections.CollectionUtil;
using massive.munit.Assert;

class CollectionTest extends CollectionTestBase {

    @Before
    public function setup() : Void {
        alpha = ['a', 'b', 'c', 'd', 'e'];

        actual = [1, 2, 3, 4, 5];
        actualTotal = 5;

        complex = [    [1, 2, 3].toCollection(),
                    [4, 5].toCollection(),
                    [6].toCollection(),
                    [7, 8, 9].toCollection()
                    ].toCollection();

        other = [6, 7, 8, 9];
        otherTotal = 4;

        empty = CollectionUtil.zero();
        emptyTotal = 0;

        name = 'Collection';
        emptyName = 'Collection';
    }
}
