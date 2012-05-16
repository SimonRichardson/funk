package funk;

import funk.product.Product;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.option.Option;

using funk.option.Option;

interface ILazy<T> implements IProduct {
	var get(dynamic, never) : T;
}

enum Lazy<T, A, B> {
	lazy(func : Void -> T);
	lazy1(func : A -> T, arg0 : A);
	lazy2(func : A -> B -> T, arg0 : A, arg1 : B);
	lazyN(func : Array<Dynamic> -> T, args : Array<Dynamic>);
}

class LazyType {
	
	// TODO (Simon) There has to be a better way to do this?
	private static var _instances = new Array<Dynamic>();
	
	public static function get<T, A, B>(lax : Lazy<T, A, B>) : T {
		for(i in 0..._instances.length) {
			var accessDef : LazyTypeDef<T, A, B> = _instances[i];
			if(Type.enumEq(accessDef._lazy, lax)) {
				var impl : LazyImpl<T, A, B> = _instances[i];
				return impl.get;
			}
		}
		
		var value = switch(lax) {
			case lazy(func): Some(new LazyImpl<T, A, B>(lax));
			case lazy1(func, arg0): Some(new LazyImpl<T, A, B>(lax));
			case lazy2(func, arg0, arg1): Some(new LazyImpl<T, A, B>(lax));
			case lazyN(func, args): Some(new LazyImpl<T, A, B>(lax));
			default: None;
		}
		
		switch(value) {
			case Some(impl): _instances.push(impl);
			case None: throw new NoSuchElementError();
		}
		
		return value.get().get;
	}
	
	public static function forget<T, A, B>(lax : Lazy<T, A, B>) : Void {
		for(i in 0..._instances.length) {
			var def : LazyTypeDef<T, A, B> = _instances[i];
			if(Type.enumEq(def._lazy, lax)) {
				_instances.splice(i, 1);
				return;
			}
		}
	}
}

private typedef LazyTypeDef<T, A, B> = {
	var _lazy : Lazy<T, A, B>;
};

class LazyImpl<T, A, B> extends Product, implements ILazy<T> {
	
	private var _lazy : Lazy<T, A, B>;
	private var _value : T;
	private var _evaluated : Bool;
	
	public var get(get_get, never) : T;
	
	public function new(lax : Lazy<T, A, B>) {
		super();
		
		_lazy = lax;
		_evaluated = false;
	}
	
	override public function productElement(index : Int) : Dynamic {
		if(index == 0) {
			return get;
		}
		
		throw new RangeError(Std.format("Index $index is out of bounds."));
	}
	
	private function get_get() : T {
		if(!_evaluated) {
			_value = switch(_lazy) {
				case lazy(func): func();
				case lazy1(func, arg0): func(arg0);
				case lazy2(func, arg0, arg1): func(arg0, arg1);
				case lazyN(func, args): func(args);
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
