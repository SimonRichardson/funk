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
		return switch(_values.last.toOption()) {
			case Some(state):

				switch(state) {
					case Resolved(option):

						switch(option.toOption()) {
							case Some(value):
								Right(value).toInstance();
							case None:
								Right(null).toInstance();
						}

					case Rejected(error):
						Left(error).toInstance();
					default:
						Left(cast new NoSuchElementError()).toInstance();
				}

			case None:
				Left(cast new NoSuchElementError()).toInstance();
		}
	}

	public function get() : IOption<T> {
		return switch(_values.last.toOption()) {
			case Some(state):
				switch(state) {
					case Resolved(option):
						option;
					default:
						None.toInstance();
				}
			case None:
				None.toInstance();
		}
	}

	public function progress(value : Float) : Void {
		switch(_values.last.toOption()){
			case Some(state):
				switch(state) {
					case Pending:
						_progressStream.emit(value);
					default:
				}
			case None:
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

	public function promise() : Promise<T> {
		return new Promise<T>(_stateStream, _progressStream, _values.last);
	}

	public function values() : StreamValues<T> {
		return _values.map(function(state) {
			return switch(state){
				case Resolved(option):
					switch(option.toOption()) {
						case Some(value):
							value;
						case None:
							null;
					}
				default:
					null;
			};
		}).filter(function(value) {
			return value != null;
		});
	}
}
