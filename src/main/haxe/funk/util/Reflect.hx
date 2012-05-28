package funk.util;
import haxe.PosInfos;

class Reflect {
	
	public static function here(?info:PosInfos) : PosInfos {
		return info;
	}
	
	public static function is(a : Dynamic, b : Dynamic) : Bool {
		return switch(Type.typeof(a)) {
			case TEnum(x):
				switch(Type.typeof(b)) {
					case TObject:
						Type.getEnumName(Type.getEnum(a)) == Type.getEnumName(b);
					default:
						Type.enumEq(a, b);
				}
			default:
				Std.is(a, b);
		}
	}
}
