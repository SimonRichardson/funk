package funk.collections.mutable;

import funk.collections.IList;
import funk.collections.mutable.ListUtil;
import funk.collections.mutable.Nil;
import funk.collections.ListTestBase;

using funk.collections.mutable.Nil;

/**
* Auto generated MassiveUnit Test Class  for funk.collections.immutable.List 
*/
class ListTest extends ListTestBase {
	
	override public function toList(arg:Dynamic):IList<Dynamic> {
		return ListUtil.toList(arg);
	}
}
