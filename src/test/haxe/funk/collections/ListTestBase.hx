package funk.collections;

import funk.collections.IList;
import funk.errors.ArgumentError;
import funk.errors.RangeError;
import funk.option.Option;
import funk.unit.Expect;
import funk.wildcard.Wildcard;
import unit.ExpectUtil;
import unit.Should;

using funk.unit.Expect;
using funk.option.Option;
using funk.wildcard.Wildcard;
using unit.ExpectUtil;
using unit.Should;

class ListTestBase {
	
	public function toList(arg:Dynamic) : IList<Dynamic> {
		return null;
	}
	
	@Test
	public function hello_world():Void {
		should("\"dlrow olleh\" to \"HELLO WORLD\"").expect(toList("dlrow olleh").map(_.toUpperCase).reduceRight(_.plus_)).toBeEqualTo("HELLO WORLD");
	}
}
