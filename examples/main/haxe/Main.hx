package;

import All;
import funk.signal.Signal2;

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
	}
	
	public static function main() : Void {
		trace("Start");
		new Main();
	}
}
