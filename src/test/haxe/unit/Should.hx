package unit;

import funk.unit.Expect;
import massive.munit.Assert;

enum Should {
	should(str : String);
}

class ShouldUtil {
	
	public static function expect(s : Should, d : Dynamic) : Expect {
		return switch(s) {
			case should(str) : funk.unit.Expect.expect(d);
		}
	}
	
	public static function fail(s : Should) : Void {
		switch(s) {
			case should(str): Assert.fail(str);
		}
	}
}
