package unit;

import massive.munit.Assert;
import funk.option.Option;
import funk.unit.Expect;

using funk.unit.Expect;

class ExpectUtil {
	
	public static function toBeFalsy(e : Expect) : Void {
		switch(e) {
			case expect(x): Assert.isFalse(x); 
		}
	}
	
	public static function toBeTruthy(e : Expect) : Void {
		switch(e) {
			case expect(x): Assert.isTrue(x);
		}
	}
	
	public static function toBeEqualTo(e : Expect, a : Dynamic) : Void {
		switch(e) {
			case expect(x):
				var xValue = switch(x) {
					case None: null;
					case Some(s): s;
					default: x;
				};
				var aValue = switch(a) {
					case None: null;
					case Some(s): s;
					default: a;
				};
				Assert.areEqual(xValue, aValue); 
		}
	}
	
	public static function toStrictlyEqual(e : Expect, a : Dynamic) : Void {
		switch(e) {
			case expect(x): Assert.areEqual(x, a); 
		}
	}
	
	public static function toBeNull(e : Expect) : Void {
		switch(e) {
			case expect(x): Assert.isNull(x);
		}
	}
	
	public static function toBeNotNull(e : Expect) : Void {
		switch(e) {
			case expect(x): Assert.isNotNull(x);
		}
	}
	
	public static function toBeOfType<T>(e : Expect, type : Class<T>) : Void {
		switch(e) {
			case expect(x): Assert.isTrue(Std.is(x, type));
		}
	}
}
