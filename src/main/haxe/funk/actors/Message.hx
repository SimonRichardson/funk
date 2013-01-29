package funk.actors;

import funk.collections.immutable.List;

enum Message<T> {
    Empty;
	Message(header : List<Header>, body : T);
}
