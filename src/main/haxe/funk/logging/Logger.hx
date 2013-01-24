package funk.logging;

import funk.logging.Log;
import funk.logging.LogLevel;
import funk.reactive.Stream;

using funk.collections.extensions.CollectionsUtil;
using funk.reactive.extensions.Streams;

class Logger<T> {

	private var _tag : Tag;

	private var _streamIn : Stream<LogLevel<T>>;

	private var _streamOut : Stream<Message<T>>;

	public function new(tag : Tag) {
		_tag = tag;

		_streamIn = Streams.identity(None);
		_streamOut = Streams.identity(None);

		init();
	}

	@:overridable
	private function init() : Void {
		function (value : LogLevel<T>) {
			// TODO (Simon) : It should be possible to intercept this and then map the value.
			streamOut().dispatch(Message(tag(), value));
		}.bind(streamIn());
	}

	public function tag() : Tag {
		return _tag;
	}

	public function streamIn() : Stream<LogLevel<T>> {
		return _streamIn;
	}

	public function streamOut() : Stream<Message<T>> {
		return _streamOut;
	}
}
