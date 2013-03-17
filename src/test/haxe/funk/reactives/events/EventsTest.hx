package funk.reactives.events;

using funk.reactives.Stream;
using massive.munit.Assert;
using unit.Asserts;

#if js
import js.Browser;

private typedef Event = js.html.Event;
private typedef EventDispatcher = js.html.EventTarget;
#elseif flash9
import flash.events.Event;
import flash.events.EventDispatcher;
#end

#if (js || flash9)
class EventsTest extends EventsBase {


    @Test
    public function test_event_is_dispatched() {
        var called = false;
        var events = Events.event(dispatcher, "something");
        events.foreach(function(value) {
            called = true;
        });

        dispatchEvent("something");

        called.isTrue();
    }

    @Test
    public function test_listener_is_removed_after_dispatch() {
        var called = false;
        var events = Events.event(dispatcher, "something");
        events.foreach(function(value) {
            called = true;
        });
        events.finish();

        dispatchEvent("something");

        called.isFalse();
    }
}
#else
class EventsTest {

}
#end
