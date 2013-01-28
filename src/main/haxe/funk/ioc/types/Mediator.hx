package funk.ioc.types;

import funk.ioc.types.EventStream;
import funk.types.Attempt;

using funk.types.extensions.Options;

class Mediator<T> {

    private var _events : EventStream<EnumValue>;

    public function new() {
        _events = cast Inject.as(EventStream).get();
    }

    public function handle(value : T) : Void {
    }

    public function dispatch(value : EnumValue) : Void {
        _events.dispatch(value);
    }

    public function events() : EventStream<EnumValue> {
        return _events;
    }
}
