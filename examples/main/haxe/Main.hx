package;

import All;
import funk.collections.immutable.List;
import funk.collections.immutable.Nil;
import funk.collections.ICollection;
import funk.collections.IList;
import funk.collections.ISet;
import funk.collections.ListNil;
import funk.option.Option;
import funk.tuple.Tuple2;
import funk.unit.Expect;
import funk.Wildcard;
import haxe.Timer;
import funk.util.Reflect;

using funk.collections.immutable.Nil;
using funk.tuple.Tuple2;
using funk.unit.Expect;
using funk.Wildcard;

class Main {
	
	public function new(){
		var o : Option<Int> = Some(10);
		trace(Type.enumConstructor(o));
		trace(Reflect.is(Some(10), Some(11)));
	}
	
	public static function main() : Void {
		new Main();
	}
}