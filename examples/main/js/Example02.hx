package ;

import funk.collections.immutable.List;
import funk.collections.immutable.extensions.ListsUtil;
import funk.collections.immutable.extensions.Range;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Pass;
import funk.types.Wildcard;
import CommonJS;
import UserAgentContext;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Tuples2;
using Example02.HtmlWildcards;

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

    public function getBody() : HTMLElement {
        return CommonJS.getHtmlDocument().body;
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

class HtmlDivElement {

    private var element : HTMLElement;

    public function new() {
        element = CommonJS.newElement(type());
    }

    public function htmlElement() : HTMLElement {
        return element;
    }

    public function style() : CSSStyleDeclaration {
        return element.style;
    }

    public function type() : String {
        return "div";
    }
}

class HtmlWildcards {

    public static function addElement(  wildcard : Wildcard,
                                        parent : HTMLElement
                                        ) : Function1<HtmlDivElement, Void> {
        return function(element : HtmlDivElement) {
            trace(element.htmlElement());
            parent.appendChild(element.htmlElement());
        };
    }
}

