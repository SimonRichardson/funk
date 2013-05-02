package funk.ds.immutable;

import funk.types.Any;

using funk.types.Option;
using funk.ds.immutable.List;

enum BinaryTreeType<T> {
    Leaf;
    Node(left : BinaryTree<T>, data : T, right : BinaryTree<T>);
}

abstract BinaryTree<T>(BinaryTreeType<T>) from BinaryTreeType<T> to BinaryTreeType<T> {

    inline public function new(tree : BinaryTreeType<T>) {
        this = tree;
    }

    inline public function left() : BinaryTreeType<T> return BinaryTreeTypes.left(this);

    inline public function data() : T return BinaryTreeTypes.data(this);

    inline public function right() : BinaryTreeType<T> return BinaryTreeTypes.right(this);

    @:to
    inline public static function toString<T>(tree : BinaryTreeType<T>) : String return BinaryTreeTypes.toString(tree);
}

class BinaryTreeTypes {

    public static function left<T>(tree : BinaryTree<T>) : BinaryTree<T> {
        return switch (tree) {
            case Node(l, _, _): l;
            case _: Leaf;
        }
    }

    public static function data<T>(tree : BinaryTree<T>) : T {
        return switch (tree) {
            case Node(_, d, _): d;
            case _: null;
        }
    }

    public static function dataOption<T>(tree : BinaryTree<T>) : Option<T> {
        return switch (tree) {
            case Node(_, d, _): OptionTypes.toOption(d);
            case _: None;
        }
    }

    public static function right<T>(tree : BinaryTree<T>) : BinaryTree<T> {
        return switch (tree) {
            case Node(_, _, r): r;
            case _: Leaf;
        }
    }

    public static function append<T>(data : T, ?left : BinaryTree<T>, ?right : BinaryTree<T>) : BinaryTree<T> {
        return Node(AnyTypes.toBool(left) ? left : Leaf, data, AnyTypes.toBool(right) ? right : Leaf);
    }

    public static function appendLeft<T>(data : T, left : BinaryTree<T>) : BinaryTree<T> {
        return Node(AnyTypes.toBool(left) ? left : Leaf, data, Leaf);
    }

    public static function appendRight<T>(data : T, right : BinaryTree<T>) : BinaryTree<T> {
        return Node(Leaf, data, AnyTypes.toBool(right) ? right : Leaf);
    }

    public static function leaves<T>(tree : BinaryTree<T>) : List<T> {
        return switch (tree) {
            case Node(left, data, right) if(isEmpty(left) && isEmpty(right)): Nil.prepend(data);
            case Node(left, _, right): leaves(left).prependAll(leaves(right));
            case _: Nil;
        }
    }

    public static function size<T>(tree : BinaryTree<T>) : Int {
        return switch (tree) {
            case Node(left, _, right): 1 + size(left) + size(right);
            case _: 0;
        }
    }

    public static function leafCount<T>(tree : BinaryTree<T>) : Int {
        return switch (tree) {
            case Node(left, _, right) if(isEmpty(left) && isEmpty(right)): 1;
            case Node(left, _, right): leafCount(left) + leafCount(right);
            case _: 0;
        }
    }

    public static function height<T>(tree : BinaryTree<T>) : Int {
        return switch (tree) {
            case Node(left, _, right): 1 + Std.int(Math.max(height(left), height(right)));
            case _: 0;
        }
    }

    public static function isBalanced<T>(tree : BinaryTree<T>) : Bool {
        return switch (tree) {
            case Node(left, _, right): 
                isBalanced(left) && isBalanced(right) && (Math.abs(height(left) - height(right)) <= 1);
            case _: true;
        }
    }

    public static function isEmpty<T>(tree : BinaryTree<T>) : Bool {
        return switch (tree) {
            case Node(_, _, _): false;
            case _: true;
        }
    }

    public static function nonEmpty<T>(tree : BinaryTree<T>) : Bool return !isEmpty(tree);

    public static function hasDefinedSize<T>(tree : BinaryTree<T>) : Bool {
        return switch (tree) {
            case Node(_, _, _): true;
            case _: false;
        }
    }

    public static function print<T>(tree : BinaryTree<T>) : String return BinaryTreePrinter.printNode(tree);

    public static function toString<T>(tree : BinaryTree<T>) : String {
        var t = tree;
        return switch(t) {
            case Node(_, _, _): 'BinaryTree()';
            case _: 'Nil';
        }
    }
}

private class BinaryTreePrinter {


    public static function printNode<T>(node : BinaryTree<T>) : String {
        var max = BinaryTreeTypes.height(node);
        var buffer = new StringBuf();
        buffer.add('\n');
        printNodeInternal(buffer, Nil.prepend(node), 1, max);
        return buffer.toString();
    }

    private static function printNodeInternal<T>(   buffer : StringBuf, 
                                                    nodes : List<BinaryTree<T>>, 
                                                    level : Int, 
                                                    max : Int
                                                    ) : Void {
        if (nodes.isEmpty() || areAllLeafs(nodes)) return;

        var floor = max - level;
        var edgeLines : Int = Math.floor(Math.pow(2, Math.max(floor - 1, 0)));
        var firstSpaces : Int = Math.floor(Math.pow(2, floor)) - 1;
        var betweenSpaces : Int = Math.floor(Math.pow(2, floor + 1)) - 1;

        printWhitespaces(buffer, firstSpaces);

        var newNodes : List<BinaryTree<T>> = Nil;
        nodes.foreach(function(node : BinaryTree<T>) {
            if (BinaryTreeTypes.nonEmpty(node)) {
                buffer.add(BinaryTreeTypes.data(node));

                newNodes = newNodes.append(BinaryTreeTypes.left(node));
                newNodes = newNodes.append(BinaryTreeTypes.right(node));
            } else {
                buffer.add(" ");

                newNodes = newNodes.append(Leaf);
                newNodes = newNodes.append(Leaf);
            }
            
            printWhitespaces(buffer, betweenSpaces);
        });

        buffer.add('\n');

        var size = nodes.size();

        for (i in 1...edgeLines + 1) {
            for (j in 0...size) {
                printWhitespaces(buffer, firstSpaces - 1);

                var node = nodes.get(j).getOrElse(function() return Leaf);

                if (BinaryTreeTypes.isEmpty(node)) {
                    printWhitespaces(buffer, (edgeLines + edgeLines) + i + 1);
                    continue;
                }

                if (BinaryTreeTypes.nonEmpty(node.left())) buffer.add("/");
                else printWhitespaces(buffer, 1);

                printWhitespaces(buffer, (i + i) - 1);

                if (BinaryTreeTypes.nonEmpty(node.right())) buffer.add("\\");
                else printWhitespaces(buffer, 1);

                printWhitespaces(buffer, (edgeLines + edgeLines) - i);
            }

            buffer.add('\n');
        }

        printNodeInternal(buffer, newNodes, level + 1, max);
    }

    private static function areAllLeafs<T>(nodes : List<BinaryTree<T>>) : Bool {
        return !nodes.exists(function(node : BinaryTree<T>) : Bool return BinaryTreeTypes.nonEmpty(node));
    }

    private static function printWhitespaces(buffer : StringBuf, count : Int) : Void {
        for (i in 0...count) buffer.add(" ");
    }
}
