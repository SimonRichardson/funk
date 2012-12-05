package funk.reactive;

import funk.collections.immutable.List;
import funk.collections.immutable.extensions.Lists;
import funk.reactive.Pulse;
import funk.reactive.Propagation;
import funk.reactive.Stream;
import funk.signal.Signal0;
import funk.types.Function1;
import funk.types.Option;
import funk.types.extensions.Options;
import funk.signal.Signal1;

using funk.collections.immutable.extensions.Lists;
using funk.types.extensions.Options;

class StreamValues<T> {

    private var _list : List<T>;

    public function new(signal : Option<Signal1<T>>) {

        _list = Nil;

        signal.foreach(function(s) {
            s.add(function(value : T) {
                _list = _list.append(value);
            });
        });
    }

    public function iterator() : Iterator<T> {
        return _list.iterator();
    }

    public function size() : Int {
        return _list.size();
    }
}
