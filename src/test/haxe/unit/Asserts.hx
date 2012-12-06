package unit;

import haxe.PosInfos;
import massive.munit.Assert;

class Asserts {

	public static function areIterablesEqual<T>(a : Iterable<T>, b : Iterable<T>, ?info : PosInfos) : Void {
		areIteratorsEqual(a.iterator(), b.iterator(), info);
	}

	public static function areIteratorsEqual<T>(a : Iterator<T>, b : Iterator<T>, ?info : PosInfos) : Void {
		Assert.assertionCount++;

		var result = true;
		while(a.hasNext()) {
			if(!b.hasNext()) {
				result = false;
				break;
			}

			var value0 = a.next();
			var value1 = b.next();

			switch (Type.typeof(value0)) {
				case TEnum(e): 
					if (!Type.enumEq(value0, value1)) {
						result = false;
					}
				default: 
					if (value0 != value1) {
						result = false;
					}
			}

			if (!result) {
				break;
			}
		}

		if (!result) {
			Assert.fail("Value [" + a + "] was not equal to expected value [" + b + "]", info);
		}
	}
}