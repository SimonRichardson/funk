package funk.types;

import funk.types.Function3;
import funk.types.Predicate3;
import funk.types.extensions.EnumValues;

using funk.types.Option;
using funk.types.Tuple2;
using funk.ds.immutable.List;

enum Partial3<T1, T2, T3, R> {
    Partial3<T1, T2, T3, R>(define : Predicate3<T1, T2, T3>, partial : Function3<T1, T2, T3, R>);
}

class Partial3Types {

    public static function define<T1, T2, T3, R>(value : Partial3<T1, T2, T3, R>) : Predicate3<T1, T2, T3> {
        return EnumValues.getValueByIndex(value, 0);
    }

    public static function partial<T1, T2, T3, R>(value : Partial3<T1, T2, T3, R>) : Function3<T1, T2, T3, R> {
        return EnumValues.getValueByIndex(value, 1);
    }
}

interface PartialFunction3<T1, T2, T3, R> {

    function isDefinedAt(value0 : T1, value1 : T2, value2 : T3) : Bool;

    function orElse(other : PartialFunction3<T1, T2, T3, R>) : PartialFunction3<T1, T2, T3, R>;

    function orAlways(func : Function3<T1, T2, T3, R>) : PartialFunction3<T1, T2, T3, R>;

    function applyOrElse(value0 : T1, value1 : T2, value2 : T3, func : Function3<T1, T2, T3, R>) : R;

    function call(value0 : T1, value1 : T2, value2 : T3) : R;

    function toFunction() : Function3<T1, T2, T3, Option<R>>;
}

class PartialFunction3Types {

    public static function toPartialFunction<T1, T2, T3, R>(    define : Predicate3<T1, T2, T3>,
                                                                partial : Function3<T1, T2, T3, R>
                                                                ) : PartialFunction3<T1, T2, T3, R> {
        return fromPartial(Partial3(define, partial));
    }

    public static function fromPartial<T1, T2, T3, R>(  definition : Partial3<T1, T2, T3, R>
                                                        ) : PartialFunction3<T1, T2, T3, R> {
        return PartialFunction3Type.create(Nil.prepend(definition));
    }

    public static function fromPartials<T1, T2, T3, R>( definitions : List<Partial3<T1, T2, T3, R>>
                                                        ) : PartialFunction3<T1, T2, T3, R> {
        return PartialFunction3Type.create(definitions);
    }

    public static function fromTuple<T1, T2, T3, R>(    definition : Tuple2<Predicate3<T1, T2, T3>, Function3<T1, T2, T3, R>>
                                                        ) : PartialFunction3<T1, T2, T3, R> {
        return PartialFunction3Type.create(Nil.prepend(Partial3(definition._1(), definition._2())));
    }
}

private class PartialFunction3Type<T1, T2, T3, R> implements PartialFunction3<T1, T2, T3, R> {

    private var _definitions : List<Partial3<T1, T2, T3, R>>;

    private function new(definitions : List<Partial3<T1, T2, T3, R>>) _definitions = definitions;

    public static function create<T1, T2, T3, R>(   definitions : List<Partial3<T1, T2, T3, R>>
                                                    ) : PartialFunction3<T1, T2, T3, R> {
        return new PartialFunction3Type(definitions);
    }

    public function isDefinedAt(value0 : T1, value1 : T2, value2 : T3) : Bool {
        return _definitions.exists(function(partial) return Partial3Types.define(partial)(value0, value1, value2));
    }

    public function orElse(other : PartialFunction3<T1, T2, T3, R>) : PartialFunction3<T1, T2, T3, R> {
        return create(_definitions.prepend(Partial3(other.isDefinedAt, other.call)));
    }

    public function orAlways(func : Function3<T1, T2, T3, R>) : PartialFunction3<T1, T2, T3, R> {
        return create(_definitions.prepend(Partial3(function(value0, value1, value2) return true, func)));
    }

    public function applyOrElse(value0 : T1, value1 : T2, value2 : T3, func : Function3<T1, T2, T3, R>) : R {
        return isDefinedAt(value0, value1, value2) ? call(value0, value1, value2) : func(value0, value1, value2);
    }

    public function call(value0 : T1, value1 : T2, value2 : T3) : R {
        return switch(_definitions.find(function(partial) {
            return Partial3Types.define(partial)(value0, value1, value2);
        })) {
            case Some(partial): Partial3Types.partial(partial)(value0, value1, value2);
            case _: Funk.error(NoSuchElementError);
        }
    }

    public function toFunction() : Function3<T1, T2, T3, Option<R>> {
        return function(value0, value1, value2) {
            return isDefinedAt(value0, value1, value2) ? Some(call(value0, value1, value2)) : None;
        }
    }
}
