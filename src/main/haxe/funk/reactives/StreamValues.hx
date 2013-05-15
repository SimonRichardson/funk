package funk.reactives;

import funk.reactives.Pulse;
import funk.reactives.Propagation;
import funk.reactives.Stream;
import funk.types.Function0;

using funk.ds.immutable.List;
using funk.types.Option;

class StreamValues<T> {

    private var _lazyOption : Option<Function0<List<T>>>;

    public function new(lazyOption : Option<Function0<List<T>>>) {
        _lazyOption = lazyOption;
    }

    public function iterator() : Iterator<T> return getList().iterator();

    public function size() : Int return getList().size();

    inline private function getList() : List<T> return _lazyOption.getOrElse(function() return function() return Nil)();
}
