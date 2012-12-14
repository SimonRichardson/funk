package funk.types;

import funk.Funk;
import funk.types.Either;

typedef Future<T> = {

	function then(func : Function1<T, Void>) : Future<T>;

	function but(func : Function1<Errors, Void>) : Future<T>;

	function when(func : Function1<Either<Errors, T>, Void>) : Future<T>;

	function progress(func : Function1<Float, Void>) : Future<T>;
}
