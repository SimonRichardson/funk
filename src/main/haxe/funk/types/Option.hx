package funk.types;

import funk.Funk;
import funk.types.Any;
import funk.types.Attempt;
import funk.types.Either;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Predicate2;

enum OptionType<T> {
    Some(value : T);
    None;
}

abstract Option<T>(OptionType<T>) from OptionType<T> to OptionType<T> {

    inline function new(option : OptionType<T>) {
        this = option;
    }

    @:from
    inline public static function fromValue<T>(value : T) : Option<T> return OptionTypes.toOption(value);
    
    @:to
    inline public static function toString<T>(option : OptionType<T>) : String return OptionTypes.toString(option);
}

class OptionTypes {

    public static function get<T>(option : Option<T>) : T {
        return switch (option) {
            case Some(value): value;
            case _: Funk.error(NoSuchElementError);
        }
    }

    public static function orElse<T>(option : Option<T>, func : Function0<Option<T>>) : Option<T> {
        return switch (option) {
            case Some(_): option;
            case _: func();
        }
    }

    public static function getOrElse<T>(option : Option<T>, func : Function0<T>) : T {
        return switch (option) {
            case Some(value): value;
            case _: func();
        }
    }

    public static function isDefined<T>(option : Option<T>) : Bool {
        return switch (option) {
            case Some(_): true;
            case _: false;
        }
    }

    public static function isEmpty<T>(option : Option<T>) : Bool {
        return !isDefined(option);
    }

    public static function filter<T>(option : Option<T>, func : Function1<T, Bool>) : Option<T> {
        return switch (option) {
            case Some(value): func(value) ? Some(value) : None;
            case _: None;
        }
    }

    public static function foreach<T>(option : Option<T>, func : Function1<T, Void>) : Void {
        switch (option) {
            case Some(value): func(value);
            case _:
        }
    }

    public static function flatten<T>(option : Option<Option<T>>) : Option<T> {
        return switch (option) {
            case Some(value): value;
            case _: None;
        }
    }

    public static function map<T1, T2>(option : Option<T1>, func : Function1<T1, T2>) : Option<T2> {
        return switch (option) {
            case Some(value): Some(func(value));
            case _: None;
        }
    }

    public static function flatMap<T1, T2>(option : Option<T1>, func : Function1<T1, Option<T2>>) : Option<T2> {
        return switch (option) {
            case Some(value): func(value);
            case _: None;
        }
    }

    public static function equals<T>(a : Option<T>, b : Option<T>, ?func : Predicate2<T, T>) : Bool {
        return switch (a) {
            case Some(value0):
                switch(b) {
                    case Some(value1):
                        // Create the function when needed.
                        var eq : Predicate2<T, T> = function(a, b) : Bool return null != func ? func(a, b) : a == b;
                        eq(value0, value1);
                    case _: false;
                }
            case None:
                switch(b) {
                    case Some(_): false;
                    case _: true;
                }
            case _: false;
        }
    }

    public static function toLeft<T1, T2>(option : Option<T1>, ?func : Function0<T2>) : Either<T1, T2> {
        return switch (option) {
            case Some(value): Left(value);
            case _:
                if (null == func) Funk.error(ArgumentError());
                Right(func());
        }
    }

    public static function toRight<T1, T2>(option : Option<T1>, ?func : Function0<T2>) : Either<T2, T1> {
        return switch (option) {
            case Some(value): Right(value);
            case _:
                if (null == func) Funk.error(ArgumentError());
                Left(func());
        }
    }

    public static function toEither<T1, T2>(option : Option<T1>, func : Function0<T2>) : Either<T2, T1> {
        return switch (option) {
            case Some(value): Right(value);
            case _: Left(func());
        }
    }

    public static function toBool<T>(option : Option<T>) : Bool {
        return switch (option) {
            case Some(_): true;
            case _: false;
        }
    }

    public static function toOption<T>(any : Null<T>) : Option<T> {
        return AnyTypes.toBool(any) ? Some(any) : None;
    }

    public static function toString<T>(option : Option<T>, ?func : Function1<T, String>) : String {
        return switch (option) {
            case Some(value): 'Some(${AnyTypes.toString(value, func)})';
            case _: 'None';
        }
    }
}
