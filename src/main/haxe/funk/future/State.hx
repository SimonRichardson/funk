package funk.future;

import funk.errors.FunkError;
import funk.option.Option;

enum State<T> {
	Pending;
	Resolved(state : IOption<T>);
	Rejected(error : FunkError);
	Aborted;
}
