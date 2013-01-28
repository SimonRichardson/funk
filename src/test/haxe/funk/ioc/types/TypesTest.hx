package funk.ioc.types;

import funk.ioc.Injector;
import funk.ioc.types.Command;
import funk.ioc.types.Facade;

using funk.types.extensions.Attempts;

class TypesTest {

    @Test
    public function test() : Void {
        Injector.initialize();

        var facade : Facade = cast Injector.add(new Facade());
        facade.construct();

        facade.addCommand("Trace", TraceCommand);

        facade.dispatch("Trace", "Hello, World!");
    }
}

private class TraceCommand extends Command<String> {

    public function new() {
        super();
    }

    override public function execute(value : String) : Void {
        trace(value);
    }
}
