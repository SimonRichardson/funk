package funk.types;

import funk.types.Function1;
import funk.types.Predicate1;
import funk.types.extensions.EnumValues;

using funk.types.Option;
using funk.types.Tuple2;
using funk.ds.immutable.List;

enum Partial1<T, R> {
    Partial1<T, R>(define : Predicate1<T>, partial : Function1<T, R>);
}

class Partial1Types {

    public static function define<T, R>(value : Partial1<T, R>) : Predicate1<T> {
        return EnumValues.getValueByIndex(value, 0);
    }

    public static function partial<T, R>(value : Partial1<T, R>) : Function1<T, R> {
        return EnumValues.getValueByIndex(value, 0);
    }
}

interface PartialFunction1<T, R> {

    function isDefinedAt(value : T) : Bool;

    function orElse(other : PartialFunction1<T, R>) : PartialFunction1<T, R>;

    function orAlways(func : Function1<T, R>) : PartialFunction1<T, R>;

    function call(value : T) : R;

    function toFunction() : Function1<T, Option<R>>;
}

class PartialFunction1Types {

    public static function asPartialFunction<T, R>(definition : Partial1<T, R>) : PartialFunction1<T, R> {
        return PartialFunction1Type.create(Nil.prepend(definition));
    }

    public static function toPartialFunction<T, R>(definitions : List<Partial1<T, R>>) : PartialFunction1<T, R> {
        return PartialFunction1Type.create(definitions);
    }
}

private class PartialFunction1Type<T, R> implements PartialFunction1<T, R> {

    private var _definitions : List<Partial1<T, R>>;

    private function new(definitions : List<Partial1<T, R>>) _definitions = definitions;

    public static function create<T, R>(definitions : List<Partial1<T, R>>) : PartialFunction1<T, R> {
        return new PartialFunction1Type(definitions);
    }

    public function isDefinedAt(value : T) : Bool {
        return _definitions.exists(function(partial) return Partial1Types.define(partial)(value));
    }

    public function orElse(other : PartialFunction1<T, R>) : PartialFunction1<T, R> {
        return create(_definitions.prepend(Partial1(other.isDefinedAt, other.call)));
    }

    public function orAlways(func : Function1<T, R>) : PartialFunction1<T, R> {
        return create(_definitions.prepend(Partial1(function(value) return true, func)));
    }

    public function call(value : T) : R {
        return switch(_definitions.find(function(partial) return Partial1Types.define(partial)(value))) {
            case Some(partial): Partial1Types.partial(partial)(value);
            case _: Funk.error(NoSuchElementError);
        }
    }

    public function toFunction() : Function1<T, Option<R>> {
        return function(value) return isDefinedAt(value) ? Some(call(value)) : None;
    }
}
