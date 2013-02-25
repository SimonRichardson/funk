package support;

import js.Browser;
import js.html.DivElement;
import js.html.CSSStyleDeclaration;

class HtmlDivElement {

    private var element : DivElement;

    public function new() {
        element = Browser.document.createDivElement();
    }

    public function htmlElement() : DivElement {
        return element;
    }

    public function style() : CSSStyleDeclaration {
        return element.style;
    }
}
