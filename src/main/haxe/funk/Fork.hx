package funk;

interface IFork<T> {
	function andThen(branch : Void -> Void, ?args : Array<Dynamic>) : Void -> Void;
	function andContinue(branch : Void -> Void) : T -> Void;
}

enum Fork<T> {
	fork(func : (Void -> Void) -> Void);
	forkN(func : (Void -> Void) -> Array<Dynamic> -> Void, ?args : Array<Dynamic>);
}

class ForkType {
	
	public static function andThen<T>(branch : Fork<T>, func : Void -> Void, ?args : Array<Dynamic>) : Void -> Void {
		return new ForkImpl<T>(branch).andThen(func, args);
	}
	
	public static function andContinue<T>(branch : Fork<T>, func : Void -> Void) : T -> Void {
		return new ForkImpl<T>(branch).andContinue(func);
	}
	
	public static function call<T, E>(branch : Fork<T>) : E {
		return switch(branch) {
			case fork(func): Reflect.callMethod(null, func, [null]);
			case forkN(func, args): Reflect.callMethod(null, func, [null, args]);
		}
	}
}

class ForkImpl<T> implements IFork<T> {
	
	private var _fork : Fork<T>;
	
	public function new(branch : Fork<T>) {
		_fork = branch;
	}
	
	public function andThen(f : Void -> Void, ?args : Array<Dynamic>) : Void -> Void {
		var inner = function() : Void {
			Reflect.callMethod(null, f, args != null ? args : []);
		};
		
		return function() : Void {
			switch(_fork) {
				case fork(func): Reflect.callMethod(null, func, [inner]); 
				case forkN(func, args): Reflect.callMethod(null, func, args == null ? [inner] : [inner, args]); 
			}
		};
	}
	
	public function andContinue(f : Void -> Void) : T -> Void {
		var inner = function(args : Array<Dynamic>) : Void {
			Reflect.callMethod(null, f, args != null ? args : []);
		};
		
		return function(args : T) : Void {
			switch(_fork) {
				case fork(func): Reflect.callMethod(null, func, [inner]);
				case forkN(func, args): Reflect.callMethod(null, func, args == null ? [inner] : [inner, args]);
			}
		};
	}
}