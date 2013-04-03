package ;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import funk.collections.immutable.ListUtil;
import funk.types.Function1;
import funk.types.Pass;
import funk.types.Wildcard;

using funk.collections.immutable.List;
using funk.types.Tuple2;
using support.SpriteWildcards;

class Example01 extends Sprite {

    public function new() {
        super();

        // Create a list of 6 sprite instances.
        var sprites = ListUtil.fill(6)(Pass.instanceOf(Sprite));
        // Map the sprites to their graphics object and apply a
        // function on each of them.
        sprites.map(_.graphics()).foreach(function(g) {
            g.beginFill(0x1d1d1d);
            g.drawRect(0.0, 0.0, 20.0, 20.0);
            g.endFill();
        });

        // Combine the Sprite objects with their index, resulting
        // in a List.&lt;Tuple2.&lt;Sprite, Int&gt;&gt;
        //
        // Apply a function on each tuple in order to position the
        // sprite based on its index in the list.
        sprites.zipWithIndex().foreach(function(tuple) {
            var sprite : Sprite = tuple._1();
            var index : Int = tuple._2();

            var pos = index * 21;

            sprite.x = pos;
            sprite.y = pos;
        });

        // Add all sprites to the display list
        sprites.foreach(_.addChild(this));
    }

    public static function main() {
        var example = new Example01();
        flash.Lib.current.addChild(example);
    }
}
