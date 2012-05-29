package;

import All;
import funk.collections.IList;
import funk.collections.immutable.ListUtil;
import funk.tuple.Tuple2;
import funk.Pass;
import funk.Wildcard;

using funk.collections.immutable.ListUtil;
using funk.Pass;
using funk.Wildcard;
using Std;

class Main {
	
	public function new(){
		
		var items = 4.fill(Item.instanceOf());
		
		items.map(_.method).foreach(function(m):Void {
			trace(m());
		});
	}
	
	public static function main() : Void {
		new Main();
	}
}

class Item {
	
	public function new(){
		
	}
	
	public function method():Method {
		return new Method();
	}
}

class Method {
	
	public function new(){
		trace("here");
	}
}