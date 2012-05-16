package funk.ioc.errors;

import funk.errors.FunkError;
import haxe.PosInfos;

class IOCError extends FunkError {
	
	public function new(?message : String, ?info:PosInfos){
		super(message, info);
	}
}
