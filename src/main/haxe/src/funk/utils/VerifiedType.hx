package funk.utils;

import funk.errors.TypeError;

class VerifiedType {
	
	public static function verifyClass<T>(value : T, type : Class<T>) : T {
		if(Std.is(value, type)) {
			return value;
		}
		
		throw new TypeError("Expected: "+Type.getClassName(type) + 
								", Actual: "+Type.getClassName(Type.getClass(value)));
	}
	
	public static function verifyEnum<T>(value : T, type : Enum<T>) : T {
		if(Std.is(value, type)) {
			return value;
		}
		
		throw new TypeError("Expected: "+Type.getEnumName(type) + 
								", Actual: "+Type.getClassName(Type.getClass(value)));
	}
}
