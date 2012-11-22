package funk.types;

enum Either<T1, T2> {
	Left(value : T1);
	Right(value : T2);
}