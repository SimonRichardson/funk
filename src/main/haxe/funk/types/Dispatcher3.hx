package funk.types;

typedef Dispatcher3<T1, T2, T3, R> = {
	
	function dispatch(value0 : T1, value1 : T2, value2 : T3) : R;
}