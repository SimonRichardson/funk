package funk.util;

import funk.errors.ArgumentError;

enum Require {
	require(message : String);
}

class RequireType {
	
	inline public static function toBe(req : Require, condition : Bool) : Void {
		if(!condition) {
			switch(req) {
				case require(message): throw new ArgumentError(message);
			}
		}
	}
}
