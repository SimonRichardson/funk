package ;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import funk.collections.immutable.List;
import funk.collections.immutable.extensions.ListsUtil;
import funk.types.Function1;
import funk.types.Pass;
import funk.types.Wildcard;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Tuples2;
using funk.reactive.events.MouseEvents;
using funk.reactive.extensions.Streams;
using Example03.SpriteEventWildcards;

class Example03 extends Sprite {

    public function new() {
        super();

        // Create a list of 6 sprite instances.
        var sprites = ListsUtil.fill(6)(Pass.instanceOf(Sprite));
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

        // Attach a mouse down event to all the sprites.
        sprites.foreach(_.mouseDown(function (event) {
            event.target.x += 10;
        }));
    }

    public static function main() {
        var example = new Example03();
        flash.Lib.current.addChild(example);
    }
}

class SpriteEventWildcards {

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

    public static function mouseDown(   wildcard : Wildcard,
                                        func : Function1<MouseEvent, Void>
                                        ) : Function1<Sprite, Void> {
        return function(sprite : Sprite) {
            sprite.mouseDown().foreach(func);
        };
    }
}
