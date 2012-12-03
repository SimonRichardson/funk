package funk.reactive;

import funk.reactive.Pulse;
import funk.reactive.Propagation;
import funk.reactive.Stream;
import funk.signal.Signal0;
import funk.types.Function1;

class StreamValues<T> {

    private var _list : List<T>;

    public function new(signal : Option<Signal1<T>>) {

        _list = Nil;

        signal.foreach(function(s) {
            s.add(function(value : T) {
                _list = _list.append(value);
            });

            return s;
        }
    }

    public function iterator() : Iterator<T> {
        return _list.iterator();
    }

    public function size() : Int { 
        return _list.size();
    }
}