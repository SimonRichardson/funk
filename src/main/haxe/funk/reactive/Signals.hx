package funk.reactive;

class Signals {

	public static function constant<T>(value: T): Signal<T> {
        return Streams.identity().startsWith(value);
    }
}