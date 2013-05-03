package funk.types;

import funk.types.Function5;
import funk.types.Predicate5;
import funk.types.extensions.EnumValues;

using funk.types.Option;
using funk.types.Tuple2;
using funk.ds.immutable.List;

enum Partial5<T1, T2, T3, T4, T5, R> {
    Partial5<T1, T2, T3, T4, T5, R>(define : Predicate5<T1, T2, T3, T4, T5>, partial : Function5<T1, T2, T3, T4, T5, R>);
}

class Partial5Types {

    public static function define<T1, T2, T3, T4, T5, R>(   value : Partial5<T1, T2, T3, T4, T5, R>
                                                            ) : Predicate5<T1, T2, T3, T4, T5> {
        return EnumValues.getValueByIndex(value, 0);
    }

    public static function partial<T1, T2, T3, T4, T5, R>(  value : Partial5<T1, T2, T3, T4, T5, R>
                                                        ) : Function5<T1, T2, T3, T4, T5, R> {
        return EnumValues.getValueByIndex(value, 1);
    }
}

interface PartialFunction5<T1, T2, T3, T4, T5, R> {

    function isDefinedAt(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) : Bool;

    function orElse(other : PartialFunction5<T1, T2, T3, T4, T5, R>) : PartialFunction5<T1, T2, T3, T4, T5, R>;

    function orAlways(func : Function5<T1, T2, T3, T4, T5, R>) : PartialFunction5<T1, T2, T3, T4, T5, R>;

    function applyOrElse(   value0 : T1, 
                            value1 : T2, 
                            value2 : T3, 
                            value3 : T4, 
                            value4 : T5, 
                            func : Function5<T1, T2, T3, T4, T5, R>
                            ) : R;

    function call(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) : R;

    function toFunction() : Function5<T1, T2, T3, T4, T5, Option<R>>;
}

class PartialFunction5Types {

    public static function toPartialFunction<T1, T2, T3, T4, T5, R>(    define : Predicate5<T1, T2, T3, T4, T5>,
                                                                        partial : Function5<T1, T2, T3, T4, T5, R>
                                                                        ) : PartialFunction5<T1, T2, T3, T4, T5, R> {
        return fromPartial(Partial5(define, partial));
    }

    public static function fromPartial<T1, T2, T3, T4, T5, R>(  definition : Partial5<T1, T2, T3, T4, T5, R>
                                                                ) : PartialFunction5<T1, T2, T3, T4, T5, R> {
        return PartialFunction5Type.create(Nil.prepend(definition));
    }

    public static function fromPartials<T1, T2, T3, T4, T5, R>( definitions : List<Partial5<T1, T2, T3, T4, T5, R>>
                                                                ) : PartialFunction5<T1, T2, T3, T4, T5, R> {
        return PartialFunction5Type.create(definitions);
    }

    public static function fromTuple<T1, T2, T3, T4, T5, R>(    definition : Tuple2<Predicate5<T1, T2, T3, T4, T5>, Function5<T1, T2, T3, T4, T5, R>>
                                                                ) : PartialFunction5<T1, T2, T3, T4, T5, R> {
        return PartialFunction5Type.create(Nil.prepend(Partial5(definition._1(), definition._2())));
    }
}

private class PartialFunction5Type<T1, T2, T3, T4, T5, R> implements PartialFunction5<T1, T2, T3, T4, T5, R> {

    private var _definitions : List<Partial5<T1, T2, T3, T4, T5, R>>;

    private function new(definitions : List<Partial5<T1, T2, T3, T4, T5, R>>) _definitions = definitions;

    public static function create<T1, T2, T3, T4, T5, R>(   definitions : List<Partial5<T1, T2, T3, T4, T5, R>>
                                                    ) : PartialFunction5<T1, T2, T3, T4, T5, R> {
        return new PartialFunction5Type(definitions);
    }

    public function isDefinedAt(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) : Bool {
        return _definitions.exists(function(partial) {
            return Partial5Types.define(partial)(value0, value1, value2, value3, value4);
        });
    }

    public function orElse(other : PartialFunction5<T1, T2, T3, T4, T5, R>) : PartialFunction5<T1, T2, T3, T4, T5, R> {
        return create(_definitions.prepend(Partial5(other.isDefinedAt, other.call)));
    }

    public function orAlways(func : Function5<T1, T2, T3, T4, T5, R>) : PartialFunction5<T1, T2, T3, T4, T5, R> {
        return create(_definitions.prepend(Partial5(function(value0, value1, value2, value3, value4) return true, func)));
    }

    public function applyOrElse(    value0 : T1, 
                                    value1 : T2, 
                                    value2 : T3, 
                                    value3 : T4, 
                                    value4 : T5,
                                    func : Function5<T1, T2, T3, T4, T5, R>
                                    ) : R {
        return isDefinedAt(value0, value1, value2, value3, value4) ? 
                    call(value0, value1, value2, value3, value4) : 
                    func(value0, value1, value2, value3, value4);
    }

    public function call(value0 : T1, value1 : T2, value2 : T3, value3 : T4, value4 : T5) : R {
        return switch(_definitions.find(function(partial) {
            return Partial5Types.define(partial)(value0, value1, value2, value3, value4);
        })) {
            case Some(partial): Partial5Types.partial(partial)(value0, value1, value2, value3, value4);
            case _: Funk.error(NoSuchElementError);
        }
    }

    public function toFunction() : Function5<T1, T2, T3, T4, T5, Option<R>> {
        return function(value0, value1, value2, value3, value4) {
            return isDefinedAt(value0, value1, value2, value3, value4) ?
                            Some(call(value0, value1, value2, value3, value4)) :
                            None;
        }
    }
}
