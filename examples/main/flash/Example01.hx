package ;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.ListsUtil;
import funk.types.Function1;
import funk.types.Pass;
import funk.types.Wildcard;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Tuples2;
using Example01.WildcardDisplay;

class Example01 extends Sprite {

	public function new() {
		super();

		var sprites = ListsUtil.fill(4)(Pass.instanceOf(Sprite));
		sprites.map(_.graphics()).foreach(function(g) {
			g.beginFill(0xff00ff);
			g.drawRect(0.0, 0.0, 20.0, 20.0);
			g.endFill();
		});

		sprites.zipWithIndex().foreach(function(tuple) {
			var sprite : Sprite = tuple._1();
			var index : Int = tuple._2();

			var pos = index * 32;
			
			sprite.x = 21;
		});

		sprites.foreach(_.addChild(this));
	}

	public static function main() {
		new Example01();
	}
}

class WildcardDisplay {

	public static function addChild(wildcard : Wildcard, parent : Sprite) : Function1<Sprite, Void> {
		return function(sprite : Sprite) {
			parent.addChild(sprite);
		};
	}

	public static function graphics(wildcard : Wildcard) : Function1<Sprite, Graphics> {
		return function(sprite : Sprite) {
			return sprite.graphics;
		};
	}
}