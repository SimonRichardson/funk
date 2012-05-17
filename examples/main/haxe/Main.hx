package;

import All;
import funk.signal.Signal0;

class Main {
	
	public function new(){
		 trace("hello");
		 
		 var signal = new Signal0();
		 signal.add(function() : Void {
		 	trace("1");
		 });
		 signal.add(function() : Void {
		 	trace("2");
		 });
		 signal.dispatch();
	}
	
	public static function main() : Void {
		trace("Start"); 
		new Main();
	}
}
