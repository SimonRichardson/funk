package funk.types.extensions;

import funk.Funk;
import funk.types.extensions.Anys;
import funk.types.Tuple3;
import funk.types.Predicate2;

class Tuples3 {

	public static function _1<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T1 {
		return switch(tuple) {
			case tuple3(value, _, _): value;
		}
	}

	public static function _2<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T2 {
		return switch(tuple) {
			case tuple3(_, value, _): value;
		}
	}

	public static function _3<T1, T2, T3>(tuple : Tuple3<T1, T2, T3>) : T3 {
		return switch(tuple) {
			case tuple3(_, _, value): value;
		}
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

	public static function toString<T1, T2, T3>(	tuple : Tuple3<T1, T2, T3>,
													?func0 : Function1<T1, String>,
													?func1 : Function1<T2, String>,
													?func2 : Function1<T3, String>
													) : String {
		return switch (tuple) {
			case tuple3(t1, t2, t3):
				Std.format('(${Anys.toString(t1, func0)}, ${Anys.toString(t2, func1)}, ${Anys.toString(t3, func2)})');
		}
	}
}
