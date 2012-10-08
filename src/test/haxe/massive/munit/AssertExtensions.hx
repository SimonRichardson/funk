package massive.munit;

import massive.munit.Assert;

class AssertExtensions {

	/**
	 * Assert that a value is of a specific enum type.
	 *
	 * @param	value				value expected to be of a given type
	 * @param	type				type the value should be
	 */
	public static function isEnum(value:EnumValue, type:Enum<Dynamic>):Void
	{
		Assert.assertionCount++;
		if (Type.getEnum(value) != type)
			Assert.fail("Value [" + value + "] was not of enum value of: " + Type.getEnumName(type));
	}

}
