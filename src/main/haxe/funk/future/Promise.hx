package funk.future;

import funk.reactive.Stream;

class Promise<T> {

	private var _stream : Stream<State<T>>;

	public function new(stream : Stream<State<T>>) {
		_stream = stream;
	}
}
