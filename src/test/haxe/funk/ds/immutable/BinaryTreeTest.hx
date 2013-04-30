package funk.ds.immutable;

using funk.ds.immutable.BinaryTree;

using massive.munit.Assert;
using unit.Asserts;

class BinaryTreeTest {

    @Test
    public function when_making_node_should_be_not_null() : Void {
        var tree = Node(Leaf, 1, Leaf);
        tree.isNotNull();
    }

    @Test
    public function when_making_node_should_be_nonEmpty() : Void {
        var tree = Node(Leaf, 1, Leaf);
        tree.nonEmpty().isTrue();
    }

    @Test
    public function when_making_leaf_should_be_not_null() : Void {
        var tree = Leaf;
        tree.isNotNull();
    }

    @Test
    public function when_making_leaf_should_be_isEmpty() : Void {
        var tree = Leaf;
        tree.isEmpty().isTrue();
    }

    @Test
    public function when_making_Node_size_should_be_1() : Void {
        var tree = Node(Leaf, 1, Leaf);
        tree.size().areEqual(1);
    }

    @Test
    public function when_making_Leaf_size_should_be_0() : Void {
        var tree = Leaf;
        tree.size().areEqual(0);
    }

    @Test
    public function when_adding_complex_nodes_heigh_should_be_5() : Void {
        var tree = Node(Node(Node(Leaf, 5, Leaf), 4, Node(Leaf, 6, Node(Leaf, 7, Leaf))), 1, Node(Node(Leaf, 5, Leaf), 4, Node(Leaf, 6, Node(Leaf, 7, Leaf))));
        tree.height().areEqual(4);
    }
}
