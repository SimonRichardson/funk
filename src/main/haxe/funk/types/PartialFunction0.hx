package funk.types;

import funk.Funk;
import funk.types.Function0;
import funk.types.Predicate0;
import funk.types.extensions.EnumValues;

using funk.types.Option;
using funk.types.Tuple2;
using funk.ds.immutable.List;

enum Partial0<R> {
    Partial0<R>(define : Predicate0, partial : Function0<R>);
}

class Partial0Types {

    inline public static function define<R>(value : Partial0<R>) : Predicate0 {
        return EnumValues.getValueByIndex(value, 0);
    }

    inline public static function partial<R>(value : Partial0<R>) : Function0<R> {
        return EnumValues.getValueByIndex(value, 1);
    }
}

interface PartialFunction0<R> {

    function isDefinedAt() : Bool;

    function orElse(other : PartialFunction0<R>) : PartialFunction0<R>;

    function orAlways(func : Function0<R>) : PartialFunction0<R>;

    function applyOrElse(func : Function0<R>) : R;

    function apply() : R;

    function applyToAll() : List<R>;

    function toFunction() : Function0<Option<R>>;
}

class PartialFunction0Types {

    public static function toPartialFunction<R>(    define : Predicate0,
                                                    partial : Function0<R>
                                                    ) : PartialFunction0<R> {
        return fromPartial(Partial0(define, partial));
    }

    public static function fromFunction<R>(func : Function0<R>) : PartialFunction0<R> {
        return fromPartial(Partial0(function() return true, func));
    }

    public static function fromPartial<R>(definition : Partial0<R>) : PartialFunction0<R> {
        return PartialFunction0Type.create(Nil.prepend(definition));
    }

    public static function fromPartials<R>(definitions : List<Partial0<R>>) : PartialFunction0<R> {
        return PartialFunction0Type.create(definitions);
    }

    public static function fromTuple<R>(    definition : Tuple2<Predicate0, Function0<R>>
                                            ) : PartialFunction0<R> {
        return PartialFunction0Type.create(Nil.prepend(Partial0(definition._1(), definition._2())));
    }
}

private class PartialFunction0Type<R> implements PartialFunction0<R> {

    private var _definitions : List<Partial0<R>>;

    private function new(definitions : List<Partial0<R>>) _definitions = definitions;

    public static function create<R>(definitions : List<Partial0<R>>) : PartialFunction0<R> {
        return new PartialFunction0Type(definitions);
    }

    inline public function isDefinedAt() : Bool {
        return _definitions.exists(function(partial) return Partial0Types.define(partial)());
    }

    inline public function orElse(other : PartialFunction0<R>) : PartialFunction0<R> {
        return create(_definitions.prepend(Partial0(other.isDefinedAt, other.apply)));
    }

    inline public function orAlways(func : Function0<R>) : PartialFunction0<R> {
        return create(_definitions.prepend(Partial0(function() return true, func)));
    }

    inline public function applyOrElse(func : Function0<R>) : R {
        return isDefinedAt() ? apply() : func();
    }

    inline public function apply() : R {
        return switch(_definitions.find(function(partial) return Partial0Types.define(partial)())) {
            case Some(partial): Partial0Types.partial(partial)();
            case _: Funk.error(NoSuchElementError);
        }
    }

    inline public function applyToAll() : List<R> {
        var filtered = _definitions.filter(function(partial) return Partial0Types.define(partial)());
        return filtered.map(function(partial) return Partial0Types.partial(partial)());
    }

    inline public function toFunction() : Function0<Option<R>> {
        return function() return isDefinedAt() ? Some(apply()) : None;
    }
}
