package funk.types.extensions;

import funk.Funk;
import funk.types.extensions.Anys;
import funk.types.Option;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Predicate2;

class Options {

	public static function get<T>(option : Option<T>) : T {
		return switch (option) {
			case Some(value): value;
			case None: Funk.error(Errors.NoSuchElementError);
		}
	}

	public static function orElse<T>(option : Option<T>, func : Function0<Option<T>>) : Option<T> {
		return switch (option) {
			case Some(value): option;
			case None: func();
		}
	}

	public static function getOrElse<T>(option : Option<T>, func : Function0<T>) : T {
		return switch (option) {
			case Some(value): value;
			case None: func();
		}
	}

	public static function isDefined<T>(option : Option<T>) : Bool {
		return switch (option) {
			case Some(_): true;
			case None: false;
		}
	}

	public static function isEmpty<T>(option : Option<T>) : Bool {
		return !isDefined(option);
	}

	public static function filter<T>(option : Option<T>, func : Function1<T, Bool>) : Option<T> {
		return switch (option) {
			case Some(value): func(get(option)) ? Some(value) : None;
			case None: None;
		}
	}

	public static function each<T>(option : Option<T>, func : Function1<T, Void>) : Void {
		switch (option) {
			case Some(value): func(get(option));
			case None:
		}
	}

	public static function flatten<T>(option : Option<Option<T>>) : Option<T> {
		return switch (option) {
			case Some(value): value;
			case None: None;
		}
	}

	public static function map<T1, T2>(option : Option<T1>, func : Function1<T1, T2>) : Option<T2> {
		return switch (option) {
			case Some(value): Some(func(get(option)));
			case None: None;
		}
	}

	public static function flatMap<T1, T2>(option : Option<T1>, func : Function1<T1, Option<T2>>) : Option<T2> {
		return switch (option) {
			case Some(value): func(get(option));
			case None: None;
		}
	}

	public static function equals<T>(a : Option<T>, b : Option<T>, ?func : Predicate2<T, T>) : Bool {
		return switch (a) {
			case Some(value0):
				switch(b) {
					case Some(value1):
						// Create the function when needed.
						var eq : Predicate2<T, T> = function(a, b) : Bool {
							return null != func ? func(a, b) : a == b;
						};

						eq(value0, value1);
					case None: false;
				}
			case None:
				switch(b) {
					case Some(_): false;
					case None: true;
				}
		}
	}

	public static function toLeft<T1, T2>(option : Option<T1>, ?func : Function0<T2>) : Either<T1, T2> {
		return switch (option) {
			case Some(value): Left(value);
			case None:
				if (null == func) {
					Funk.error(Errors.ArgumentError());
				}
				Right(func());
		}
	}

	public static function toRight<T1, T2>(option : Option<T1>, ?func : Function0<T2>) : Either<T2, T1> {
		return switch (option) {
			case Some(value): Right(value);
			case None:
				if (null == func) {
					Funk.error(Errors.ArgumentError());
				}
				Left(func());
		}
	}

	public static function toEither<T1, T2>(option : Option<T1>, func : Function0<T2>) : Either<T2, T1> {
		return switch (option) {
			case Some(value): Right(value);
			case None: Left(func());
		}
	}

	public static function toString<T>(option : Option<T>, ?func : Function1<T, String>) : String {
		return switch (option) {
			case Some(value):
				Std.format('Some(${Anys.toString(value, func)})');
			case None: 'None';
		}
	}

	public static function pure<T>(any : T) : Option<T> {
		return Some(any);
	}

	public static function toOption<T>(any : Null<T>) : Option<T> {
		return any != null ? Some(any) : None;
	}
}
