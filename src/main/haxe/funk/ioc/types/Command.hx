package funk.ioc.types;

import funk.types.Attempt;

using funk.types.extensions.Options;

class Command<T> {

    private var _events : EventStream<Dynamic>;

    public function new() {
        _events = Inject.as(EventStream).get();
    }

    public function guard(value : T) : Attempt<T> {
        return Success(value);
    }

    public function execute(value : T) : Void {
    }
}
