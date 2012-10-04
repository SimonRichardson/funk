package funk.errors;

import haxe.PosInfos;

class FunkError {

	public var message(default, null) : String;

	public var info(default, null) : PosInfos;

	public var type(default, null) : String;

	public function new(?message : String, ?info:PosInfos){
		this.message = message;
		this.info = info;
		this.type = if(null != info) info.className else "Unknown";
	}

	public function toString():String {
		var str:String = type + ": " + message;
		if (info != null) {
			str += " at " + info.className + "#" + info.methodName + " (" + info.lineNumber + ")";
		}
		return str;
	}
}
