package funk.types;

import funk.collections.immutable.List;
import funk.types.Selector;

using funk.collections.immutable.extensions.Lists;
using massive.munit.Assert;
using unit.Asserts;


class SelectorTest {

    @xTest
    public function when_calling_selector__should_return_valid_list() {
        Selector.query("body > :first-child").isNotNull();
    }

    @xTest
    public function when_calling_selector__should_return_a_non_empty_list() {
        Selector.query("body > :first-child").nonEmpty().isTrue();
    }

    @Test
    public function when_calling_selector_query_with_accessor__should_return_valid_expr_1() {
        Selector.query(":n-child(1)").areEqual(Cons(ELine(EPropBlock(Accessor("n-child"),ESub(EProp(Integer(1))))),Nil));
    }

    @Test
    public function when_calling_selector_query_with_accessor__should_return_valid_expr_2() {
        Selector.query(":n-child(name)").areEqual(Cons(ELine(EPropBlock(Accessor("n-child"),ESub(EProp(Tag("name"))))),Nil));
    }

    @Test
    public function when_calling_selector_query_with_accessor__should_return_valid_expr_3() {
        Selector.query(":n-child(\"name\")").areEqual(Cons(ELine(EPropBlock(Accessor("n-child"),ESub(EProp(Word("name"))))),Nil));
    }

    @Test
    public function should_calling_selector_query_return_correct_expr_0() {
        Selector.query("body>:first-child>\"name\">.tag").areEqual(Cons(ELine(EPropBlock(Tag("body"),EPropBlock(Child,EPropBlock(Accessor("first-child"),EPropBlock(Child,EPropBlock(Word("name"),EPropBlock(Child,EProp(ClassName("tag"))))))))),Nil));
    }

    @xTest
    public function should_calling_selector_query_return_correct_expr_1() {
        Selector.query("body>:first-child").areEqual(Cons(ELine(EPropBlock(Tag("body"),EPropBlock(Child,EProp(Accessor("first-child"))))),Nil));
    }

    @xTest
    public function should_calling_selector_query_return_correct_expr_2() {
        Selector.query("body  .name-of-something>#title  :first-child").areEqual(Cons(ELine(EPropBlock(Tag("body"),EPropBlock(ClassName("name-of-something"),EPropBlock(Child,EPropBlock(Ident("title"),EProp(Accessor("first-child"))))))),Nil));
    }

    @xTest
    public function should_calling_selector_query_return_correct_expr_3() {
        Selector.query("body;  .name-of-something>#title;  :first-child").areEqual(Cons(ELine(EProp(Tag("body"))),Cons(ELine(EPropBlock(ClassName("name-of-something"),EPropBlock(Child,EProp(Ident("title"))))),Cons(ELine(EProp(Accessor("first-child"))),Nil))));
    }

    @xTest
    public function should_calling_selector_query_return_correct_expr_4() {
        Selector.query("body > .name").areEqual(Cons(ELine(EPropBlock(Tag("body"),EPropBlock(Child,EProp(ClassName("name"))))),Nil));
    }

    @xTest
    public function should_calling_selector_query_return_correct_expr_5() {
        Selector.query("body + .name").areEqual(Cons(ELine(EPropBlock(Tag("body"),EPropBlock(Next,EProp(ClassName("name"))))),Nil));
    }

    @xTest
    public function should_calling_selector_query_return_correct_expr_6() {
        Selector.query("body ~ .name").areEqual(Cons(ELine(EPropBlock(Tag("body"),EPropBlock(Sibling,EProp(ClassName("name"))))),Nil));
    }

    @xTest
    public function should_calling_selector_query_return_correct_expr_7() {
        Selector.query("body .name").areEqual(Cons(ELine(EPropBlock(Tag("body"),EProp(ClassName("name")))),Nil));
    }

    @xTest
    public function should_calling_selector_query_return_correct_expr_8() {
        Selector.query("p body,.name").areEqual(Cons(ELine(EPropBlock(Tag("p"),EProp(Tag("body")))),Cons(ELine(EProp(ClassName("name"))),Nil)));
    }

    @xTest
    public function should_calling_selector_query_return_correct_expr_9() {
        Selector.query("p,b").areEqual(Cons(ELine(EProp(Tag("p"))),Cons(ELine(EProp(Tag("b"))),Nil)));
    }
}
