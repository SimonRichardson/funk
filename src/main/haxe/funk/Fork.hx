package funk;

interface IFork<T> {
	function andThen(branch : Void -> Void) : Void -> Void;
	function andContinue(branch : Void -> Void) : T -> Void;
}

enum Fork<T> {
	fork(func : (Void -> Void) -> Void);
}

class ForkType {
	
	public static function andThen<T>(branch : Fork<T>, func : Void -> Void) : Void -> Void {
		return new ForkImpl<T>(branch).andThen(func);
	}
	
	public static function andContinue<T>(branch : Fork<T>, func : Void -> Void) : Void -> Void {
		return new ForkImpl<T>(branch).andContinue(func);
	}
}

class ForkImpl<T> implements IFork<T> {
	
	private var _fork : Fork<T>;
	
	public function new(branch : Fork<T>) {
		_fork = branch;
	}
	
	public function andThen(f : Void -> Void) : Void -> Void {
		var inner = function() : Void {
			Reflect.callMethod(null, f, []);
		};
		
		return function() : Void {
			switch(_fork) {
				case fork(func): Reflect.callMethod(null, func, [inner]); 
			}
		};
	}
	
	public function andContinue(f : Void -> Void) : T -> Void {
		var inner = function(args : Array<Dynamic>) : Void {
			Reflect.callMethod(null, f, args);
		};
		
		return function(args : T) : Void {
			switch(_fork) {
				case fork(func): Reflect.callMethod(null, func, [inner]); 
			}
		};
	}
}