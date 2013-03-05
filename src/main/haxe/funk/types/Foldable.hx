package funk.types;

using funk.types.Option;

typedef FoldableType<T> = {
    function foldLeft(value : T, func : Function2<T, T, T>) : Option<T>;
    function foldRight(value : T, func : Function2<T, T, T>) : Option<T>;
}

abstract Foldable<T>(FoldableType<T>) from FoldableType<T> to FoldableType<T> {

    inline function new(foldable : FoldableType<T>) {
        this = foldable;
    }

    inline public function foldLeft(value : T, func : Function2<T, T, T>) : Option<T> {
        return this.foldLeft(value, func);
    }

    inline public function foldRight(value : T, func : Function2<T, T, T>) : Option<T> {
        return this.foldRight(value, func);
    }
}
