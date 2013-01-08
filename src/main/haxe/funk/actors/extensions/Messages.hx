package funk.actors.extensions;

import funk.collections.immutable.List;
import funk.actors.Header;
import funk.actors.Message;
import funk.types.Function1;
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

	public static function map<T1, T2>(	message : Message<T1>, 
										func : Function1<Message<T1>, Message<T2>>
										) : Message<T2> {
		return func(message);
	}

	public static function clone<T1, T2>(message : Message<T1>) : Message<T2> {
		var list = Nil;

		headers(message).foreach(function (header) {
			list = list.prepend(switch(header) {
				case Origin(address): Origin(address);
				case Recipient(address): Recipient(address);
			});
		});

		return Message(list, cast body(message));
	}
}
