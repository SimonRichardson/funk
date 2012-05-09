package funk;

interface IFork<T> {
	function andThen(func : Fork<T>) : Void -> Void;
	function andContinue(func : Fork<T>) : T -> Void;
}

enum Fork<T> {
	fork(func : Void -> T);
}

class ForkType {
	
}

class ForkImpl<T> implements IFork<T> {
	
	private var _fork : Fork<T>;
	
	public function new(branch : Fork<T>) {
		_fork = branch;
	}
	
	public function andThen(func : Fork<T>) : Void -> Void {
		
	}
	
	public function andContinue(func : Fork<T>) : T -> Void {
		
	}
}