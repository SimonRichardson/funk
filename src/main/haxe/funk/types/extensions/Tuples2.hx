package funk.types.extensions;

import funk.Funk;
import funk.types.extensions.Anys;
import funk.types.Function1;
import funk.types.Predicate2;
import funk.types.Tuple2;

class Tuples2 {

	public static function _1<T1, T2>(tuple : Tuple2<T1, T2>) : T1 {
		return Type.enumParameters(tuple)[0];
	}

	public static function _2<T1, T2>(tuple : Tuple2<T1, T2>) : T2 {
		return Type.enumParameters(tuple)[1];
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
						Anys.equals(t1_0, t1_1, func1) && Anys.equals(t2_0, t2_1, func2);
				}
		}
	}

	public static function toArray<T1, T2>(tuple : Tuple2<T1, T2>) : Array<Dynamic> {
		return Type.enumParameters(tuple);
	}

	public static function toString<T1, T2>(	tuple : Tuple2<T1, T2>,
												?func0 : Function1<T1, String>,
												?func1 : Function1<T2, String>
												) : String {
		return switch (tuple) {
			case tuple2(t1, t2): Std.format('(${Anys.toString(t1, func0)}, ${Anys.toString(t2, func1)})');
		}
	}
}
