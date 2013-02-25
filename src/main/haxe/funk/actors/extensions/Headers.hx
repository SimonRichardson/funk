package funk.actors.extensions;

import funk.actors.Header;
import funk.collections.immutable.List;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.EnumValues;
using funk.types.extensions.Options;

class Headers {

	public static function address(header : Header) : String {
		return switch(header) {
			case Origin(address): address;
			case Recipient(address): address;
		}
	}

	public static function invert(headers : List<Header>) : List<Header> {
		var origin = headers.find(function (header) {
			return header.equals(Origin(address(header)));
		});

		var recipient = headers.find(function (header) {
			return header.equals(Recipient(address(header)));
		});

		return if (origin.isDefined() && recipient.isDefined()) {
			var list = Nil;

			headers.foreach(function (header) {
				if (!(header.equals(origin.get()) || header.equals(recipient.get()))) {
					list = list.prepend(header);
				}
			});

			list = list.prepend(Origin(address(recipient.get())));
			list = list.prepend(Recipient(address(origin.get())));

			list;
		} else {
			headers;
		}
	}

	public static function path(from : Header, to : Header) : String {
		return '${address(to)}@${address(from)}';
	}
}
