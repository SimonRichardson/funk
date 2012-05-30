package;

import All;
import funk.collections.IList;
import funk.collections.immutable.ListUtil;
import funk.tuple.Tuple2;
import funk.Pass;
import funk.wildcard.Wildcard;

using funk.collections.immutable.ListUtil;
using funk.Pass;
using funk.wildcard.Wildcard;
using Std;

class Main {
	
	public function new(){
		
		var items = 4.fill(Item.instanceOf());
		
		items.map(_.method).foreach(function(m):Void {
			trace(m);
		});
	}
	
	public static function main() : Void {
		new Main();
	}
}

class Item {
	
	public var method(getMethod, never) : Method;
	
	public function new(){
		
	}
	
	public function getMethod():Method {
		return new Method();
	}
}

class Method {
	
	public function new(){
		trace("here");
	}
}