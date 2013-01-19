package support;

import funk.collections.immutable.List;
import funk.types.Function1;
import funk.types.Wildcard;
import CommonJS;
import UserAgentContext;

using funk.collections.immutable.extensions.Lists;

class HtmlWildcards {

    public static function addLayer(    wildcard : Wildcard,
                                        parent : HTMLCanvasElement
                                        ) : Function1<Layer, Void> {
        var context = parent.getContext("2d");

        return function(layer : Layer) {
            layer.context().render(layer, context);
        };
    }

    public static function context(wildcard : Wildcard) : Function1<Layer, CanvasContext> {
        return function(layer : Layer) {
            return layer.context();
        };
    }
}
