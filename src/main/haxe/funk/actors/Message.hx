package funk.actors;

import funk.collections.immutable.List;
import haxe.ds.Option;
import funk.types.Tuple2;

typedef Message<T> = Tuple2<List<Header>, Option<T>>;
