package funk.ds.extensions;

import funk.types.Predicate1;

using funk.types.Option;

typedef DropableType<T> = {
    function dropLeft(amount : Int) : Collection<T>;
    function dropRight(amount : Int) : Collection<T>;
    function dropWhile(func : Predicate1<T>) : Collection<T>;
}

abstract Dropable<T>(DropableType<T>) from DropableType<T> to DropableType<T> {

    inline function new(dropable : DropableType<T>) {
        this = dropable;
    }

    inline public function dropLeft(amount : Int) : Collection<T> return this.dropLeft(amount);

    inline public function dropRight(amount : Int) : Collection<T> return this.dropRight(amount);

    inline public function dropWhile(func : Predicate1<T>) : Collection<T> return this.dropWhile(func);
}
