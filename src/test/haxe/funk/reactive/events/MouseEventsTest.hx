package funk.reactive.events;

using funk.reactive.Stream;
using funk.reactive.events.MouseEvents;
using massive.munit.Assert;
using unit.Asserts;

#if js
import js.Browser;

private typedef Event = js.html.Event;
private typedef EventDispatcher = js.html.EventTarget;
#elseif flash9
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
#end

#if (js || flash9)
class MouseEventsTest extends EventsBase {

	
	@Test
	public function click_event_is_dispatched() {
		var called = false;
		var events = MouseEvents.click(dispatcher);
		events.foreach(function(value) {
			called = true;
		});

		dispatchEvent(MouseEventTypes.toString(Click));

		called.isTrue();
	}

	@Test
	public function click_listener_is_removed_after_dispatch() {
		var called = false;
		var events = MouseEvents.click(dispatcher);
		events.foreach(function(value) {
			called = true;
		});
		events.finish();

		dispatchEvent(MouseEventTypes.toString(Click));

		called.isFalse();
	}


	@Test
	public function mouseDown_event_is_dispatched() {
		var called = false;
		var events = MouseEvents.mouseDown(dispatcher);
		events.foreach(function(value) {
			called = true;
		});

		dispatchEvent(MouseEventTypes.toString(MouseDown));

		called.isTrue();
	}

	@Test
	public function mouseDown_listener_is_removed_after_dispatch() {
		var called = false;
		var events = MouseEvents.mouseDown(dispatcher);
		events.foreach(function(value) {
			called = true;
		});
		events.finish();

		dispatchEvent(MouseEventTypes.toString(MouseDown));

		called.isFalse();
	}

	
	@Test
	public function mouseOver_event_is_dispatched() {
		var called = false;
		var events = MouseEvents.mouseOver(dispatcher);
		events.foreach(function(value) {
			called = true;
		});

		dispatchEvent(MouseEventTypes.toString(MouseOver));

		called.isTrue();
	}

	@Test
	public function mouseOver_listener_is_removed_after_dispatch() {
		var called = false;
		var events = MouseEvents.mouseOver(dispatcher);
		events.foreach(function(value) {
			called = true;
		});
		events.finish();

		dispatchEvent(MouseEventTypes.toString(MouseOver));

		called.isFalse();
	}


	@Test
	public function mouseOut_event_is_dispatched() {
		var called = false;
		var events = MouseEvents.mouseOut(dispatcher);
		events.foreach(function(value) {
			called = true;
		});

		dispatchEvent(MouseEventTypes.toString(MouseOut));

		called.isTrue();
	}

	@Test
	public function mouseOut_listener_is_removed_after_dispatch() {
		var called = false;
		var events = MouseEvents.mouseOut(dispatcher);
		events.foreach(function(value) {
			called = true;
		});
		events.finish();

		dispatchEvent(MouseEventTypes.toString(MouseOut));

		called.isFalse();
	}


	@Test
	public function mouseMove_event_is_dispatched() {
		var called = false;
		var events = MouseEvents.mouseMove(dispatcher);
		events.foreach(function(value) {
			called = true;
		});

		dispatchEvent(MouseEventTypes.toString(MouseMove));

		called.isTrue();
	}

	@Test
	public function mouseMove_listener_is_removed_after_dispatch() {
		var called = false;
		var events = MouseEvents.mouseMove(dispatcher);
		events.foreach(function(value) {
			called = true;
		});
		events.finish();

		dispatchEvent(MouseEventTypes.toString(MouseMove));

		called.isFalse();
	}


	@Test
	public function mouseUp_event_is_dispatched() {
		var called = false;
		var events = MouseEvents.mouseUp(dispatcher);
		events.foreach(function(value) {
			called = true;
		});

		dispatchEvent(MouseEventTypes.toString(MouseUp));

		called.isTrue();
	}

	@Test
	public function mouseUp_listener_is_removed_after_dispatch() {
		var called = false;
		var events = MouseEvents.mouseUp(dispatcher);
		events.foreach(function(value) {
			called = true;
		});
		events.finish();

		dispatchEvent(MouseEventTypes.toString(MouseUp));

		called.isFalse();
	}


	override private function createEvent(value : String) {
		var event = null;

		#if js
		event = super.createEvent(value);
		#elseif flash9
		event = new MouseEvent(value);
		#end

		return event;
	}
}
#else
class MouseEventsTest {

}
#end
