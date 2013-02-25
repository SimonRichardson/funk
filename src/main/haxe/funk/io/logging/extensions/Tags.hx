package funk.io.logging.extensions;

import funk.io.logging.Tag;

class Tags {

	public static function value(tag : Tag) : String {
		return Type.enumParameters(tag)[0];
	}

	public static function toString(tag : Tag) : String {
		return '[${value(tag)}]';
	}
}