package funk.reactive;

class Pulse<T> {

	public var time(get_time, never) : Int;
	public var value(get_value, never) : T;

	private var _time : Int;
	private var _value : T;

	public function new(time : Int, value : T){
		_time = time;
		_value = value;
	}

	public function map<E>(func : T -> E) : Pulse<E> {
		return withValue(func(value));
	}

	public function withValue<E>(value : E) : Pulse<E> {
		return new Pulse<E>(time, value);
	}

	private function get_time() : Int {
		return _time;
	}

	private function get_value() : T {
		return _value;
	}
}
