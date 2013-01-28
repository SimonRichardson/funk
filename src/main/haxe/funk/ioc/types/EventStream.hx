package funk.ioc.types;

import funk.reactive.Propagation;
import funk.reactive.Stream;

class EventStream<T> extends Stream<T> {

    public function new() {
        super(function(pulse) {
            return Propagate(pulse);
        });
    }
}
