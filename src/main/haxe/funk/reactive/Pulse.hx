package funk.reactive;

import funk.errors.RangeError;
import funk.product.Product2;

class Pulse<T> extends Product2<Float, T> {

	public var time(get_time, never) : Float;
	public var value(get_value, never) : T;

	private var _time : Float;
	private var _value : T;

	public function new(time : Float, value : T){
		super();

		_time = time;
		_value = value;
	}

	public function map<E>(func : T -> E) : Pulse<E> {
		return withValue(func(value));
	}

	public function withValue<E>(value : E) : Pulse<E> {
		return new Pulse<E>(time, value);
	}

	override public function productElement(index : Int) : Dynamic {
		if(index == 0) {
			return time;
		} else if(index == 1) {
			return value;
		}

		throw new RangeError();
	}

	private function get_time() : Float {
		return _time;
	}

	private function get_value() : T {
		return _value;
	}

	override private function get_productPrefix() : String {
		return "Pulse";
	}
}
