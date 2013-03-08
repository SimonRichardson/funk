package suites;

import massive.munit.TestSuite;

import funk.reactives.CollectionTest;
import funk.reactives.StreamTest;
import funk.reactives.StreamTypesTest;
import funk.reactives.StreamValuesTest;

import funk.reactives.events.EventsTest;
import funk.reactives.events.KeyboardEventsTest;
import funk.reactives.events.MouseEventsTest;
import funk.reactives.events.RenderEventsTest;

class ReactivesSuite extends TestSuite {

	public function new() {
		super();

		add(funk.reactives.CollectionTest);
		add(funk.reactives.StreamTest);
		add(funk.reactives.StreamTypesTest);
		add(funk.reactives.StreamValuesTest);

		add(funk.reactives.events.EventsTest);
		add(funk.reactives.events.KeyboardEventsTest);
		add(funk.reactives.events.MouseEventsTest);
		add(funk.reactives.events.RenderEventsTest);
	}
}
