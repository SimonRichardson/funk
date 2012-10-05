package funk.tuple;

import funk.product.Product;
import funk.tuple.Tuple1;
import funk.tuple.Tuple2;
import funk.tuple.Tuple3;
import funk.tuple.Tuple4;
import funk.tuple.Tuple5;

interface ITuple implements IProduct {

}

class Tuples {

	inline public static function toTuple1<T1>(t1 : T1) : ITuple1<T1> {
		return new Tuple1Impl<T1>(t1);
	}

	inline public static function toTuple2<T1, T2>(t1 : T1, t2 : T2) : ITuple2<T1, T2> {
		return new Tuple2Impl<T1, T2>(t1, t2);
	}

	inline public static function toTuple3<T1, T2, T3>(t1 : T1, t2 : T2, t3 : T3)
																	: ITuple3<T1, T2, T3> {
		return new Tuple3Impl<T1, T2, T3>(t1, t2, t3);
	}

	inline public static function toTuple4<T1, T2, T3, T4>(t1 : T1, t2 : T2, t3 : T3, t4 : T4)
																	: ITuple4<T1, T2, T3, T4> {
		return new Tuple4Impl<T1, T2, T3, T4>(t1, t2, t3, t4);
	}

	inline public static function toTuple5<T1, T2, T3, T4, T5>(t1 : T1, t2 : T2, t3 : T3, t4 : T4,
														t5 : T5) : ITuple5<T1, T2, T3, T4, T5> {
		return new Tuple5Impl<T1, T2, T3, T4, T5>(t1, t2, t3, t4, t5);
	}
}
