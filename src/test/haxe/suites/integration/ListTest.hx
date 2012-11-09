package suites.integration;

import funk.collections.immutable.ListUtil;
import funk.Wildcard;

import massive.munit.Assert;
import util.AssertExtensions;

using funk.collections.immutable.ListUtil;
using funk.Wildcard;

using massive.munit.Assert;
using util.AssertExtensions;

class ListTest {

	@Test
	public function when_mapping_to_string__should_convert_to_uppercase() : Void {
		"dlrow olleh".toList().map(_.toUpperCase).reduceRight(_.plus_).get().areEqual("HELLO WORLD");
	}
}
