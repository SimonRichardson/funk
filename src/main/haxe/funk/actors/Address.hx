package funk.actors;

using funk.types.Option;

enum Address {
	Address(protocol : String, system : String, host : Option<String>, port : Option<Int>);
}

class AddressTypes {

	public static function hostPort(address : Address) : String {
		return switch(address) {
			case Address(protocol, system, host, port): 
				var sb = new StringBuf();
				sb.append(system);
				if(host.isDefined()) {
					sb.append("@");
					sb.append(host.get());
				}
				if (port.isDefined()) {
					sb.append(":");
					sb.append(port.get());
				}
				sb.toString();
		}
	}

	public static function toString(address : Address) : String {
		return switch(address) {
			case Address(protocol, system, host, port): 
				var sb = new StringBuf();
				sb.append(protocol);
				sb.append("://");
				sb.append(hostPort(address));
				sb.toString();
		}
	}
}