package funk.types;

import funk.types.Function4;
import funk.types.Predicate4;
import funk.types.extensions.EnumValues;

using funk.types.Option;
using funk.types.Tuple2;
using funk.ds.immutable.List;

enum Partial4<T1, T2, T3, T4, R> {
    Partial4<T1, T2, T3, T4, R>(define : Predicate4<T1, T2, T3, T4>, partial : Function4<T1, T2, T3, T4, R>);
}

class Partial4Types {

    public static function define<T1, T2, T3, T4, R>(value : Partial4<T1, T2, T3, T4, R>) : Predicate4<T1, T2, T3, T4> {
        return EnumValues.getValueByIndex(value, 0);
    }

    public static function partial<T1, T2, T3, T4, R>(  value : Partial4<T1, T2, T3, T4, R>
                                                        ) : Function4<T1, T2, T3, T4, R> {
        return EnumValues.getValueByIndex(value, 1);
    }
}

interface PartialFunction4<T1, T2, T3, T4, R> {

    function isDefinedAt(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : Bool;

    function orElse(other : PartialFunction4<T1, T2, T3, T4, R>) : PartialFunction4<T1, T2, T3, T4, R>;

    function orAlways(func : Function4<T1, T2, T3, T4, R>) : PartialFunction4<T1, T2, T3, T4, R>;

    function call(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : R;

    function toFunction() : Function4<T1, T2, T3, T4, Option<R>>;
}

class PartialFunction4Types {

    public static function toPartialFunction<T1, T2, T3, T4, R>(    define : Predicate4<T1, T2, T3, T4>,
                                                                    partial : Function4<T1, T2, T3, T4, R>
                                                                    ) : PartialFunction4<T1, T2, T3, T4, R> {
        return fromPartial(Partial4(define, partial));
    }

    public static function fromPartial<T1, T2, T3, T4, R>(  definition : Partial4<T1, T2, T3, T4, R>
                                                            ) : PartialFunction4<T1, T2, T3, T4, R> {
        return PartialFunction4Type.create(Nil.prepend(definition));
    }

    public static function fromPartials<T1, T2, T3, T4, R>( definitions : List<Partial4<T1, T2, T3, T4, R>>
                                                            ) : PartialFunction4<T1, T2, T3, T4, R> {
        return PartialFunction4Type.create(definitions);
    }

    public static function fromTuple<T1, T2, T3, T4, R>(    definition : Tuple2<Predicate4<T1, T2, T3, T4>, Function4<T1, T2, T3, T4, R>>
                                                            ) : PartialFunction4<T1, T2, T3, T4, R> {
        return PartialFunction4Type.create(Nil.prepend(Partial4(definition._1(), definition._2())));
    }
}

private class PartialFunction4Type<T1, T2, T3, T4, R> implements PartialFunction4<T1, T2, T3, T4, R> {

    private var _definitions : List<Partial4<T1, T2, T3, T4, R>>;

    private function new(definitions : List<Partial4<T1, T2, T3, T4, R>>) _definitions = definitions;

    public static function create<T1, T2, T3, T4, R>(   definitions : List<Partial4<T1, T2, T3, T4, R>>
                                                    ) : PartialFunction4<T1, T2, T3, T4, R> {
        return new PartialFunction4Type(definitions);
    }

    public function isDefinedAt(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : Bool {
        return _definitions.exists(function(partial) return Partial4Types.define(partial)(value0, value1, value2, value3));
    }

    public function orElse(other : PartialFunction4<T1, T2, T3, T4, R>) : PartialFunction4<T1, T2, T3, T4, R> {
        return create(_definitions.prepend(Partial4(other.isDefinedAt, other.call)));
    }

    public function orAlways(func : Function4<T1, T2, T3, T4, R>) : PartialFunction4<T1, T2, T3, T4, R> {
        return create(_definitions.prepend(Partial4(function(value0, value1, value2, value3) return true, func)));
    }

    public function call(value0 : T1, value1 : T2, value2 : T3, value3 : T4) : R {
        return switch(_definitions.find(function(partial) {
            return Partial4Types.define(partial)(value0, value1, value2, value3);
        })) {
            case Some(partial): Partial4Types.partial(partial)(value0, value1, value2, value3);
            case _: Funk.error(NoSuchElementError);
        }
    }

    public function toFunction() : Function4<T1, T2, T3, T4, Option<R>> {
        return function(value0, value1, value2, value3) {
            return isDefinedAt(value0, value1, value2, value3) ? Some(call(value0, value1, value2, value3)) : None;
        }
    }
}
