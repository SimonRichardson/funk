package funk.actors.extensions;

import funk.collections.immutable.List;
import funk.actors.Header;
import funk.actors.Message;
import funk.types.Option;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;

class Messages {

	public static function sender<T>(message : Message<T>) : Option<String> {
		return headers(message).find(function (header : Header) {
			return switch(header) {
				case Origin(_): true;
				default: false;
			}
		}).flatMap(function (header : Header) {
			return switch(header) {
				case Origin(address): Some(address);
				default: None;
			}
		});
	}

	public static function headers<T>(message : Message<T>) : List<Header> {
		return Type.enumParameters(message)[0];
	}

	public static function body<T>(message : Message<T>) : T {
		return Type.enumParameters(message)[1];
	}
}
