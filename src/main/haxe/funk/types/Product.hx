package funk.types;

import funk.types.Option;

typedef Product<T> = {> Iterable<T>,

    function productArity() : Int;

    function productPrefix() : String;

    function productElement(index : Int) : Option<T>;
};
