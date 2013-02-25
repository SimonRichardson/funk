package funk.types.extensions;

import funk.Funk;
import funk.types.extensions.Anys;
import funk.types.Tuple5;
import funk.types.Predicate2;

class Tuples5 {

	public static function _1<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T1 {
		return Type.enumParameters(tuple)[0];
	}

	public static function _2<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T2 {
		return Type.enumParameters(tuple)[1];
	}

	public static function _3<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T3 {
		return Type.enumParameters(tuple)[2];
	}

	public static function _4<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T4 {
		return Type.enumParameters(tuple)[3];
	}

	public static function _5<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T5 {
		return Type.enumParameters(tuple)[4];
	}

	public static function equals<T1, T2, T3, T4, T5>(	a : Tuple5<T1, T2, T3, T4, T5>,
														b : Tuple5<T1, T2, T3, T4, T5>,
														?func1 : Predicate2<T1, T1>,
														?func2 : Predicate2<T2, T2>,
														?func3 : Predicate2<T3, T3>,
														?func4 : Predicate2<T4, T4>,
														?func5 : Predicate2<T5, T5>
														) : Bool {
		return switch (a) {
			case tuple5(t1_0, t2_0, t3_0, t4_0, t5_0):
				switch (b) {
					case tuple5(t1_1, t2_1, t3_1, t4_1, t5_1):
						Anys.equals(t1_0, t1_1, func1) && Anys.equals(t2_0, t2_1, func2) &&
							Anys.equals(t3_0, t3_1, func3) && Anys.equals(t4_0, t4_1, func4) &&
								Anys.equals(t5_0, t5_1, func5);
				}
		}
	}

	public static function join<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : String {
		return '${Anys.toString(_1(tuple))}${Anys.toString(_2(tuple))}${Anys.toString(_3(tuple))}${Anys.toString(_4(tuple))}${Anys.toString(_5(tuple))}';
	}


	public static function toArray<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : Array<Dynamic> {
		return Type.enumParameters(tuple);
	}

	public static function toString<T1, T2, T3, T4, T5>(	tuple : Tuple5<T1, T2, T3, T4, T5>,
															?func0 : Function1<T1, String>,
															?func1 : Function1<T2, String>,
															?func2 : Function1<T3, String>,
															?func3 : Function1<T4, String>,
															?func4 : Function1<T5, String>
															) : String {
		return '(${Anys.toString(_1(tuple), func0)}, ${Anys.toString(_2(tuple), func1)}, ${Anys.toString(_3(tuple), func2)}, ${Anys.toString(_4(tuple), func3)}, ${Anys.toString(_5(tuple), func4)})';
	}
}
