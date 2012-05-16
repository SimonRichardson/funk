package funk.ioc.errors;

import funk.ioc.errors.IOCError;
import haxe.PosInfos;

class BindingError extends IOCError {
	
	public function new(?message : String, ?info:PosInfos){
		super(message, info);
	}
}
