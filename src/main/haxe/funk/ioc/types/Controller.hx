package funk.ioc.types;

import funk.ioc.Module;
import funk.ioc.types.Command;
import funk.types.Attempt;
import funk.types.Tuple2;

using funk.reactive.extensions.Streams;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

class Controller extends Module {

    private var _events : EventStream<Dynamic>;

    public function new() {
        super();
    }

    override public function configure() : Void {
    }

    public function construct() : Void {
        _events = Inject.as(EventStream).get();
        _events.foreach(function (event : Tuple2<Dynamic, Dynamic>) {
            switch(findByBoundTo(event._1())) {
                case Some(tuple):
                    switch(Inject.as(tuple._1())) {
                        case Some(command):
                            // Make sure we only execute on a valid command
                            var value = event._2();
                            switch(command.guard(value)) {
                                case Success(_): command.execute(value);
                                case Failure(_):
                            }
                        case None:
                    }
                case None:
            }
        });
    }

    public function add<T1, T2>(value : T1, type : Class<Command<T2>>) : Void {
        var binding : Binding<Dynamic, Dynamic> = bind(type);
        binding.boundTo = value;
    }
}
