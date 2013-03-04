package funk.types;

import funk.Funk;
import funk.types.Attempt;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Predicate2;
import haxe.ds.Option;
import funk.types.extensions.Anys;

using funk.types.extensions.Bools;
using funk.types.extensions.Options;

enum AttemptType<T> {
    Success(value : T);
    Failure(error : Errors);
}

abstract Attempt<T>(AttemptType<T>) from AttemptType<T> to AttemptType<T> {

    inline function new(attempt : AttemptType<T>) {
        this = attempt;
    }

    @:to
    inline public static function toOption<T>(attempt : AttemptType<T>) : Option<T> {
        return AttemptTypes.toOption(attempt);
    }

    @:to
    inline public static function toString<T>(attempt : AttemptType<T>) : String {
        return AttemptTypes.toString(attempt);
    }
}

class AttemptTypes {

    public static function isSuccessful<T>(attempt : Attempt<T>) : Bool {
        return switch(attempt) {
            case Success(_): true;
            case _: false;
        }
    }

    public static function isFailure<T>(attempt : Attempt<T>) : Bool {
        return !isSuccessful(attempt);
    }

    public static function success<T>(attempt : Attempt<T>) : Option<T> {
        return switch(attempt) {
            case Success(value): Options.toOption(value);
            case _: None;
        }
    }

    public static function failure<T>(attempt : Attempt<T>) : Option<Errors> {
        return switch(attempt) {
            case Failure(value): Options.toOption(value);
            case _: None;
        }
    }

    public static function swap<T>(attempt : Attempt<T>) : Attempt<Errors> {
        return switch(attempt) {
            case Failure(value): Success(value);
            case _: Failure(Error("Failure"));
        }
    }

    public static function flatten<T>(attempt : Attempt<Attempt<T>>) : Attempt<T> {
        return switch(attempt) {
            case Success(value): value;
            case Failure(value): Failure(value);
            case _: Failure(Error("Failure"));
        }
    }

    public static function flattenSuccess<T>(attempt : Attempt<Attempt<T>>) : Attempt<T> {
        return switch(attempt) {
            case Success(value): value;
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function flattenFailure<T>(attempt : Attempt<Attempt<T>>) : Attempt<Errors> {
        return switch(attempt) {
            case Failure(value): Failure(value);
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function fold<T1, T2>(    attempt : Attempt<T1>,
                                            funcSuccess : Function1<T1, T2>,
                                            funcFailure : Function1<Errors, T2>
                                            ) : T2 {
        return switch(attempt) {
            case Success(value): funcSuccess(value);
            case Failure(error): funcFailure(error);
            case _: Failure(Error("Failure"));
        }
    }

    public static function foldSuccess<T1, T2>(attempt : Attempt<T1>, func : Function1<T1, T2>) : T2 {
        return switch(attempt) {
            case Success(value): func(value);
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function foldFailure<T1, T2>(attempt : Attempt<T1>, func : Function1<Errors, T2>) : T2 {
        return switch(attempt) {
            case Failure(value): func(value);
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function map<T1, T2>( attempt : Attempt<T1>,
                                        funcSuccess : Function1<T1, T2>,
                                        funcFailure : Function1<Errors, Errors>
                                        ) : Attempt<T2> {
        return switch(attempt) {
            case Success(value): Success(funcSuccess(value));
            case Failure(value): Failure(funcFailure(value));
            case _: Failure(Error("Failure"));
        }
    }

    public static function mapSuccess<T1, T2>(attempt : Attempt<T1>, func : Function1<T1, T2>) : Attempt<T2> {
        return switch(attempt) {
            case Success(value): Success(func(value));
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function mapFailure<T>(attempt : Attempt<T>, func : Function1<Errors, Errors>) : Attempt<T> {
        return switch(attempt) {
            case Failure(value): Failure(func(value));
            case _: Funk.error(IllegalOperationError());
        }
    }

    public static function equals<T>(   a : Attempt<T>,
                                        b : Attempt<T>,
                                        ?funcSuccess : Predicate2<T, T>,
                                        ?funcFailure : Predicate2<Errors, Errors>
                                        ) : Bool {
        return switch (a) {
            case Success(left0):
                switch (b) {
                    case Success(left1): Anys.equals(left0, left1, funcSuccess);
                    case _: false;
                }
            case Failure(right0):
                switch (b) {
                    case Failure(right1): Anys.equals(right0, right1, funcFailure);
                    case _: false;
                }
            case _: false;
        }
    }

    public static function toEither<T>(attempt : Attempt<T>) : Either<Errors, T> {
        return switch(attempt) {
            case Success(value): Right(value);
            case Failure(value): Left(value);
            case _: Left(Error("Failure"));
        }
    }

    public static function toBool<T>(attempt : Attempt<T>) : Bool {
        return switch(attempt) {
            case Success(_): true;
            case _: false;
        }
    }

    public static function toOption<T>(attempt : Attempt<T>) : Option<T> {
        return switch(attempt) {
            case Success(value): Some(value);
            case _: None;
        }
    }

    public static function toAttempt<T>(any : Null<T>) : Attempt<T> {
        return Anys.toBool(any).not() ? Failure(Error("Failure")) : Success(any);
    }

    inline public static function toString<T>( attempt : Attempt<T>,
                                        ?funcSuccess : Function1<T, String>,
                                        ?funcFailure : Function1<Errors, String>) : String {
        return switch (attempt) {
            case Success(value): 'Success(${Anys.toString(value, funcSuccess)})';
            case Failure(value): 'Failure(${Anys.toString(value, funcFailure)})';
            case _: 'Failure(Invalid)';
        }
    }
}
