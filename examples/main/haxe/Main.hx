package;

import All;
import funk.signal.Signal2;
import funk.signal.Signal;
import funk.collections.mutable.Nil;
import funk.collections.IList;
import funk.collections.ListUtil;
import funk.unit.Expect;
import funk.Wildcard;
import funk.collections.Range;

using funk.collections.mutable.Nil;
using funk.collections.ListUtil;
using funk.unit.Expect;
using funk.Wildcard;

class Main {
	
	public function new(){
		 trace("hello");
		 
		 var signal = new Signal2<Int, String>();
		 signal.add(function(v : Int, s : String) : Void {
		 	trace("1 - " + v + " : " + s);
		 });
		 signal.add(function(v : Int, s : String) : Void {
		 	trace("2 - " + v + " : " + s);
		 });
		 signal.dispatch(4, "eh");
		 
		 var n = 12;
		 var list = Range.to(1, n).takeRight(4);
		 
		 trace(list);
	}
	
	public static function main() : Void {
		trace("Start");
		new Main();
	}
}
