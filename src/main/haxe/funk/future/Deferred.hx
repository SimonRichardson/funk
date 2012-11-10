package funk.future;

import funk.either.Either;
import funk.errors.FunkError;
import funk.errors.NoSuchElementError;
import funk.option.Option;
import funk.reactive.Stream;
import funk.reactive.Streams;
import funk.reactive.StreamValues;

using funk.either.Either;
using funk.option.Option;

class Deferred<T> {

	private var _stateStream : Stream<State<T>>;

	private var _progressStream : Stream<Float>;

	private var _values : StreamValues<State<T>>;

	public function new() {
		_stateStream = Streams.identity();

		_progressStream = Streams.identity();

		_values = _stateStream.values();

		// Set-up of the state
		_stateStream.emit(Pending);
	}

	public function attempt() : IEither<FunkError, T> {
		var state = _values.last.get();
		return switch(state) {
			case Resolved(option):
				Right(option.get()).toInstance();
			case Rejected(error):
				Left(error).toInstance();
			default:
				Left(cast new NoSuchElementError()).toInstance();
		}
	}

	public function get() : IOption<T> {
		var state = _values.last.get();
		return switch(state) {
			case Resolved(option):
				option;
			default:
				None.toInstance();
		};
	}

	public function progress(value : Float) : Void {
		var state = _values.last.get();
		switch(state) {
			case Pending:
				_progressStream.emit(value);
			default:
		}
	}

	public function resolve(value : T) : Void {
		switch(_values.last.toOption()) {
			case Some(state):
				switch(state) {
					case Pending:
						_stateStream.emit(Resolved(Some(value).toInstance()));
					default:
						// TODO (Simon) : Throw an error?
				}
			case None:
				// TODO (Simon) : Throw an error?
		}
	}

	public function reject(error : FunkError) : Void {
		switch(_values.last.toOption()) {
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
		return new Future<T>(_stateStream, _progressStream, _values.last);
	}

	public function values() : StreamValues<T> {
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
