package funk.types.extensions;

import funk.Funk;
import funk.types.Attempt;
import funk.types.Either;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Predicate2;
import haxe.ds.Option;
import funk.types.extensions.Anys;
import funk.types.extensions.Options;

using funk.types.extensions.Options;

class Eithers {

	public static function isLeft<T1, T2>(either : Either<T1, T2>) : Bool {
		return switch(either) {
			case Left(_): true;
			case Right(_): false;
		}
	}

	public static function isRight<T1, T2>(either : Either<T1, T2>) : Bool {
		return !isLeft(either);
	}

	public static function left<T1, T2>(either : Either<T1, T2>) : Option<T1> {
		return switch(either) {
			case Left(value): value.toOption();
			case Right(_): None;
		}
	}

	public static function right<T1, T2>(either : Either<T1, T2>) : Option<T2> {
		return switch(either) {
			case Left(_): None;
			case Right(value): value.toOption();
		}
	}

	public static function swap<T1, T2>(either : Either<T1, T2>) : Either<T2, T1> {
		return switch(either) {
			case Left(value): Right(value);
			case Right(value): Left(value);
		}
	}

	public static function flatten<T1, T2>(either : Either<Either<T1, T2>, Either<T1, T2>>) : Either<T1, T2> {
		return switch(either) {
			case Left(value): value;
			case Right(value): value;
		}
	}

	public static function flattenLeft<T1, T2>(either : Either<Either<T1, T2>, T2>) : Either<T1, T2> {
		return switch(either) {
			case Left(value): value;
			case Right(_): Funk.error(IllegalOperationError());
		}
	}

	public static function flattenRight<T1, T2>(either : Either<T1, Either<T1, T2>>) : Either<T1, T2> {
		return switch(either) {
			case Left(_): Funk.error(IllegalOperationError());
			case Right(value): value;
		}
	}

	public static function fold<T1, T2, T3>(	either : Either<T1, T2>,
												funcLeft : Function1<T1, T3>,
												funcRight : Function1<T2, T3>
												) : T3 {
		return switch(either) {
			case Left(value): funcLeft(value);
			case Right(value): funcRight(value);
		}
	}

	public static function foldLeft<T1, T2, T3>(either : Either<T1, T2>, func : Function1<T1, T3>) : T3 {
		return switch(either) {
			case Left(value): func(value);
			case Right(_): Funk.error(IllegalOperationError());
		}
	}

	public static function foldRight<T1, T2, T3>(either : Either<T1, T2>, func : Function1<T2, T3>) : T3 {
		return switch(either) {
			case Left(_): Funk.error(IllegalOperationError());
			case Right(value): func(value);
		}
	}

	public static function map<T1, T2, T3, T4>(	either : Either<T1, T2>,
												funcLeft : Function1<T1, T3>,
												funcRight : Function1<T2, T4>
												) : Either<T3, T4> {
		return switch(either) {
			case Left(value): Left(funcLeft(value));
			case Right(value): Right(funcRight(value));
		}
	}

	public static function mapLeft<T1, T2, T3>(either : Either<T1, T2>, func : Function1<T1, T3>) : Either<T3, T2> {
		return switch(either) {
			case Left(value): Left(func(value));
			case Right(_): Funk.error(IllegalOperationError());
		}
	}

	public static function mapRight<T1, T2, T3>(either : Either<T1, T2>, func : Function1<T2, T3>) : Either<T1, T3> {
		return switch(either) {
			case Left(_): Funk.error(IllegalOperationError());
			case Right(value): Right(func(value));
		}
	}

	public static function equals<T1, T2>(	a : Either<T1, T2>,
											b : Either<T1, T2>,
											?funcLeft : Predicate2<T1, T1>,
											?funcRight : Predicate2<T2, T2>
											) : Bool {
		return switch (a) {
			case Left(left0):
				switch (b) {
					case Left(left1):
						Anys.equals(left0, left1, funcLeft);
					case Right(_): false;
				}
			case Right(right0):
				switch (b) {
					case Left(_): false;
					case Right(right1):
						Anys.equals(right0, right1, funcRight);
				}
		}
	}

	public static function toAttempt<T1, T2>(either : Either<T1, T2>) : Attempt<T2> {
		return switch(either) {
			case Left(_): Failure(Error("Attempt failure"));
			case Right(value): Success(value);
		}
	}

	public static function toBool<T1, T2>(either : Either<T1, T2>) : Bool {
		return switch(either) {
			case Left(_): false;
			case Right(_): true;
		}
	}

	public static function toOption<T1, T2>(either : Either<T1, T2>) : Option<T2> {
		return switch(either) {
			case Left(_): None;
			case Right(value): Some(value);
		}
	}

	public static function toString<T1, T2>(	either : Either<T1, T2>,
												?funcLeft : Function1<T1, String>,
												?funcRight : Function1<T2, String>) : String {
		return switch (either) {
			case Left(value): 'Left(${Anys.toString(value, funcLeft)})';
			case Right(value): 'Right(${Anys.toString(value, funcRight)})';
		}
	}

	public static function toEither<T, T>(any : Null<T>) : Either<T, T> {
		return any != null ? Right(any) : Left(any);
	}
}
