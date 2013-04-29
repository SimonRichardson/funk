package ;

import js.Browser;
import js.html.CanvasElement;
import funk.ds.immutable.ListUtil;
import funk.ds.immutable.Range;
import funk.types.Function1;
import funk.types.Pass;
import funk.types.Wildcard;
import support.CanvasPainter;
import support.Layer;
import support.CanvasContext;

using funk.ds.immutable.List;
using funk.types.Tuple2;
using support.HtmlWildcards;

class Example02 {

    public function new() {
        CanvasPainter.init(getCanvas());

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

    public function getCanvas() : CanvasElement {
        return cast Browser.document.body.getElementsByTagName('canvas')[0];
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
