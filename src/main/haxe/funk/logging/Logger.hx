package funk.logging;

import funk.logging.Log;
import funk.logging.LogLevel;
import funk.reactive.Stream;

using funk.collections.extensions.CollectionsUtil;
using funk.reactive.extensions.Streams;

class Logger<T> {

	private var _category : Category;

	private var _streamIn : Stream<LogLevel<T>>;

	private var _streamOut : Stream<Message<T>>;

	public function new(category : Category) {
		_category = category;

		_streamIn = Streams.identity(None);
		_streamOut = Streams.identity(None);

		function (value : LogLevel<T>) {
			// TODO (Simon) : It should be possible to intercept this and then map the value.
			_streamOut.emit(Message(category, value));
		}.bind(_streamIn);
	}

	public function streamIn() : Stream<LogLevel<T>> {
		return _streamIn;
	}

	public function streamOut() : Stream<Message<T>> {
		return _streamOut;
	}
}
