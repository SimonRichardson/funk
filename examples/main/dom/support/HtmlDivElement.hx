package support;

import CommonJS;
import UserAgentContext;

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
