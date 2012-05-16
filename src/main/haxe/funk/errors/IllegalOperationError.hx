package funk.errors;

import haxe.PosInfos;

class IllegalOperationError extends FunkError {
	
	public function new(?message : String, ?info:PosInfos){
		super(message, info);
	}
}
