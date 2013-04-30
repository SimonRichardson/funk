package funk.ds.immutable;

using funk.ds.immutable.BinaryTree;

class BinaryTreeTest {

    @Test
    public function when() : Void {
        var tree = Node(Node(Node(Leaf, 5, Leaf), 4, Node(Leaf, 6, Node(Leaf, 7, Leaf))), 1, Node(Node(Leaf, 5, Leaf), 4, Node(Leaf, 6, Node(Leaf, 7, Leaf))));
        trace(tree.toString());
        trace(tree.print());
    }
}
