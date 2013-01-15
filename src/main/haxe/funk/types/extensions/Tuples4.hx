package funk.types.extensions;

import funk.Funk;
import funk.types.extensions.Anys;
import funk.types.Tuple4;
import funk.types.Predicate2;

class Tuples4 {

	public static function _1<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T1 {
		return Type.enumParameters(tuple)[0];
	}

	public static function _2<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T2 {
		return Type.enumParameters(tuple)[1];
	}

	public static function _3<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T3 {
		return Type.enumParameters(tuple)[2];
	}

	public static function _4<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : T4 {
		return Type.enumParameters(tuple)[3];
	}

	public static function equals<T1, T2, T3, T4>(	a : Tuple4<T1, T2, T3, T4>,
													b : Tuple4<T1, T2, T3, T4>,
													?func1 : Predicate2<T1, T1>,
													?func2 : Predicate2<T2, T2>,
													?func3 : Predicate2<T3, T3>,
													?func4 : Predicate2<T4, T4>
													) : Bool {
		return switch (a) {
			case tuple4(t1_0, t2_0, t3_0, t4_0):
				switch (b) {
					case tuple4(t1_1, t2_1, t3_1, t4_1):
						Anys.equals(t1_0, t1_1, func1) && Anys.equals(t2_0, t2_1, func2) &&
							Anys.equals(t3_0, t3_1, func3) && Anys.equals(t4_0, t4_1, func4);
				}
		}
	}

	public static function toArray<T1, T2, T3, T4>(tuple : Tuple4<T1, T2, T3, T4>) : Array<Dynamic> {
		return Type.enumParameters(tuple);
	}

	public static function toString<T1, T2, T3, T4>(	tuple : Tuple4<T1, T2, T3, T4>,
														?func0 : Function1<T1, String>,
														?func1 : Function1<T2, String>,
														?func2 : Function1<T3, String>,
														?func3 : Function1<T4, String>
														) : String {
		return switch (tuple) {
			case tuple4(t1, t2, t3, t4):
				Std.format('(${Anys.toString(t1, func0)}, ${Anys.toString(t2, func1)}, ${Anys.toString(t3, func2)}, ${Anys.toString(t4, func3)})');
		}
	}
}
