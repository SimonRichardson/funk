package funk.types.extensions;

class Enums {

	public static function createByName<T>(e : Enum<T>, constructorName : String, ?params : Array<Dynamic>) : T {
		return Type.createEnum(e, constructorName, params);
	}

	public static function createByIndex<T>(e : Enum<T>, constructorIndex : Int, ?params : Array<Dynamic>) : T {
		return Type.createEnumIndex(e, constructorIndex, params);
	}

	public static function createAll<T>(e : Enum<T>) : Array<T> {
		return Type.allEnums(e);
	}

	public static function getConstructors<T>(e : Enum<T>) : Array<String> {
		return Type.getEnumConstructs(e);
	}
}
