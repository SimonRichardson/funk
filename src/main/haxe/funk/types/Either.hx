package funk.types;

import funk.Funk;
import funk.types.Attempt;
import funk.types.Either;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Predicate2;
import funk.types.Any;

using funk.types.Option;

enum EitherType<T1, T2> {
    Left(value : T1);
    Right(value : T2);
}

abstract Either<T1, T2>(EitherType<T1, T2>) from EitherType<T1, T2> to EitherType<T1, T2> {

    inline function new(either : EitherType<T1, T2>) {
        this = either;
    }

    @:from
    inline public static function fromValue<T>(value : T) : Either<T, T> {
        return EitherTypes.toEither(value);
    }

    @:to
    inline public static function toOption<T1, T2>(either : EitherType<T1, T2>) : Option<T2> {
        return EitherTypes.toOption(either);
    }

    @:to
    inline public static function toString<T1, T2>(either : EitherType<T1, T2>) : String {
        return EitherTypes.toString(either);
    }
}

class EitherTypes {

    public static function isLeft<T1, T2>(either : Either<T1, T2>) : Bool {
        return switch(either) {
            case Left(_): true;
            case _: false;
        }
    }

    public static function isRight<T1, T2>(either : Either<T1, T2>) : Bool {
        return !isLeft(either);
    }

    public static function left<T1, T2>(either : Either<T1, T2>) : Option<T1> {
        return switch(either) {
            case Left(value): OptionTypes.toOption(value);
            case _: None;
        }
    }

    public static function right<T1, T2>(either : Either<T1, T2>) : Option<T2> {
        return switch(either) {
            case Right(value): OptionTypes.toOption(value);
            case _: None;
        }
    }

    public static function swap<T1, T2>(either : Either<T1, T2>) : Either<T2, T1> {
        return switch(either) {
            case Left(value): Right(value);
            case Right(value): Left(value);
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function flatten<T1, T2>(either : Either<Either<T1, T2>, Either<T1, T2>>) : Either<T1, T2> {
        return switch(either) {
            case Left(value): value;
            case Right(value): value;
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function flattenLeft<T1, T2>(either : Either<Either<T1, T2>, T2>) : Either<T1, T2> {
        return switch(either) {
            case Left(value): value;
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function flattenRight<T1, T2>(either : Either<T1, Either<T1, T2>>) : Either<T1, T2> {
        return switch(either) {
            case Right(value): value;
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function fold<T1, T2, T3>(    either : Either<T1, T2>,
                                                funcLeft : Function1<T1, T3>,
                                                funcRight : Function1<T2, T3>
                                                ) : T3 {
        return switch(either) {
            case Left(value): funcLeft(value);
            case Right(value): funcRight(value);
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function foldLeft<T1, T2, T3>(either : Either<T1, T2>, func : Function1<T1, T3>) : T3 {
        return switch(either) {
            case Left(value): func(value);
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function foldRight<T1, T2, T3>(either : Either<T1, T2>, func : Function1<T2, T3>) : T3 {
        return switch(either) {
            case Right(value): func(value);
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function map<T1, T2, T3, T4>(    either : Either<T1, T2>,
                                                funcLeft : Function1<T1, T3>,
                                                funcRight : Function1<T2, T4>
                                                ) : Either<T3, T4> {
        return switch(either) {
            case Left(value): Left(funcLeft(value));
            case Right(value): Right(funcRight(value));
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function mapLeft<T1, T2, T3>(either : Either<T1, T2>, func : Function1<T1, T3>) : Either<T3, T2> {
        return switch(either) {
            case Left(value): Left(func(value));
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function mapRight<T1, T2, T3>(either : Either<T1, T2>, func : Function1<T2, T3>) : Either<T1, T3> {
        return switch(either) {
            case Right(value): Right(func(value));
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function equals<T1, T2>(    a : Either<T1, T2>,
                                            b : Either<T1, T2>,
                                            ?funcLeft : Predicate2<T1, T1>,
                                            ?funcRight : Predicate2<T2, T2>
                                            ) : Bool {
        return switch (a) {
            case Left(left0):
                switch (b) {
                    case Left(left1): AnyTypes.equals(left0, left1, funcLeft);
                    case _: false;
                }
            case Right(right0):
                switch (b) {
                    case Right(right1): AnyTypes.equals(right0, right1, funcRight);
                    case _: false;
                }
            case _: false;
        }
    }

    public static function toAttempt<T1, T2>(either : Either<T1, T2>) : Attempt<T2> {
        return switch(either) {
            case Right(value): Success(value);
            case _: Failure(Error("Attempt failure"));
        }
    }

    public static function toBool<T1, T2>(either : Either<T1, T2>) : Bool {
        return switch(either) {
            case Right(_): true;
            case _: false;
        }
    }

    public static function toOption<T1, T2>(either : Either<T1, T2>) : Option<T2> {
        return switch(either) {
            case Right(value): Some(value);
            case _: None;
        }
    }

    public static function toEither<T>(any : Null<T>) : Either<T, T> {
        return AnyTypes.toBool(any) ? Right(any) : Left(any);
    }

    public static function toString<T1, T2>(    either : Either<T1, T2>,
                                                ?funcLeft : Function1<T1, String>,
                                                ?funcRight : Function1<T2, String>) : String {
        return switch (either) {
            case Left(value): 'Left(${AnyTypes.toString(value, funcLeft)})';
            case Right(value): 'Right(${AnyTypes.toString(value, funcRight)})';
            case _: 'Left(Invalid)';
        }
    }
}
