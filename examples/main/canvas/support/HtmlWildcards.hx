package support;

import js.Browser;
import js.html.CanvasElement;
import funk.collections.immutable.List;
import funk.types.Function1;
import funk.types.Wildcard;

using funk.collections.immutable.extensions.Lists;
using funk.reactive.events.MouseEvents;
using funk.reactive.extensions.Streams;

class HtmlWildcards {

    public static function addLayer(    wildcard : Wildcard,
                                        parent : CanvasElement
                                        ) : Function1<Layer, Void> {
        var context = parent.getContext("2d");

        return function(layer : Layer) {
            layer.parent = parent;

            var cxt = layer.context();
            cxt.context = context;
            cxt.render();
        };
    }

    public static function context(wildcard : Wildcard) : Function1<Layer, CanvasContext> {
        return function(layer : Layer) {
            return layer.context();
        };
    }

    public static function mouseDown(   wildcard : Wildcard,
                                        func : Function1<Layer, Void>
                                        ) : Function1<Layer, Void> {
        return function(layer : Layer) {
            layer.parent.mouseDown().foreach(function(event) {
                // TODO (Simon) - this could be a lot better!
                var x = layer.x;
                var y = layer.y;
                var xw = x + layer.width;
                var yh = y + layer.height;

                var mx = event.layerX;
                var my = event.layerY;

                if (mx >= x && my >= y && mx < xw && my < yh) {
                    func(layer);
                }
            });
        };
    }
}
