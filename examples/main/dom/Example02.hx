package ;

import js.Browser;
import js.html.Element;
import js.html.CSSStyleDeclaration;
import funk.ds.immutable.ListUtil;
import funk.ds.immutable.Range;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Pass;
import funk.types.Wildcard;
import support.HtmlDivElement;

using funk.ds.immutable.List;
using funk.types.Tuple2;
using support.HtmlWildcards;

class Example02 {

    public function new() {
        Range.until(0, 4).foreach(function(i) {
            var element = new HtmlDivElement();

            with(function(s : HtmlDivElement) {
                with(function(g : CSSStyleDeclaration) {
                    g.backgroundColor = "red";
                    g.position = "absolute";
                    g.width = "20px";
                    g.height = "20px";
                })(s.style());

                var pos = i * 21;

                s.style().left = pos + "px";
                s.style().top = pos + "px";
            })(element);

            _.addElement(getBody())(element);
        });
    }

    public function getBody() : Element {
        return Browser.window.document.body;
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
