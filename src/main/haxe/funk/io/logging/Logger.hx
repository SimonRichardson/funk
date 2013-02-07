package funk.io.logging;

import funk.io.logging.Log;
import funk.io.logging.LogLevel;
import funk.reactive.Stream;

using funk.collections.extensions.CollectionsUtil;
using funk.io.logging.extensions.LogLevels;
using funk.reactive.extensions.Streams;

class Logger<T> {

	public var logLevel(get_logLevel, set_logLevel) : Int;

	private var _tag : Tag;

	private var _streamIn : Stream<LogLevel<T>>;

	private var _streamOut : Stream<Message<T>>;

	private var _logLevel : Int;

	public function new(tag : Tag) {
		_tag = tag;
		_logLevel = 1;

		_streamIn = Streams.identity(None);
		_streamOut = Streams.identity(None);

		init();
	}

	@:overridable
	private function init() : Void {
		function (value : LogLevel<T>) {
			// TODO (Simon) : It should be possible to intercept this and then map the value.
			if (value.bit() >= logLevel) {
				streamOut().dispatch(Message(tag(), value));
			}
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

	private function get_logLevel() : Int {
		return _logLevel;
	}

	private function set_logLevel(value : Int) : Int {
		_logLevel = value;
		return _logLevel;
	}
}
