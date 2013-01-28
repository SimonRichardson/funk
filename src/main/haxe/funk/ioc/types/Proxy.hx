package funk.ioc.types;

import funk.ioc.types.EventStream;
import funk.types.Attempt;

using funk.types.extensions.Options;

class Proxy<T> {

    private var _events : EventStream<EnumValue>;

    public function new() {
        _events = cast Inject.as(EventStream).get();
    }

    public function dispatch(value : EnumValue) : Void {
        _events.dispatch(value);
    }
}
