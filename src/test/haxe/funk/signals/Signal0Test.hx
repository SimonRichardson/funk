package funk.signals;

import funk.signals.Signal0;

using funk.types.Option;
using funk.types.PartialFunction0;
using massive.munit.Assert;
using unit.Asserts;

class Signal0Test {

    public var signal : Signal0;

    public var signalName : String;

    @Before
    public function setup() {
        signal = new Signal0();
        signalName = 'Signal0';
    }

    @After
    public function tearDown() {
        signal = null;
    }

    @Test
    public function when_adding_listener__should_return_option() : Void {
        var func = function() {}.fromFunction();
        signal.add(func).isDefined().isTrue();
    }

    @Test
    public function when_adding_listener__should_return_option_with_same_listener() : Void {
        var listener = function() {}.fromFunction();
        signal.add(listener).get().listener().areEqual(listener);
    }

    @Test
    public function when_adding_listener__should_size_be_1() : Void {
        var listener = function() {}.fromFunction();
        signal.add(listener);
        signal.size().areEqual(1);
    }

    @Test
    public function when_adding_same_listener__should_size_be_1() : Void {
        var listener = function() {}.fromFunction();
        signal.add(listener);
        signal.add(listener);
        signal.size().areEqual(1);
    }

    @Test
    public function when_adding_different_listener__should_size_be_2() : Void {
        signal.add(function() {}.fromFunction());
        signal.add(function() {}.fromFunction());
        signal.size().areEqual(2);
    }

    @Test
    public function when_dispatching_after_add__should_size_be_2() : Void {
        signal.add(function() {}.fromFunction());
        signal.add(function() {}.fromFunction());
        signal.dispatch();
        signal.size().areEqual(2);
    }

    @Test
    public function when_adding_once_listener__should_return_option_with_same_listener() : Void {
        var listener = function() {}.fromFunction();
        signal.addOnce(listener).get().listener().areEqual(listener);
    }

    @Test
    public function when_adding_once_listener__should_size_be_1() : Void {
        var listener = function() {}.fromFunction();
        signal.addOnce(listener);
        signal.size().areEqual(1);
    }

    @Test
    public function when_adding_once_same_listener__should_size_be_1() : Void {
        var listener = function() {}.fromFunction();
        signal.addOnce(listener);
        signal.addOnce(listener);
        signal.size().areEqual(1);
    }

    @Test
    public function when_adding_once_different_listener__should_size_be_2() : Void {
        signal.addOnce(function() {}.fromFunction());
        signal.addOnce(function() {}.fromFunction());
        signal.size().areEqual(2);
    }

    @Test
    public function when_dispatching_after_addOnce__should_size_be_0() : Void {
        signal.addOnce(function() {}.fromFunction());
        signal.addOnce(function() {}.fromFunction());
        signal.dispatch();
        signal.size().areEqual(0);
    }

    @Test
    public function when_dispatching_after_add_and_addOnce__should_size_be_1() : Void {
        signal.add(function() {}.fromFunction());
        signal.addOnce(function() {}.fromFunction());
        signal.dispatch();
        signal.size().areEqual(1);
    }

    @Test
    public function when_dispatching_after_addOnce_and_add__should_size_be_1() : Void {
        signal.add(function() {}.fromFunction());
        signal.addOnce(function() {}.fromFunction());
        signal.dispatch();
        signal.size().areEqual(1);
    }

    @Test
    public function when_adding_and_removing_listener__should_size_be_0() : Void {
        var listener = function() {}.fromFunction();
        signal.add(listener);
        signal.remove(listener);
        signal.size().areEqual(0);
    }

    @Test
    public function when_adding_same_listener_twice_and_removing_listener__should_size_be_0() : Void {
        var listener = function() {}.fromFunction();
        signal.add(listener);
        signal.add(listener);
        signal.remove(listener);
        signal.size().areEqual(0);
    }

    @Test
    public function when_adding_once_and_removing_listener__should_size_be_0() : Void {
        var listener = function() {}.fromFunction();
        signal.addOnce(listener);
        signal.remove(listener);
        signal.size().areEqual(0);
    }

    @Test
    public function when_adding_once_same_listener_twice_and_removing_listener__should_size_be_0() : Void {
        var listener = function() {}.fromFunction();
        signal.addOnce(listener);
        signal.addOnce(listener);
        signal.remove(listener);
        signal.size().areEqual(0);
    }

    @Test
    public function when_adding_listeners_and_removing_all__should_size_be_0() : Void {
        signal.add(function() {}.fromFunction());
        signal.add(function() {}.fromFunction());
        signal.removeAll();
        signal.size().areEqual(0);
    }

    @Test
    public function when_adding_once_listeners_and_removing_all__should_size_be_0() : Void {
        signal.addOnce(function() {}.fromFunction());
        signal.addOnce(function() {}.fromFunction());
        signal.removeAll();
        signal.size().areEqual(0);
    }

    @Test
    public function when_adding_mixture_of_listeners_and_removing_all__should_size_be_0() : Void {
        signal.add(function() {}.fromFunction());
        signal.addOnce(function() {}.fromFunction());
        signal.add(function() {}.fromFunction());
        signal.removeAll();
        signal.size().areEqual(0);
    }

    @Test
    public function when_add_then_adding_once_with_same_listener__should_throw_error() : Void {
        var listener = function() {}.fromFunction();
        signal.add(listener);

        var called = try {
            signal.addOnce(listener);
            false;
        } catch(error : Dynamic) {
            true;
        }
        called.isTrue();
    }
}
