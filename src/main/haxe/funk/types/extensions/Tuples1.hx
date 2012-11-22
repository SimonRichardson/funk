package funk.types.extensions;

import funk.Funk;
import funk.types.Tuple1;
import funk.types.Predicate2;

class Tuples1 {

	public static function _1<T1>(tuple : Tuple1<T1>) : T1 {
		return switch(tuple) {
			case tuple1(value): value;
		}
	}

	public static function equals<T1>(a : Tuple1<T1>, b : Tuple1<T1>, ?func : Predicate2<T1, T1>) : Bool {
		return switch (a) {
			case tuple1(t1_0):
				switch (b) {
					case tuple1(t1_1):
						// Create the function when needed.
						var eq : Predicate2<T, T> = function(a, b) : Bool {
							return null == func ? func(a, b) : a == b;
						};

						eq(t1_0, t1_1);
				} 
		}
	}

	public static function toString<T1>(tuple : Tuple1<T1>) : String {
		return switch (tuple) {
			case tuple1(t1): Std.format('($t1)');
		}
	}
}