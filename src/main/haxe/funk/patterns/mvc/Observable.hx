package funk.patterns.mvc;

import funk.actors.Actor;

enum Observable<T> {
	AddListener(actor : Actor<EnumValue, T>);
	RemoveListener(actor : Actor<EnumValue, T>);
}
