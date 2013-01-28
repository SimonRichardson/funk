package funk.ioc.types;

import funk.ioc.Inject;
import funk.ioc.Module;
import funk.ioc.types.Command;
import funk.ioc.types.Controller;
import funk.types.Attempt;
import funk.types.Tuple2;

using funk.types.extensions.Options;

class Facade extends Module {

    private var _events : EventStream<Dynamic>;

    private var _controller : Controller;

    public function new() {
        super();
    }

    override public function configure() : Void {
        bind(EventStream).asSingleton();
        bind(Controller).asSingleton();
    }

    public function construct() : Void {
        _events = Inject.as(EventStream).get();

        _controller = cast Injector.add(Inject.as(Controller).get());
        _controller.construct();
    }

    public function addCommand<T1, T2>(value : Enum<T1>, type : Class<Command<T2>>) : Void {
        _controller.add(value, type);
    }

    public function dispatch(value : EnumValue) : Void {
        _events.dispatch(value);
    }
}
