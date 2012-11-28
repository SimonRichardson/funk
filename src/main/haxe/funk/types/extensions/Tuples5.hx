package funk.types.extensions;

import funk.Funk;
import funk.types.extensions.Anys;
import funk.types.Tuple5;
import funk.types.Predicate2;

class Tuples5 {

	public static function _1<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T1 {
		return switch(tuple) {
			case tuple5(value, _, _, _, _): value;
		}
	}

	public static function _2<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T2 {
		return switch(tuple) {
			case tuple5(_, value, _, _, _): value;
		}
	}

	public static function _3<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T3 {
		return switch(tuple) {
			case tuple5(_, _, value, _, _): value;
		}
	}

	public static function _4<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T4 {
		return switch(tuple) {
			case tuple5(_, _, _, value, _): value;
		}
	}

	public static function _5<T1, T2, T3, T4, T5>(tuple : Tuple5<T1, T2, T3, T4, T5>) : T5 {
		return switch(tuple) {
			case tuple5(_, _, _, _, value): value;
		}
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

	public static function toString<T1, T2, T3, T4, T5>(	tuple : Tuple5<T1, T2, T3, T4, T5>,
															?func0 : Function1<T1, String>,
															?func1 : Function1<T2, String>,
															?func2 : Function1<T3, String>,
															?func3 : Function1<T4, String>,
															?func4 : Function1<T5, String>
															) : String {
		return switch (tuple) {
			case tuple5(t1, t2, t3, t4, t5):
				Std.format('(${Anys.toString(t1, func0)}, ${Anys.toString(t2, func1)}, ${Anys.toString(t3, func2)}, ${Anys.toString(t4, func3)}, ${Anys.toString(t5, func4)})');
		}
	}
}
