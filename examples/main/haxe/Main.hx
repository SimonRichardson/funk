package;

import All;
import funk.collections.immutable.Nil;
import funk.collections.ISet;
import funk.tuple.Tuple2;
import funk.unit.Expect;
import funk.Wildcard;

using funk.collections.immutable.Nil;
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
		
		trace(s);
		 
		var a : ISet<String, Int> = nil.set();
		a = a.add("D", 4);
		a = a.add("E", 5);
		a = a.add("F", 6);
		
		var b = s.zip(a);
		
		trace(b);
	}
	
	public static function main() : Void {
		trace("Start");
		new Main();
	}
}
