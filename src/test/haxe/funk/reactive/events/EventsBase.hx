package funk.reactive.events;

using funk.reactive.Stream;
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
class EventsBase {

	private var dispatcher : EventDispatcher;

	@Before
	public function setup() {
		#if js
		dispatcher = Browser.document.createDivElement();
		#elseif flash9
		dispatcher = new EventDispatcher();
		#end
	}

	private function dispatchEvent(value : String) {
		dispatcher.dispatchEvent(createEvent(value));
	}

	private function createEvent(value : String) {
		var event = null;

		#if js
		event = Browser.document.createEvent("Event");
		event.initEvent(value, false, false);
		#elseif flash9
		event = new Event(value);
		#end

		return event;
	}
}
#end
