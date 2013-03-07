package support;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import funk.types.Function1;
import funk.types.Wildcard;

using funk.reactive.events.MouseEvents;
using funk.reactive.Stream;

class SpriteWildcards {

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
