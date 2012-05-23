package;

import All;
import funk.collections.mutable.Nil;
import funk.collections.ISet;
import funk.tuple.Tuple2;
import funk.unit.Expect;
import funk.Wildcard;

using funk.collections.mutable.Nil;
using funk.tuple.Tuple2;
using funk.unit.Expect;
using funk.Wildcard;

class Main {
	
	public function new(){
		trace("New");
		
		var s : ISet<String, Int> = nil.set();
		s = s.add("A", 1);
		s = s.add("B", 2);
		s = s.add("C", 3);
		 
		var b = s.map(function(t1) {
			return tuple2("D", t1._2 + 1).instance();
		});
		
		trace(b);
	}
	
	public static function main() : Void {
		trace("Start");
		new Main();
	}
}
