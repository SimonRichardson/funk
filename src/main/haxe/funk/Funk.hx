package funk;

class Funk {

	public static function main() : Void {
	}
}

typedef Function0<R> = Void -> R;
typedef Function1<T1, R> = T1 -> R;
typedef Function2<T1, T2, R> = T1 -> P2 -> R;
typedef Function3<T1, T2, T3, R> = T1 -> T2 -> T3 -> R;
typedef Function4<T1, T2, T3, T4, R> = T1 -> T2 -> T3 -> T4 -> R;
typedef Function5<T1, T2, T3, T4, T5, R> = T1 -> T2 -> T3 -> T4 -> T5 -> R;
