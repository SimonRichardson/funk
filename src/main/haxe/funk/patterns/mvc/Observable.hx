package funk.patterns.mvc;

import funk.actors.Actor;

enum Observable<T> {
	AddListener(actor : Actor<T, T>);
	RemoveListener(actor : Actor<T, T>);
}
