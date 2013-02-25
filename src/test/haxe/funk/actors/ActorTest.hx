package funk.actors;

import funk.types.Either;
import haxe.ds.Option;
import massive.munit.Assert;
import unit.Asserts;

using funk.actors.extensions.Actors;
using funk.actors.extensions.Messages;
using funk.types.extensions.Options;
using massive.munit.Assert;
using unit.Asserts;

class ActorTest {

	@Test
	public function sending_a_value__should_send_correct_result() : Void {
		var actor = new Actor();

		var expected = 'Hello';
		var actual = '';

		actor.dispatch(expected).then(function(message) {
			actual = message.body().get();
		});

		actual.areEqual(expected);
	}

	@Test
	public function sending_a_response_to_sender__should_send_correct_result() : Void {
		var actor = new Actor();

		var expected = 'World';
		var actual = '';

		actor.dispatch('Hello').then(function(message) {
			if (message.body().get() == 'Hello') {
				actor.send(expected).toAddress(message.sender().get()).then(function (message) {
					actual = message.body().get();
				});
			}
		});

		actual.areEqual(expected);
	}

	@Test
	public function sending_Float_to_String_actor__should_return_a_string() {
		var actor1 : Actor<Float> = new Actor<Float>();
		var actor2 : Actor<String> = new Actor<String>();

		var expected = '123.01';
		var actual = '';

		actor1.send(123.01).to(Some(actor2)).then(function(message) {
			actual = Std.string(message.body().get());
		});

		actual.areEqual(expected);
	}
}
