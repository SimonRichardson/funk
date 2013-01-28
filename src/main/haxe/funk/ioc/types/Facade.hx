package funk.ioc.types;

import funk.ioc.Inject;
import funk.ioc.Injector;
import funk.ioc.Module;
import funk.ioc.types.Command;
import funk.ioc.types.Controller;
import funk.ioc.types.EventStream;
import funk.ioc.types.Model;
import funk.types.Attempt;
import funk.types.Tuple2;

using funk.types.extensions.Options;

class Facade extends Module {

    private var _events : EventStream<EnumValue>;

    private var _controller : Controller;

    private var _model : Model;

    public function new() {
        super();
    }

    override public function configure() : Void {
        bind(EventStream).asSingleton();
        bind(Controller).asSingleton();
        bind(Model).asSingleton();
    }

    public function construct() : Void {
        _events = cast Inject.as(EventStream).get();

        _controller = cast Injector.add(Inject.as(Controller).get());
        _controller.construct();

        _model = cast Injector.add(Inject.as(Model).get());
        _model.construct();
    }

    public function addCommand<T1, T2>(value : Enum<T1>, type : Class<Command<T2>>) : Void {
        _controller.add(value, type);
    }

    public function addProxy<T>(type : Class<Proxy<T>>) : Void {
        _model.add(type);
    }

    public function dispatch(value : EnumValue) : Void {
        _events.dispatch(value);
    }
}
