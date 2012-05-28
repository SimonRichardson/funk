package funk.collections.immutable;

import funk.collections.IList;
import funk.collections.immutable.Nil;
import funk.collections.immutable.ListUtil;
import funk.collections.ListTestBase;

using funk.collections.immutable.Nil;

/**
* Auto generated MassiveUnit Test Class  for funk.collections.immutable.List 
*/
class ListTest extends ListTestBase {
	
	override public function toList(arg:Dynamic):IList<Dynamic> {
		return ListUtil.toList(arg);
	}
}
