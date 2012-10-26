package funk.future;

import funk.errors.FunkError;
import funk.option.Option;

enum State<T> {
	Pending;
	Resolved(option : Option<T>);
	Rejected(error : FunkError);
	Aborted;
}
