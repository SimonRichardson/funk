package funk.reactives.events;

using funk.reactives.Stream;
using funk.reactives.events.RenderEvents;
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
class RenderEventsTest extends EventsBase {


    @Test
    public function render_event_is_dispatched() {
        var called = false;

        #if flash9
        var stage = flash.Lib.current.stage;
        dispatcher = stage;
        var events = RenderEvents.render(stage);
        #else
        var target = new RenderTarget(RenderEventTypes.toString(Render));
        dispatcher = cast target;
        var events = RenderEvents.render(target);
        #end

        events.foreach(function(value) {
            called = true;
        });

        dispatchEvent(RenderEventTypes.toString(Render));

        called.isTrue();
    }

    @Test
    public function render_listener_is_removed_after_dispatch() {
        var called = false;

        #if flash9
        var stage = flash.Lib.current.stage;
        dispatcher = stage;
        var events = RenderEvents.render(stage);
        #else
        var target = new RenderTarget(RenderEventTypes.toString(Render));
        dispatcher = cast target;
        var events = RenderEvents.render(target);
        #end

        events.foreach(function(value) {
            called = true;
        });
        events.finish();

        dispatchEvent(RenderEventTypes.toString(Render));

        called.isFalse();
    }

    @Test
    public function enterFrame_event_is_dispatched() {
        var called = false;

        #if flash9
        var events = RenderEvents.enterFrame(dispatcher);
        #else
        var target = new RenderTarget(RenderEventTypes.toString(EnterFrame));
        dispatcher = cast target;
        var events = RenderEvents.enterFrame(target);
        #end

        events.foreach(function(value) {
            called = true;
        });

        dispatchEvent(RenderEventTypes.toString(EnterFrame));

        called.isTrue();
    }

    @Test
    public function enterFrame_listener_is_removed_after_dispatch() {
        var called = false;

        #if flash9
        var events = RenderEvents.enterFrame(dispatcher);
        #else
        var target = new RenderTarget(RenderEventTypes.toString(EnterFrame));
        dispatcher = cast target;
        var events = RenderEvents.enterFrame(target);
        #end

        events.foreach(function(value) {
            called = true;
        });
        events.finish();

        dispatchEvent(RenderEventTypes.toString(EnterFrame));

        called.isFalse();
    }
}
#else
class RenderEventsTest {

}
#end
