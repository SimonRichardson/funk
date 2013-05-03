package suites;

import massive.munit.TestSuite;

import funk.arrows.ArrowTest;

import funk.io.logging.Log;
import funk.io.logging.outputs.TraceOutput;

class ArrowsSuite extends TestSuite {

    public function new() {
        super();

        var output = new TraceOutput();
        output.add(Log.init().streamOut());

        add(funk.arrows.ArrowTest);
    }
}
