package funk.patterns.mvc;

import funk.actors.Actor;

enum Observable<T, K> {
	AddListener(actor : Actor<T, K>);
	RemoveListener(actor : Actor<T, K>);
}
