package;

import All;

class TestRunner {	
	public function new(){
		trace("New");
	}
	
	public static function main() {
		trace("Hello From FDT haXe !");
		new TestRunner();
	}
}
