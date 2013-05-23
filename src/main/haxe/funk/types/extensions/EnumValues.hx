package funk.types.extensions;

class EnumValues {

    inline public static function equals<T : EnumValue>(a : T, b : T) : Bool return Type.enumEq(a, b);

    inline public static function getEnum<T>(e : EnumValue) : Enum<T> return cast Type.getEnum(e);

    inline public static function getEnumName(e : EnumValue) : String return Type.enumConstructor(e);

    inline public static function getValues(e : EnumValue) : Array<Dynamic> return Type.enumParameters(e);

    inline public static function getValueByIndex(e : EnumValue, index : Int) : Dynamic {
        return Type.enumParameters(e)[index];
    }

    inline public static function getIndex(e : EnumValue) : Int return Type.enumIndex(e);
}
