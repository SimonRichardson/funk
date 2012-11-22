package funk.types.extensions;

import funk.Funk;
import funk.types.Tuple2;
import funk.types.Predicate2;

class Tuples2 {

	public static function _1<T1, T2>(tuple : Tuple2<T1, T2>) : T1 {
		return switch(tuple) {
			case tuple2(value, _): value;
		}
	}

	public static function _2<T1, T2>(tuple : Tuple2<T1, T2>) : T2 {
		return switch(tuple) {
			case tuple2(_, value): value;
		}
	}

	public static function swap<T1, T2>(tuple : Tuple2<T1, T2>) : Tuple2<T2, T1> {
		return switch (tuple) {
			case tuple2(a, b): tuple2(b, a);
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
					case tuple2(t1_1, t2_1):
						// Create the function when needed.
						var eq1 : Predicate2<T1, T1> = function(a, b) : Bool {
							return null != func1 ? func1(a, b) : a == b;
						};
						var eq2 : Predicate2<T2, T2> = function(a, b) : Bool {
							return null != func2 ? func2(a, b) : a == b;
						};

						eq1(t1_0, t1_1) && eq2(t2_0, t2_1);
				}
		}
	}

	public static function toString<T1, T2>(tuple : Tuple2<T1, T2>) : String {
		return switch (tuple) {
			case tuple2(t1, t2): Std.format('($t1, $t2)');
		}
	}
}
