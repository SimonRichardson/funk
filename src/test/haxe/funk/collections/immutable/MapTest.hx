package funk.collections.immutable;

using funk.collections.immutable.Map;

class MapTest extends MapTestBase {

    @Before
    public function setup() : Void {
        empty = Empty;
        alpha = Empty.add('a', 1).add('b', 2).add('c', 3);
    }
}
