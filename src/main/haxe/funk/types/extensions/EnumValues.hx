package funk.types.extensions;

class EnumValues {

	public static function equals<T : EnumValue>(a : T, b : T) : Bool {
		return Type.enumEq(a, b);
	}
	
	public static function getName(e : EnumValue) {
		return Type.enumConstructor(e);
	}
	
	public static function getParameters(e : EnumValue) : Array<Dynamic> {
		return Type.enumParameters(e);
	}
	
	public static function getIndex(e : EnumValue) : Int {
		return Type.enumIndex(e);
	}
}
