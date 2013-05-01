package funk.io.logging;

import funk.types.extensions.EnumValues;

enum Tag {
    Tag(value : String);
}

class TagTypes {

    public static function value(tag : Tag) : String return EnumValues.getValueByIndex(tag, 0);

    public static function toString(tag : Tag) : String return '[${value(tag)}]';
}
