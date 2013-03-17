package suites;

import massive.munit.TestSuite;

import funk.signals.Slot0Test;
import funk.signals.Slot1Test;
import funk.signals.Slot2Test;
import funk.signals.Slot3Test;
import funk.signals.Slot4Test;
import funk.signals.Slot5Test;
import funk.signals.Signal0Test;
import funk.signals.Signal1Test;
import funk.signals.Signal2Test;
import funk.signals.Signal3Test;
import funk.signals.Signal4Test;
import funk.signals.Signal5Test;
import funk.signals.PrioritySignal0Test;
import funk.signals.PrioritySignal1Test;
import funk.signals.PrioritySignal2Test;
import funk.signals.PrioritySignal3Test;
import funk.signals.PrioritySignal4Test;
import funk.signals.PrioritySignal5Test;

class SignalsSuite extends TestSuite {

    public function new() {
        super();

        add(funk.signals.Slot0Test);
        add(funk.signals.Slot1Test);
        add(funk.signals.Slot2Test);
        add(funk.signals.Slot3Test);
        add(funk.signals.Slot4Test);
        add(funk.signals.Slot5Test);

        add(funk.signals.Signal0Test);
        add(funk.signals.Signal1Test);
        add(funk.signals.Signal2Test);
        add(funk.signals.Signal3Test);
        add(funk.signals.Signal4Test);
        add(funk.signals.Signal5Test);

        add(funk.signals.PrioritySignal0Test);
        add(funk.signals.PrioritySignal1Test);
        add(funk.signals.PrioritySignal2Test);
        add(funk.signals.PrioritySignal3Test);
        add(funk.signals.PrioritySignal4Test);
        add(funk.signals.PrioritySignal5Test);
    }
}
