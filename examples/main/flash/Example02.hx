package ;

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import funk.ds.immutable.ListUtil;
import funk.ds.immutable.Range;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Pass;
import funk.types.Wildcard;

using funk.ds.immutable.List;
using funk.types.Tuple2;

class Example02 extends Sprite {

    public function new() {
        super();

        Range.until(0, 4).foreach(function(i) {
            var sprite = new Sprite();

            with(function(s : Sprite) {
                with(function(g : Graphics) {
                    g.beginFill(0x1d1d1d);
                    g.drawRect(0.0, 0.0, 20.0, 20.0);
                    g.endFill();
                })(s.graphics);

                var pos = i * 21.0;

                s.x = pos;
                s.y = pos;
            })(sprite);

            addChild(sprite);
        });
    }

    public static function with<T>(func : Function1<T, Void>) : Function1<T, Void> {
        return function (value : T) {
            func(value);
        };
    }

    public static function main() {
        var example = new Example02();
        flash.Lib.current.addChild(example);
    }
}
