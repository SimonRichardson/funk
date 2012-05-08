package funk;

import funk.Product;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.option.Option;

using funk.option.Option;

interface ILazy<T> implements IProduct<T> {
	
	var get(dynamic, never) : T;
}

enum Lazy<T, A, B, C> {
	lazy0(func : Void -> T);
	lazy1(func : A -> T, arg0 : A);
	lazy2(func : A -> B -> T, arg0 : A, arg1 : B);
	lazy3(func : A -> B -> C -> T, arg0 : A, arg1 : B, arg2 : C);
}

class LazyType {
	
	private static var _instances:Array<Dynamic> = new Array<Dynamic>();
	
	public static function get<T, A, B, C>(lazy : Lazy<T, A, B, C>) : T {
		for(i in 0..._instances.length) {
			var accessDef : LazyTypeDef<T, A, B, C> = _instances[i];
			if(Type.enumEq(accessDef._lazy, lazy)) {
				var impl : LazyImpl<T, A, B, C> = _instances[i];
				return impl.get;
			}
		}
		
		var value = switch(lazy) {
			case lazy0(func): Some(new LazyImpl<T, A, B, C>(lazy));
			case lazy1(func, arg0): Some(new LazyImpl<T, A, B, C>(lazy));
			case lazy2(func, arg0, arg1): Some(new LazyImpl<T, A, B, C>(lazy));
			case lazy3(func, arg0, arg1, arg2): Some(new LazyImpl<T, A, B, C>(lazy));
			default: None;
		}
		
		switch(value) {
			case Some(impl): _instances.push(impl);
			case None: throw new NoSuchElementError();
		}
		
		return value.get().get;
	}
	
	public static function forget<T, A, B, C>(lazy : Lazy<T, A, B, C>) : Void {
		for(i in 0..._instances.length) {
			var def : LazyTypeDef<T, A, B, C> = _instances[i];
			if(Type.enumEq(def._lazy, lazy)) {
				_instances.splice(i, 1);
				return;
			}
		}
	}
}

private typedef LazyTypeDef<T, A, B, C> = {
	var _lazy : Lazy<T, A, B, C>;
};

class LazyImpl<T, A, B, C> extends Product<T>, implements ILazy<T> {
	
	private var _lazy : Lazy<T, A, B, C>;
	private var _value : T;
	private var _evaluated : Bool;
	
	public var get(get_get, never) : T;
	
	public function new(lazy : Lazy<T, A, B, C>) {
		_lazy = lazy;
		_evaluated = false;
	}
	
	override public function productElement(index : Int) : T {
		if(index == 0) {
			return get;
		}
		
		throw new RangeError("Index " + index + " is out of bounds.");
	}
	
	private function get_get() : T {
		if(!_evaluated) {
			_value = switch(_lazy) {
				case lazy0(func): Reflect.callMethod(null, func, []);
				case lazy1(func, arg0): Reflect.callMethod(null, func, [arg0]);
				case lazy2(func, arg0, arg1): Reflect.callMethod(null, func, [arg0, arg1]);
				case lazy3(func, arg0, arg1, arg2): Reflect.callMethod(null, func, [arg0, arg1, arg2]);
			}
			_evaluated = true;
		}
		
		return _value;
	}
	
	override private function get_productArity() : Int {
		return 1;
	}
	
	override private function get_productPrefix() : String {
		return "Lazy";
	}
}
