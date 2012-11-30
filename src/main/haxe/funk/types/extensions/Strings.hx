package funk.types.extensions;

import funk.Funk;

class Strings {

	public static function iterator(value : String) : Iterator<String> {
		var index = 0;
		return {
			hasNext: function() {
				return index < value.length;
			},
			next: function() {
				return if (index < value.length) {
					value.substr(index++, 1);
				} else {
					Funk.error(Errors.NoSuchElementError);
				}
			}
		};
	}
}