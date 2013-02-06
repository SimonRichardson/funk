package funk.types;

import funk.collections.immutable.List;
import funk.types.Selector;

using funk.collections.immutable.extensions.Lists;
using massive.munit.Assert;
using unit.Asserts;


class SelectorTest {

    @Test
    public function when_calling_selector__should_return_valid_list() {
        Selector.query("body > :first-child").isNotNull();
    }

    @Test
    public function when_calling_selector__should_return_a_non_empty_list() {
        Selector.query("body > :first-child").nonEmpty().isTrue();
    }

    @Test
    public function should_calling_selector_query_return_correct_expr_1() {
        Selector.query("body>:first-child").areEqual(Cons(ELine(EPropBlock(VTag("body"),EPropBlock(VChild,EProp(VAccessor("first-child"))))),Nil));
    }

    @Test
    public function should_calling_selector_query_return_correct_expr_2() {
        Selector.query("body  .name-of-something>#title  :first-child").areEqual(Cons(ELine(EPropBlock(VTag("body"),EPropBlock(VClassName("name-of-something"),EPropBlock(VChild,EPropBlock(VIdent("title"),EProp(VAccessor("first-child"))))))),Nil));
    }

    @Test
    public function should_calling_selector_query_return_correct_expr_3() {
        Selector.query("body;  .name-of-something>#title;  :first-child").areEqual(Cons(ELine(EProp(VTag("body"))),Cons(ELine(EPropBlock(VClassName("name-of-something"),EPropBlock(VChild,EProp(VIdent("title"))))),Cons(ELine(EProp(VAccessor("first-child"))),Nil))));
    }

    @Test
    public function should_calling_selector_query_return_correct_expr_4() {
        Selector.query("body > .name").areEqual(Cons(ELine(EPropBlock(VTag("body"),EPropBlock(VChild,EProp(VClassName("name"))))),Nil));
    }

    @Test
    public function should_calling_selector_query_return_correct_expr_5() {
        Selector.query("body + .name").areEqual(Cons(ELine(EPropBlock(VTag("body"),EPropBlock(VNext,EProp(VClassName("name"))))),Nil));
    }

    @Test
    public function should_calling_selector_query_return_correct_expr_6() {
        Selector.query("body ~ .name").areEqual(Cons(ELine(EPropBlock(VTag("body"),EPropBlock(VSibling,EProp(VClassName("name"))))),Nil));
    }

    @Test
    public function should_calling_selector_query_return_correct_expr_7() {
        Selector.query("body .name").areEqual(Cons(ELine(EPropBlock(VTag("body"),EProp(VClassName("name")))),Nil));
    }

    @Test
    public function should_calling_selector_query_return_correct_expr_8() {
        Selector.query("p body,.name").areEqual(Cons(ELine(EPropBlock(VTag("p"),EProp(VTag("body")))),Cons(ELine(EProp(VClassName("name"))),Nil)));
    }

    @Test
    public function should_calling_selector_query_return_correct_expr_9() {
        Selector.query("p,b").areEqual(Cons(ELine(EProp(VTag("p"))),Cons(ELine(EProp(VTag("b"))),Nil)));
    }
}
