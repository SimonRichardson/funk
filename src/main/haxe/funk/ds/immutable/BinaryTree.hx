package funk.ds.immutable;

enum BinaryTreeType<T> {
    Nil;
    Cons(element : T, left : BinaryTree<T>, right : BinaryTree<T>);
}

abstract BinaryTree<R>(BinaryTreeType<T>) from BinaryTreeType<T> to BinaryTreeType<T> {

    inline public function new(tree : BinaryTreeType<T>) {
        this = tree;
    }

    @:to
    inline public static function toString<T>(tree : BinaryTreeType<T>) : String return BinaryTreeTypes.toString(tree);
}

class BinaryTreeTypes {

    public static function tree<T>(element : T, ?left : BinaryTree<T>, ?right : BinaryTree<T>) : BinaryTree<T> {
        return Cons(element, AnyTypes.toBool(left) ? left : Nil, AnyTypes.toBool(right) ? right : Nil);
    }

    public static function leaves<T>(tree : BinaryTree<T>) : List<T> {
        return switch (tree) {
            case Cons(element, left, right) if(isEmpty(left) && isEmpty(right)): ListType.Nil.prepend(element);
            case Cons(_, left, right): leaves(left).prependAll(leaves(right));
            case _: ListType.Nil;
        }
    }

    public static function size<T>(tree : BinaryTree<T>) : Int {
        return switch (tree) {
            case Cons(_, left, right): 1 + size(left) + size(right);
            case _: 0;
        }
    }

    public static function leafCount<T>(tree : BinaryTree<T>) : Int {
        return switch (tree) {
            case Cons(_, left, right) if(isEmpty(left) && isEmpty(right)): 1;
            case Cons(_, left, right): leftCount(left) + leafCount(right);
            case _: 0;
        }
    }

    public static function height<T>(tree : BinaryTree<T>) : Int {
        return switch (tree) {
            case Cons(_, left, right): 1 + Std.int(Math.max(height(left), height(right)));
            case _: 0;
        }
    }

    public static function isBalanced<T>(tree : BinaryTree<T>) : Bool {
        return switch (tree) {
            case Cons(_, left, right): 
                isBalanced(left) && isBalanced(right) && (Math.abs(height(left) - height(right)) <= 1);
            case _: true;
        }
    }

    public static function isEmpty<T>(tree : BinaryTree<T>) : Bool {
        return switch (tree) {
            case Cons(_, _, _): false;
            case _: true;
        }
    }

    public static function nonEmpty<T>(tree : BinaryTree<T>) : Bool return !isEmpty(tree);

    public static function hasDefinedSize<T>(tree : BinaryTree<T>) : Bool {
        return switch (tree) {
            case Cons(_, _, _): true;
            case _: false;
        }
    }

    public static function toString<T>(tree : BinaryTree<T>) : String {
        var t = tree;
        return switch(t) {
            case Cons(element, left, right):

                'BinaryTree(${})';
            case _: 'Nil';
        }
    }
}

