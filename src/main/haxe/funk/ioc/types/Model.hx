package funk.ioc.types;

import funk.ioc.Module;
import funk.ioc.types.Command;
import funk.ioc.types.EventStream;
import funk.types.Attempt;
import funk.types.Tuple2;

using funk.reactive.extensions.Streams;
using funk.types.extensions.Enums;
using funk.types.extensions.EnumValues;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

class Model extends Module {

    private var _events : EventStream<EnumValue>;

    public function new() {
        super();
    }

    override public function configure() : Void {
    }

    public function construct() : Void {
        _events = cast Inject.as(EventStream).get();
    }

    public function add<T>(type : Class<Proxy<T>>) : Void {
        bind(type);
    }
}
