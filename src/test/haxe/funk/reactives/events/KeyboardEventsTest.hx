package funk.reactives.events;

using funk.reactives.Stream;
using funk.reactives.events.KeyboardEvents;
using massive.munit.Assert;
using unit.Asserts;

#if js
import js.Browser;

private typedef Event = js.html.Event;
private typedef EventDispatcher = js.html.EventTarget;
#elseif flash9
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
#end

#if (js || flash9)
class KeyboardEventsTest extends EventsBase {

	
	@Test
	public function keyDown_event_is_dispatched() {
		var called = false;
		var events = KeyboardEvents.keyDown(dispatcher);
		events.foreach(function(value) {
			called = true;
		});

		dispatchEvent(KeyboardEventTypes.toString(KeyDown));

		called.isTrue();
	}

	@Test
	public function keyDown_listener_is_removed_after_dispatch() {
		var called = false;
		var events = KeyboardEvents.keyDown(dispatcher);
		events.foreach(function(value) {
			called = true;
		});
		events.finish();

		dispatchEvent(KeyboardEventTypes.toString(KeyDown));

		called.isFalse();
	}

	@Test
	public function keyUp_event_is_dispatched() {
		var called = false;
		var events = KeyboardEvents.keyUp(dispatcher);
		events.foreach(function(value) {
			called = true;
		});

		dispatchEvent(KeyboardEventTypes.toString(KeyUp));

		called.isTrue();
	}

	@Test
	public function keyUp_listener_is_removed_after_dispatch() {
		var called = false;
		var events = KeyboardEvents.keyUp(dispatcher);
		events.foreach(function(value) {
			called = true;
		});
		events.finish();

		dispatchEvent(KeyboardEventTypes.toString(KeyUp));

		called.isFalse();
	}

	override private function createEvent(value : String) {
		var event = null;

		#if js
		event = super.createEvent(value);
		#elseif flash9
		event = new KeyboardEvent(value);
		#end

		return event;
	}
}
#else
class KeyboardEventsTest {

}
#end
