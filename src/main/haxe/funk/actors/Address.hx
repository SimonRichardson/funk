package funk.actors;

using funk.types.Option;

enum AddressType {
    Address(protocol : String, system : String, host : Option<String>, port : Option<Int>);
}

class AddressTypes {

    public static function hostPort(address : AddressType) : String {
        return switch(address) {
            case Address(_, system, host, port):
                var sb = new StringBuf();
                sb.add(system);
                if(host.isDefined()) {
                    sb.add("@");
                    sb.add(host.get());
                }
                if (port.isDefined()) {
                    sb.add(":");
                    sb.add(port.get());
                }
                sb.toString();
        }
    }

    public static function toString(address : AddressType) : String {
        return switch(address) {
            case Address(protocol, _, _, _):
                var sb = new StringBuf();
                sb.add(protocol);
                sb.add("://");
                sb.add(hostPort(address));
                sb.toString();
        }
    }
}
