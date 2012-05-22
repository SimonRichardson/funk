package;

import All;
import funk.collections.immutable.Nil;
import funk.collections.ISet;
import funk.unit.Expect;
import funk.Wildcard;

using funk.collections.immutable.Nil;
using funk.unit.Expect;
using funk.Wildcard;

class Main {
	
	public function new(){
		 trace("hello");
		 
		 var s : ISet<String, Int> = nil.set();
		 s.add("A", 1);
		 s.add("B", 2);
		 s.add("C", 3);
		 
		 trace(s);
	}
	
	public static function main() : Void {
		trace("Start");
		new Main();
	}
}
