package unit;

import funk.unit.Expect;

enum Should {
	should(str : String);
}

class ShouldUtil {
	
	public static function expect(s : Should, d : Dynamic) : Expect {
		return switch(s) {
			case should(str) : funk.unit.Expect.expect(d);
		}
	}
}
