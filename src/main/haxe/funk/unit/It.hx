package funk.unit;

import funk.FunkObject;

enum It {
	it(x : Dynamic);
}

class ItType {
	
	public static function toEqual(x : It, b : Dynamic) : Bool {
		return switch(x) {
			case it(a):
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
	
	public static function toNotEqual(it : It, b : Dynamic) : Bool {
		return !ItType.toEqual(it, b);
	}
}
