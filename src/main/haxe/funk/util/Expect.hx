package funk.util;

import funk.IFunkObject;

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
					#if js 
					if(Reflect.isFunction(a) && Reflect.isFunction(b)) {
						if(Reflect.field(a, 'scope') == Reflect.field(b, 'scope') && 
							Reflect.field(a, 'method') == Reflect.field(b, 'method')) {
							true;
						} else {
							a == b;
						}
					} else {
						a == b;
					}
					#else
					a == b;
					#end
				}
		}
	}
	
	public static function toNotEqual(x : Expect, b : Dynamic) : Bool {
		return !ExpectType.toEqual(x, b);
	}
}
