package funk.errors;

import haxe.PosInfos;

class TypeError extends FunkError {
	
	public function new(message : String, ?info:PosInfos){
		super(message, info);
	}
}
