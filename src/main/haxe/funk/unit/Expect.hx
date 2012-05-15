package funk.unit;

import funk.FunkObject;

enum Expect {
	expect(x : Dynamic);
}

class ExpectType {
	
	public static function toEqual(x : Expect, b : Dynamic) : Bool {
		return switch(x) {
			case expect(a):
				var aIsFunk : Bool = Std.is(a, IFunkObject);
				var bIsFunk : Bool = Std.is(b, IFunkObject);
				
				if(aIsFunk && bIsFunk) {
					var aFunk : IFunkObject = cast a;
					var bFunk : IFunkObject = cast b;
					
					aFunk.equals(bFunk);
				} else {
					
					a == b;
				}
		}
	}
	
	public static function toNotEqual(x : Expect, b : Dynamic) : Bool {
		return !ExpectType.toEqual(x, b);
	}
}
