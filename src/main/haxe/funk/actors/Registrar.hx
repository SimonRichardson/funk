package funk.actors;

import funk.collections.immutable.List;
import funk.types.Option;

using funk.collections.immutable.extensions.Lists;

class Registrar {

	private static var _actors : List<Actor<Dynamic>> = Nil;

	public static function add(actor : Actor<Dynamic>) : Void {
		_actors = _actors.prepend(actor);
	}

	public static function find(address : String) : Option<Actor<Dynamic>> {
		return _actors.find(function(actor) {
			return actor.address() == address;
		});
	}
}