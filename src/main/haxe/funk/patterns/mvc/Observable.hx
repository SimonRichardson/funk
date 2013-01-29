package funk.patterns.mvc;

enum Observable<T1, T2> {
	AddListener(actor : Actor<T1, T2>);
	RemoveListener(actor : Actor<T1, T2>);
}