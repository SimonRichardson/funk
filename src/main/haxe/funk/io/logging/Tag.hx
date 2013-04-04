package funk.io.logging;

enum Tag {
    Tag(value : String);
}

class TagTypes {

    public static function value(tag : Tag) : String {
        return Type.enumParameters(tag)[0];
    }

    public static function toString(tag : Tag) : String {
        return '[${value(tag)}]';
    }
}
