package support;

import funk.types.Function1;
import funk.types.Wildcard;
import support.HtmlDivElement;
import CommonJS;
import UserAgentContext;

using funk.reactive.events.MouseEvents;
using funk.reactive.extensions.Streams;

class HtmlWildcards {

    public static function addElement(  wildcard : Wildcard,
                                        parent : HTMLElement
                                        ) : Function1<HtmlDivElement, Void> {
        return function(element : HtmlDivElement) {
            parent.appendChild(element.htmlElement());
        };
    }

    public static function styles(wildcard : Wildcard) : Function1<HtmlDivElement, CSSStyleDeclaration> {
        return function(element : HtmlDivElement) {
            return element.style();
        };
    }

    public static function mouseDown(   wildcard : Wildcard,
                                        func : Function1<Event, Void>
                                        ) : Function1<HtmlDivElement, Void> {
        return function(element : HtmlDivElement) {
            element.htmlElement().mouseDown().foreach(func);
        };
    }
}
