package funk.actors;

import funk.collections.immutable.List;

enum Message<T> {
	Message(header : List<Header>, body : T);
}