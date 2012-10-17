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

	public function map<T2>(func : T -> T2) : Pulse<T2> {
		return withValue(func(value));
	}

	public function withValue<T2>(value : T2) : Pulse<T2> {
		return new Pulse<T2>(time, value);
	}

	private function get_time() : Int {
		return _time;
	}

	private function get_value() : T {
		return _value;
	}
}
