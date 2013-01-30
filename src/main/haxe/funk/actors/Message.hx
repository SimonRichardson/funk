package funk.actors;

import funk.collections.immutable.List;
import funk.types.Option;
import funk.types.Tuple2;

typedef Message<T> = Tuple2<List<Header>, Option<T>>;
