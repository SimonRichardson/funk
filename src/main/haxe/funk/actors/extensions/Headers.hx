package funk.actors.extensions;

class Headers {

	public static function address(header : Header) : String {
		return switch(header) {
			case Origin(address): address;
			case Recipient(address): address;
		}
	}

	public static function path(from : Header, to : Header) : String {
		return Std.format("${address(to)}@${address(from)}");
	}
}