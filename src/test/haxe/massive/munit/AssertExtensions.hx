package massive.munit;

import funk.IFunkObject;
import funk.collections.IList;
import funk.collections.IterableUtil;
import funk.reactive.StreamValues;

import massive.munit.Assert;

using funk.collections.IterableUtil;

class AssertExtensions {

	/**
	 * Assert that a value is of a specific enum type.
	 *
	 * @param	value				value expected to be of a given type
	 * @param	type				type the value should be
	 */
	public static function isEnum(value:EnumValue, type:Enum<Dynamic>):Void {
		Assert.assertionCount++;
		if (Type.getEnum(value) != type)
			Assert.fail("Value [" + value + "] was not of enum value of: " + Type.getEnumName(type));
	}

	public static function arrayEquals(a:Iterable<Dynamic>, b:Iterable<Dynamic>):Void {
		Assert.assertionCount++;

		if (a != b) {
			var array0 = toArray(a.iterator());
			var array1 = toArray(b.iterator());

			if(array0.length != array1.length) {
				Assert.fail("Iterable [" + array0.length + "] length does not match Iterable [" + array1.length + "] length");
			} else {

				for(index in 0...array0.length) {
					var value0 = array0[index];
					var value1 = array1[index];

					// TODO (Simon) : Remove the funk object stuff.
					if(Std.is(value0, IFunkObject) && Std.is(value1, IFunkObject)) {
						var funk0 : IFunkObject = cast value0;
						var funk1 : IFunkObject = cast value1;
						if(!funk0.equals(funk1)) {
							Assert.fail("Value [" + value0 +"] was not equal to expected value [" + value1 + "]");
						}
					} else {
						if(value0 != value1) {
							Assert.fail("Value [" + value0 +"] was not equal to expected value [" + value1 + "]");
						}
					}
				}
			}
		}
	}

	public static function listEquals(a:IList<Dynamic>, b:IList<Dynamic>):Void {
		Assert.assertionCount++;

		if (a != b) {

			if(a.size != b.size) {
				Assert.fail("List [" + a.size + "] size does not match List [" + b.size + "] size");
			} else {

				for(index in 0...a.size) {
					var value0 = a.productElement(index);
					var value1 = b.productElement(index);

					// TODO (Simon) : Remove the funk object stuff.
					if(Std.is(value0, IFunkObject) && Std.is(value1, IFunkObject)) {
						var funk0 : IFunkObject = cast value0;
						var funk1 : IFunkObject = cast value1;
						if(!funk0.equals(funk1)) {
							Assert.fail("Value [" + value0 +"] was not equal to expected value [" + value1 + "]");
						}
					} else {
						if(value0 != value1) {
							Assert.fail("Value [" + value0 +"] was not equal to expected value [" + value1 + "]");
						}
					}
				}
			}
		}
	}

	public static function valuesEquals(a:StreamValues<Dynamic>, b:StreamValues<Dynamic>):Void {
		listEquals(a.toList(), b.toList());
	}

	public static function valuesEqualsIterable(a:StreamValues<Dynamic>, b:Iterable<Dynamic>):Void {
		listEquals(a.toList(), b.toList());
	}

	private static function toArray(iter : Iterator<Dynamic>) : Array<Dynamic> {
		var a : Array<Dynamic> = [];

		while(iter.hasNext()) {
			a.push(iter.next());
		}

		return a;
	}

}
