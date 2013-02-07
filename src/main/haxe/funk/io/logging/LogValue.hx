package funk.io.logging;

enum LogValue<T> {
	Data(data : T);
	DataWithValue(data : T, value : String);
}
