package ;

import funk.collections.immutable.List;
import funk.collections.immutable.extensions.ListsUtil;
import funk.types.Function1;
import funk.types.Pass;
import funk.types.Wildcard;
import CommonJS;
import UserAgentContext;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Tuples2;
using Example01.HtmlWildcards;

class Example01 {

    public function new() {
        // Create a list of 6 elements instances.
        var elements = ListsUtil.fill(6)(Pass.instanceOf(HtmlDivElement));

        // Map the elements to their styles object and apply a
        // function on each of them.
        elements.map(_.styles()).foreach(function(s) {
            s.backgroundColor = "red";
            s.position = "absolute";
            s.width = "20px";
            s.height = "20px";
        });

        // Combine the Elements objects with their index, resulting
        // in a List.&lt;Tuple2.&lt;Element, Int&gt;&gt;
        //
        // Apply a function on each tuple in order to position the
        // sprite based on its index in the list.
        elements.zipWithIndex().foreach(function(tuple) {
            var element : HtmlDivElement = tuple._1();
            var index : Int = tuple._2();

            var pos = index * 21;

            element.style().left = pos + "px";
            element.style().top = pos + "px";

        });

        // Add all elements to the dom
        elements.foreach(_.addElement(getBody()));
    }

    public function getBody() : HTMLElement {
        return CommonJS.getHtmlDocument().body;
    }

    public static function main() {
        new Example01();
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

    public static function styles(wildcard : Wildcard) : Function1<HtmlDivElement, CSSStyleDeclaration> {
        return function(element : HtmlDivElement) {
            return element.style();
        };
    }

}
