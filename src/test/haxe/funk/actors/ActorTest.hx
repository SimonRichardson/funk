package funk.actors;

import funk.actors.types.UrlActor;
import funk.types.Either;
import funk.types.Option;
import massive.munit.Assert;
import unit.Asserts;

using funk.actors.extensions.Messages;
using funk.types.extensions.Options;
using massive.munit.Assert;
using unit.Asserts;

class ActorTest {

	@Test
	public function hello() : Void {
		var actor = new Actor();
		actor.send("Hello").to(actor.toOption()).then(function(message) {
			trace(message);

			if (message.body() == "Hello") {
				actor.send("World").toAddress(message.sender().get()).then(function (message) {
					
					trace(message);
				});
			}
		});
	}
}
