package;

import All;
import funk.collections.immutable.List;
import funk.collections.immutable.Nil;
import funk.collections.ICollection;
import funk.collections.IList;
import funk.collections.ISet;
import funk.collections.ListNil;
import funk.tuple.Tuple2;
import funk.unit.Expect;
import funk.Wildcard;
import haxe.Timer;

using funk.collections.immutable.Nil;
using funk.tuple.Tuple2;
using funk.unit.Expect;
using funk.Wildcard;

#if flash
import flash.Lib;
import flash.display.Sprite;
#end

class Main #if flash extends Sprite #end {
	
	public function new(){
		#if flash
		super();
		#end
		
		trace("New");
		
		var total = 3072;
		
		var list = nil.list();
		for(i in 0...total - 1) {
			list = list.prepend(new Signal());
		}
		
		var stamp = Timer.stamp();
		for(s in list) {
			s.l += 1;
		}
		trace(list.size + " : " + (Timer.stamp() - stamp));
		
		
		var arr = new Array<Signal>();
		
		for(a in 0...total) {
			arr.push(new Signal());
		}
		
		stamp = Timer.stamp();
		for(s in arr) {
			s.l += 1;
		}
		trace(arr.length + " : " + (Timer.stamp() - stamp));
	}
	
	public static function main() : Void {
		#if flash
		Lib.current.addChild(new Main());
		#else 
		new Main();
		#end 
	}
}

class Signal {
	
	public var l : Float;
	public var r : Float;
	
	public function new(){
		l = 0.0;
		r = 0.0;
	}
}