package funk.logging;

enum LogValue<T> {
	Data(data : T);
	DataWithValue(data : T, value : String);
}
