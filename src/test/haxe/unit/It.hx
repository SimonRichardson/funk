package unit;

enum It {
	it(x : String);
}

class ItUtil {
	
	public static function should(i : It, f : Void -> Void) : Void {
		// FIXME (Simon) : Find away to send this to munit.
		switch(i){
			case it(x): f();
		}
	}
}
