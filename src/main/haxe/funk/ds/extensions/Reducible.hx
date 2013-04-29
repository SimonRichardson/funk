package funk.ds.extensions;

import funk.types.Function2;

using funk.types.Option;

typedef ReducibleType<T> = {
    function reduceLeft(func : Function2<T, T, T>) : Option<T>;
    function reduceRight(func : Function2<T, T, T>) : Option<T>;
}

abstract Reducible<T>(ReducibleType<T>) from ReducibleType<T> to ReducibleType<T> {

    inline function new(foldable : ReducibleType<T>) {
        this = foldable;
    }

    inline public function reduceLeft(func : Function2<T, T, T>) : Option<T> {
        return this.reduceLeft(func);
    }

    inline public function reduceRight(func : Function2<T, T, T>) : Option<T> {
        return this.reduceRight(func);
    }
}
