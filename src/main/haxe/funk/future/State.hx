package funk.future;

import funk.Funk;
import funk.option.Option;

enum State<T> {
	Pending;
	Resolved(state : Option<T>);
	Rejected(error : Errors);
	Aborted;
}
