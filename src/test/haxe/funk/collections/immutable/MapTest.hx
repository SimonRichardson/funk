package funk.collections.immutable;

using funk.collections.immutable.Map;

class MapTest extends MapTestBase {

    @Before
    public function setup() : Void {
        alpha = Empty.add('a', 'b');
    }
}
