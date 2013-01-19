package ;

import funk.collections.immutable.List;
import funk.collections.immutable.extensions.ListsUtil;
import funk.collections.immutable.extensions.Range;
import funk.types.Function1;
import funk.types.Pass;
import funk.types.Wildcard;
import support.Layer;
import support.CanvasContext;
import CommonJS;
import UserAgentContext;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Tuples2;
using support.HtmlWildcards;

class Example02 {

    public function new() {
        Range.until(0, 4).foreach(function(i) {
            var layer = new Layer();

            with(function(l : Layer) {
                with(function(c : CanvasContext) {
                    c.fillStyle("#00ffff");
                    c.fillRect(0, 0, 20, 20);
                })(l.context());

                var pos = i * 21.0;

                l.x = pos;
                l.y = pos;
            })(layer);

            _.addLayer(getCanvas())(layer);
        });
    }

    public function getCanvas() : HTMLCanvasElement {
        return CommonJS.getHtmlDocument().body.getElementsByTagName('canvas')[0];
    }

    public static function with<T>(func : Function1<T, Void>) : Function1<T, Void> {
        return function (value : T) {
            func(value);
        };
    }

    public static function main() {
        new Example02();
    }
}
