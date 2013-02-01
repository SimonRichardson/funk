package funk.actors;

import funk.types.Either;
import funk.types.Option;
import massive.munit.Assert;
import unit.Asserts;

using funk.actors.extensions.Actors;
using funk.actors.extensions.Messages;
using funk.types.extensions.Options;
using massive.munit.Assert;
using unit.Asserts;

class ActorTest {

	@Test
	public function hello() : Void {
		var actor = new Actor();
		actor.dispatch("Hello").then(function(message) {
			if (message.body().get() == "Hello") {
				actor.send("World").toAddress(message.sender().get()).then(function (message) {

				});
			}
		});
	}

	@Test
	public function sending_Float_to_String_actor__should_return_a_string() {
		var actor1 : Actor<Float> = new Actor<Float>();
		var actor2 : Actor<String> = new Actor<String>();

		var expected = '123';
		var actual = '';
		actor1.send(123).to(Some(actor2)).then(function(message) {
			actual = message.body().get();
		});

		actual.areEqual(expected);
	}
}
