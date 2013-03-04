package funk.types;

using haxe.ds.Option;

typedef FoldableType<T> = {
    function foldLeft(value : T, func : Function2<T, T, T>) : Option<T>;
    function foldRight(value : T, func : Function2<T, T, T>) : Option<T>;
}

abstract Foldable<T>(FoldableType<T>) from FoldableType<T> to FoldableType<T> {

    inline function new(foldable : FoldableType<T>) {
        this = foldable;
    }
}
