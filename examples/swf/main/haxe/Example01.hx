package ;

import flash.Lib;
import flash.display.Graphics;
import flash.display.Sprite;
import funk.collections.IList;
import funk.collections.immutable.ListUtil;
import funk.tuple.Tuple2;
import funk.Pass;
import funk.Wildcard;

using funk.collections.immutable.ListUtil;
using funk.Pass;
using funk.Wildcard;
using Std;

class Example01 extends Sprite {

	public function new() {
		super();
		
		var sprites:IList<Sprite> = 10.fill(Sprite.instanceOf());
		
		sprites.map(_.graphics).foreach(function(g: Graphics): Void {
			g.beginFill((Math.random() * 0xffff).int());
			g.drawCircle(0.0, 0.0, 32);
			g.endFill();
		});
		
		sprites.zipWithIndex.foreach(function(element: ITuple2<Sprite, Int>): Void {
			var sprite = element._1;
			var index = element._2 + 1;
			
			sprite.x = index * 32.0;
			sprite.y = index * 32.0;
		});
		
		sprites.foreach(_.addChild(this));
	}
	
	public static function main(): Void {
		Lib.current.addChild(new Example01());
	}
}
