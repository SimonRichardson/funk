package funk.types.extensions;

import funk.Funk;
import funk.types.extensions.Anys;
import funk.types.Tuple3;
import funk.types.Predicate2;

class Tuples3 {

	public static function _1<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T1 {
		return Type.enumParameters(tuple)[0];
	}

	public static function _2<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T2 {
		return Type.enumParameters(tuple)[1];
	}

	public static function _3<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T3 {
		return Type.enumParameters(tuple)[2];
	}

	public static function equals<T1, T2, T3>(	a : Tuple3<T1, T2, T3>,
												b : Tuple3<T1, T2, T3>,
												?func1 : Predicate2<T1, T1>,
												?func2 : Predicate2<T2, T2>,
												?func3 : Predicate2<T3, T3>
												) : Bool {
		return switch (a) {
			case tuple3(t1_0, t2_0, t3_0):
				switch (b) {
					case tuple3(t1_1, t2_1, t3_1):
						Anys.equals(t1_0, t1_1, func1) && Anys.equals(t2_0, t2_1, func2) &&
							Anys.equals(t3_0, t3_1, func3);
				}
		}
	}

	public static function join<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : String {
		return '${Anys.toString(_1(tuple))}${Anys.toString(_2(tuple))}${Anys.toString(_3(tuple))}';
	}

	public static function toArray<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : Array<Dynamic> {
		return Type.enumParameters(tuple);
	}

	public static function toString<T1, T2, T3>(	tuple : Tuple3<T1, T2, T3>,
													?func0 : Function1<T1, String>,
													?func1 : Function1<T2, String>,
													?func2 : Function1<T3, String>
													) : String {
		return '(${Anys.toString(_1(tuple), func0)}, ${Anys.toString(_2(tuple), func1)}, ${Anys.toString(_3(tuple), func2)})';
	}
}
