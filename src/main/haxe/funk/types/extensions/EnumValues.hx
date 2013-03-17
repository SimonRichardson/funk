package funk.types.extensions;

class EnumValues {

    public static function equals<T : EnumValue>(a : T, b : T) : Bool {
        return Type.enumEq(a, b);
    }

    public static function getEnum<T>(e : EnumValue) : Enum<T> {
        return cast Type.getEnum(e);
    }

    public static function getEnumName(e : EnumValue) : String {
        return Type.enumConstructor(e);
    }

    public static function getParameters(e : EnumValue) : Array<Dynamic> {
        return Type.enumParameters(e);
    }

    public static function getIndex(e : EnumValue) : Int {
        return Type.enumIndex(e);
    }
}
