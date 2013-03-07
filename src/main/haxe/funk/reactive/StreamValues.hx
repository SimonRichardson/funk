package funk.reactive;

import funk.reactive.Pulse;
import funk.reactive.Propagation;
import funk.reactive.Stream;
import funk.types.Function0;

using funk.collections.immutable.List;
using funk.types.Option;

class StreamValues<T> {

    private var _lazyOption : Option<Function0<List<T>>>;

    public function new(lazyOption : Option<Function0<List<T>>>) {
        _lazyOption = lazyOption;
    }

    public function iterator() : Iterator<T> {
        return getList().iterator();
    }

    public function size() : Int {
        return getList().size();
    }

    inline private function getList() : Function0<List<T>> {
        return _lazyOption.getOrElse(function() {
            return function() {
                return Nil;
            }
        });
    }
}
