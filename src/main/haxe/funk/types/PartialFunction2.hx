package funk.types;

import funk.types.Function2;
import funk.types.Predicate2;
import funk.types.extensions.EnumValues;

using funk.types.Option;
using funk.types.Tuple2;
using funk.ds.immutable.List;

enum Partial2<T1, T2, R> {
    Partial2<T1, T2, R>(define : Predicate2<T1, T2>, partial : Function2<T1, T2, R>);
}

class Partial2Types {

    public static function define<T1, T2, R>(value : Partial2<T1, T2, R>) : Predicate2<T1, T2> {
        return EnumValues.getValueByIndex(value, 0);
    }

    public static function partial<T1, T2, R>(value : Partial2<T1, T2, R>) : Function2<T1, T2, R> {
        return EnumValues.getValueByIndex(value, 1);
    }
}

interface PartialFunction2<T1, T2, R> {

    function isDefinedAt(value0 : T1, value1 : T2) : Bool;

    function orElse(other : PartialFunction2<T1, T2, R>) : PartialFunction2<T1, T2, R>;

    function orAlways(func : Function2<T1, T2, R>) : PartialFunction2<T1, T2, R>;

    function call(value0 : T1, value1 : T2) : R;

    function toFunction() : Function2<T1, T2, Option<R>>;
}

class PartialFunction2Types {

    public static function toPartialFunction<T1, T2, R>(    define : Predicate2<T1, T2>,
                                                            partial : Function2<T1, T2, R>
                                                            ) : PartialFunction2<T1, T2, R> {
        return fromPartial(Partial2(define, partial));
    }

    public static function fromPartial<T1, T2, R>(  definition : Partial2<T1, T2, R>
                                                    ) : PartialFunction2<T1, T2, R> {
        return PartialFunction2Type.create(Nil.prepend(definition));
    }

    public static function fromPartials<T1, T2, R>( definitions : List<Partial2<T1, T2, R>>
                                                    ) : PartialFunction2<T1, T2, R> {
        return PartialFunction2Type.create(definitions);
    }

    public static function fromTuple<T1, T2, R>(    definition : Tuple2<Predicate2<T1, T2>, Function2<T1, T2, R>>
                                                    ) : PartialFunction2<T1, T2, R> {
        return PartialFunction2Type.create(Nil.prepend(Partial2(definition._1(), definition._2())));
    }
}

private class PartialFunction2Type<T1, T2, R> implements PartialFunction2<T1, T2, R> {

    private var _definitions : List<Partial2<T1, T2, R>>;

    private function new(definitions : List<Partial2<T1, T2, R>>) _definitions = definitions;

    public static function create<T1, T2, R>(definitions : List<Partial2<T1, T2, R>>) : PartialFunction2<T1, T2, R> {
        return new PartialFunction2Type(definitions);
    }

    public function isDefinedAt(value0 : T1, value1 : T2) : Bool {
        return _definitions.exists(function(partial) return Partial2Types.define(partial)(value0, value1));
    }

    public function orElse(other : PartialFunction2<T1, T2, R>) : PartialFunction2<T1, T2, R> {
        return create(_definitions.prepend(Partial2(other.isDefinedAt, other.call)));
    }

    public function orAlways(func : Function2<T1, T2, R>) : PartialFunction2<T1, T2, R> {
        return create(_definitions.prepend(Partial2(function(value0, value1) return true, func)));
    }

    public function call(value0 : T1, value1 : T2) : R {
        return switch(_definitions.find(function(partial) return Partial2Types.define(partial)(value0, value1))) {
            case Some(partial): Partial2Types.partial(partial)(value0, value1);
            case _: Funk.error(NoSuchElementError);
        }
    }

    public function toFunction() : Function2<T1, T2, Option<R>> {
        return function(value0, value1) return isDefinedAt(value0, value1) ? Some(call(value0, value1)) : None;
    }
}
