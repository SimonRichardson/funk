package funk.types;

import funk.types.Any;

enum Tuple2Type<T1, T2> {
	tuple2(t1 : T1, t2 : T2);
}

abstract Tuple2<T1, T2>(Tuple2Type<T1, T2>) from Tuple2Type<T1, T2> to Tuple2Type<T1, T2> {

	inline function new(tuple : Tuple2Type<T1, T2>) {
		this = tuple;
	}

	inline public function _1() : T1 {
		return Tuple2Types._1(this);
	}

	inline public function _2() : T2 {
		return Tuple2Types._2(this);
	}

	@:to
	inline public static function toString<T1, T2>(tuple : Tuple2Type<T1, T2>) : String {
		return Tuple2Types.toString(tuple);
	}
}

class Tuple2Types {

	public static function _1<T1, T2>(tuple : Tuple2<T1, T2>) : T1 {
		return Type.enumParameters(tuple)[0];
	}

	public static function _2<T1, T2>(tuple : Tuple2<T1, T2>) : T2 {
		return Type.enumParameters(tuple)[1];
	}

	public static function swap<T1, T2>(tuple : Tuple2<T1, T2>) : Tuple2<T2, T1> {
		return switch (tuple) {
			case tuple2(a, b): tuple2(b, a);
			case _: Funk.error(IllegalOperationError());
		}
	}

	public static function equals<T1, T2>(	a : Tuple2<T1, T2>,
											b : Tuple2<T1, T2>,
											?func1 : Predicate2<T1, T1>,
											?func2 : Predicate2<T2, T2>
											) : Bool {
		return switch (a) {
			case tuple2(t1_0, t2_0):
				switch (b) {
					case tuple2(t1_1, t2_1): AnyTypes.equals(t1_0, t1_1, func1) && AnyTypes.equals(t2_0, t2_1, func2);
					case _: false;
				}
			case _: false;
		}
	}

	public static function join<T1, T2>(tuple : Tuple2<T1, T2>) : String {
		return '${AnyTypes.toString(_1(tuple))}${AnyTypes.toString(_2(tuple))}';
	}

	public static function toArray<T1, T2>(tuple : Tuple2<T1, T2>) : Array<Dynamic> {
		return Type.enumParameters(tuple);
	}

	public static function toString<T1, T2>(	tuple : Tuple2<T1, T2>,
												?func0 : Function1<T1, String>,
												?func1 : Function1<T2, String>
												) : String {
		return '(${AnyTypes.toString(_1(tuple), func0)}, ${AnyTypes.toString(_2(tuple), func1)})';
	}
}

