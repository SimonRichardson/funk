package funk.future;

import funk.Funk;
import funk.reactive.Stream;
import funk.reactive.StreamValues;
import funk.reactive.extensions.Streams;
import funk.types.Either;
import funk.types.Option;
import funk.types.extensions.Options;

using funk.types.extensions.Options;

class Deferred<T> {

	private var _stateStream : Stream<State<T>>;

	private var _progressStream : Stream<Float>;

	private var _values : Collection<State<T>>;

	public function new() {
		_stateStream = Streams.identity(None);

		_progressStream = Streams.identity(None);

		_values = _stateStream.values();

		// Set-up of the state
		_stateStream.emit(Pending);
	}

	public function attempt() : Either<Errors, T> {
		var state = _values.last().get();
		return switch(state) {
			case Resolved(option):
				Right(option.get());
			case Rejected(error):
				Left(error);
			default:
				Left(Errors.NoSuchElementError);
		}
	}

	public function get() : Option<T> {
		var state = _values.last().get();
		return switch(state) {
			case Resolved(option):
				option;
			default:
				None;
		};
	}

	public function progress(value : Float) : Void {
		var state = _values.last().get();
		switch(state) {
			case Pending:
				_progressStream.emit(value);
			default:
		}
	}

	public function resolve(value : T) : Void {
		switch(_values.last().toOption()) {
			case Some(state):
				switch(state) {
					case Pending:
						_stateStream.emit(Resolved(Some(value)));
					default:
						// TODO (Simon) : Throw an error?
				}
			case None:
				// TODO (Simon) : Throw an error?
		}
	}

	public function reject(error : Errors) : Void {
		switch(_values.last().toOption()) {
			case Some(state):
				switch(state) {
					case Pending:
						_stateStream.emit(Rejected(error));
					default:
						// TODO (Simon) : Throw an error?
				}
			case None:
				// TODO (Simon) : Throw an error?
		}
	}

	public function abort() : Void {
		_stateStream.emit(Aborted);
	}

	public function future() : Future<T> {
		return new Future<T>(_stateStream, _progressStream, _values.last());
	}

	public function values() : Collection<T> {
		return cast _values.map(function(state) {
			return switch(state){
				case Resolved(option):
					option.get();
				default:
					null;
			};
		}).filter(function(value) {
			return value != null;
		});
	}
}
