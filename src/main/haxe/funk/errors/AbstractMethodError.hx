package funk.errors;

import haxe.PosInfos;

class AbstractMethodError extends AbstractError {
	
	public function new(?message : String, ?info:PosInfos){
		super(message, info);
	}
}
