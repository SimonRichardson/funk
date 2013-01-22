package funk.logging;

import funk.logging.Log;
import funk.reactive.Stream;

using funk.collections.extensions.CollectionsUtil;
using funk.reactive.extensions.Streams;

class Logger {

	private var _category : Category;

	private var _streamIn : Stream<Dynamic>;

	private var _streamOut : Stream<Dynamic>;

	public function new(category : Category) {
		_category = category;

		_streamIn = Streams.identity(None);
		_streamOut = Streams.identity(None);

		_streamIn.attach(_streamOut);
	}

	public function streamIn() : Stream<Dynamic> {
		return _streamIn;
	}

	public function streamOut() : Stream<Dynamic> {
		return _streamOut;
	}
}