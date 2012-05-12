package funk.util;

enum Require {
	require(message : String);
}

class RequireType {
	
	inline public static function toBe(req : Require, condition : Bool) : Void {
		switch(req) {
			case require(message): 
				if(!condition) {
					throw new ArgumentError(message);
				}
		}
	}
}
