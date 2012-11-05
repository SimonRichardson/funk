package funk.reactive;

class Behaviours {

	public static function constant<T>(value: T): Behaviour<T> {
        return Streams.identity().startsWith(value);
    }
}