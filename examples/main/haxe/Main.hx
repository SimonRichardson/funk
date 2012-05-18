package;

import All;
import funk.signal.Signal2;
import funk.signal.Signal;
import funk.collections.mutable.Nil;
import funk.collections.IList;
import funk.collections.ListUtil;
import funk.unit.Expect;

using funk.collections.mutable.Nil;
using funk.collections.ListUtil;
using funk.unit.Expect;

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
		 
		 var list = nil.list();
		 list = list.prepend(1);
		 list = list.prepend(2);
		 list = list.prepend(3);
		 list = list.prepend(4);
		 
		 list = list.flatMap(function(a : Int) : IList<Int> {
		 	return a == 2 ? nil.list() : a.toList();
		 });
		 
		 trace(nil.list() == nil.list());
		 
		 trace(list.toString());
	}
	
	public static function main() : Void {
		trace("Start");
		new Main();
	}
}
