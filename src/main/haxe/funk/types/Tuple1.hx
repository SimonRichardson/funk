package funk.types;

import funk.types.extensions.Anys;

enum Tuple1Type<T1> {
	tuple1(t1 : T1);
}

abstract Tuple1<T1>(Tuple1Type<T1>) from Tuple1Type<T1> to Tuple1Type<T1> {

	inline function new(tuple : Tuple1Type<T1>) {
		this = tuple;
	}

	@:to
	inline public static function toString<T1>(tuple : Tuple1Type<T1>) : String {
		return Tuple1Types.toString(tuple);
	}
}

class Tuple1Types {

	public static function _1<T1>(tuple : Tuple1<T1>) : T1 {
		return Type.enumParameters(tuple)[0];
	}

	public static function equals<T1>(a : Tuple1<T1>, b : Tuple1<T1>, ?func : Predicate2<T1, T1>) : Bool {
		return switch (a) {
			case tuple1(t1_0):
				switch (b) {
					case tuple1(t1_1): Anys.equals(t1_0, t1_1, func);
					case _: false;
				}
			case _: false;
		}
	}

	public static function join<T1>(tuple : Tuple1<T1>) : String {
		return '${Anys.toString(_1(tuple))}';
	}


	public static function toArray<T1>(tuple : Tuple1<T1>) : Array<Dynamic> {
		return Type.enumParameters(tuple);
	}

	public static function toString<T1>(tuple : Tuple1<T1>, ?func0 : Function1<T1, String>) : String {
		return '(${Anys.toString(_1(tuple), func0)})';
	}
}

