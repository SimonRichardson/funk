package funk;

interface IFork<T> {
	function andThen(branch : Fork<T>) : Void -> Void;
	function andContinue(branch : Fork<T>) : T -> Void;
}

enum Fork<T> {
	fork(func : Void -> T);
}

class ForkType {
	
	public static function andThen<T>(branch : Fork<T>, func : Void -> Void) : Void -> Void {
		return null;
	}
}

class ForkImpl<T> implements IFork<T> {
	
	private var _fork : Fork<T>;
	
	public function new(branch : Fork<T>) {
		_fork = branch;
	}
	
	public function andThen(branch : Fork<T>) : Void -> Void {
		var inner = function() : Void {
			switch(branch) {
				case fork(func): Reflect.callMethod(null, func, []);
			}
		};
		
		return function() : Void {
			switch(_fork) {
				case fork(func): Reflect.callMethod(null, func, [inner]); 
			}
		};
	}
	
	public function andContinue(branch : Fork<T>) : T -> Void {
		var inner = function(args : Array<Dynamic>) : Void {
			switch(branch) {
				case fork(func): Reflect.callMethod(null, func, args);
			}
		};
		
		return function(args : T) : Void {
			switch(_fork) {
				case fork(func): Reflect.callMethod(null, func, [inner]); 
			}
		};
	}
}