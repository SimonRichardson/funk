package funk.collections.immutable;

import funk.collections.immutable.ListTestBase;

using funk.collections.immutable.List;
using funk.collections.immutable.ListUtil;

class ListTest extends ListTestBase {

    @Before
    public function setup() : Void {
        alpha = 'abcde'.toList();

        actual = [1, 2, 3, 4, 5].toList();
        actualTotal = 5;

        complex = Nil;
        complex = ListTypes.prepend(complex, [1, 2, 3].toList());
        complex = ListTypes.prepend(complex, [4, 5].toList());
        complex = ListTypes.prepend(complex, [6].toList());
        complex = ListTypes.prepend(complex, [7, 8, 9].toList());
        complex = ListTypes.reverse(complex);

        other = [6, 7, 8, 9].toList();
        otherTotal = 4;

        name = 'List';
    }
}
