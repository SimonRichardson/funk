package funk.ds.immutable;

using funk.ds.immutable.Map;

class MapTest extends MapTestBase {

    @Before
    public function setup() : Void {
        empty = Nil;
        alpha = Nil.add('a', 1).add('b', 2).add('c', 3);
    }
}
