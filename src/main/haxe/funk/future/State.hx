package funk.future;

import funk.errors.FunkError;

enum State<T> {
	Pending;
	Resolved(option : IOption<T>);
	Rejected(error : FunkError);
	Aborted;
}
