package funk.ioc.types;

import funk.ioc.Module;
import funk.ioc.types.Command;
import funk.types.Attempt;
import funk.types.Tuple2;

using funk.reactive.extensions.Streams;
using funk.types.extensions.Enums;
using funk.types.extensions.EnumValues;
using funk.types.extensions.Options;
using funk.types.extensions.Tuples2;

class Controller extends Module {

    private var _events : EventStream<EnumValue>;

    public function new() {
        super();
    }

    override public function configure() : Void {
    }

    public function construct() : Void {
        _events = cast Inject.as(EventStream).get();

        _events.foreach(function (event : EnumValue) {
            var parent = event.getEnum();
            var bindable = findByBoundTo(event, function(a : Enum<Dynamic>, b : EnumValue) {
                return a == parent;
            });

            switch(bindable) {
                case Some(tuple):
                    // Get the bounded object.
                    switch(Inject.as(tuple._1())) {
                        case Some(command):
                            // Make sure we only execute on a valid command
                            switch(command.guard(event)) {
                                case Success(_): command.execute(event);
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
