package funk.types;

import funk.Funk;
import funk.types.Function1;
import funk.types.Predicate1;
import funk.types.extensions.EnumValues;

using funk.types.Option;
using funk.types.Tuple2;
using funk.ds.immutable.List;

enum Partial1<T1, R> {
    Partial1<T1, R>(define : Predicate1<T1>, partial : Function1<T1, R>);
}

class Partial1Types {

    public static function define<T1, R>(value : Partial1<T1, R>) : Predicate1<T1> {
        return EnumValues.getValueByIndex(value, 0);
    }

    public static function partial<T1, R>(value : Partial1<T1, R>) : Function1<T1, R> {
        return EnumValues.getValueByIndex(value, 1);
    }
}

interface PartialFunction1<T1, R> {

    function isDefinedAt(value : T1) : Bool;

    function orElse(other : PartialFunction1<T1, R>) : PartialFunction1<T1, R>;

    function orAlways(func : Function1<T1, R>) : PartialFunction1<T1, R>;

    function applyOrElse(value0 : T1, func : Function1<T1, R>) : R;

    function call(value : T1) : R;

    function toFunction() : Function1<T1, Option<R>>;
}

class PartialFunction1Types {

    public static function toPartialFunction<T1, R>(    define : Predicate1<T1>,
                                                        partial : Function1<T1, R>
                                                        ) : PartialFunction1<T1, R> {
        return fromPartial(Partial1(define, partial));
    }

    public static function fromPartial<T1, R>(definition : Partial1<T1, R>) : PartialFunction1<T1, R> {
        return PartialFunction1Type.create(Nil.prepend(definition));
    }

    public static function fromPartials<T1, R>(definitions : List<Partial1<T1, R>>) : PartialFunction1<T1, R> {
        return PartialFunction1Type.create(definitions);
    }

    public static function fromTuple<T1, R>(    definition : Tuple2<Predicate1<T1>, Function1<T1, R>>
                                                ) : PartialFunction1<T1, R> {
        return PartialFunction1Type.create(Nil.prepend(Partial1(definition._1(), definition._2())));
    }
}

private class PartialFunction1Type<T1, R> implements PartialFunction1<T1, R> {

    private var _definitions : List<Partial1<T1, R>>;

    private function new(definitions : List<Partial1<T1, R>>) _definitions = definitions;

    public static function create<T1, R>(definitions : List<Partial1<T1, R>>) : PartialFunction1<T1, R> {
        return new PartialFunction1Type(definitions);
    }

    public function isDefinedAt(value : T1) : Bool {
        return _definitions.exists(function(partial) return Partial1Types.define(partial)(value));
    }

    public function orElse(other : PartialFunction1<T1, R>) : PartialFunction1<T1, R> {
        return create(_definitions.prepend(Partial1(other.isDefinedAt, other.call)));
    }

    public function orAlways(func : Function1<T1, R>) : PartialFunction1<T1, R> {
        return create(_definitions.prepend(Partial1(function(value) return true, func)));
    }

    public function applyOrElse(value0 : T1, func : Function1<T1, R>) : R {
        return isDefinedAt(value0) ? call(value0) : func(value0);
    }
    
    public function call(value : T1) : R {
        return switch(_definitions.find(function(partial) return Partial1Types.define(partial)(value))) {
            case Some(partial): Partial1Types.partial(partial)(value);
            case _: Funk.error(NoSuchElementError);
        }
    }

    public function toFunction() : Function1<T1, Option<R>> {
        return function(value) return isDefinedAt(value) ? Some(call(value)) : None;
    }
}
