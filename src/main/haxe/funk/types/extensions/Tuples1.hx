package funk.types.extensions;

import funk.Funk;
import funk.types.extensions.Anys;
import funk.types.Tuple1;
import funk.types.Predicate2;

class Tuples1 {

	public static function _1<T1>(tuple : Tuple1<T1>) : T1 {
		return Type.enumParameters(tuple)[0];
	}

	public static function equals<T1>(a : Tuple1<T1>, b : Tuple1<T1>, ?func : Predicate2<T1, T1>) : Bool {
		return switch (a) {
			case tuple1(t1_0):
				switch (b) {
					case tuple1(t1_1):
						Anys.equals(t1_0, t1_1, func);
				}
		}
	}

	public static function toString<T1>(tuple : Tuple1<T1>, ?func0 : Function1<T1, String>) : String {
		return switch (tuple) {
			case tuple1(t1): Std.format('(${Anys.toString(t1, func0)})');
		}
	}
}
