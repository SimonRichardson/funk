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

	private var _stream : Stream<State<T>>;

	private var _values : StreamValues<State<T>>;

	public function new() {
		_stream = Streams.identity();
		_values = _stream.values();
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

	public function resolve(value : T) : Void {
		switch(_values.last.toOption()) {
			case Some(state):
				switch(state) {
					case Pending:
						_stream.emit(Resolved(Some(value).toInstance()));
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
						_stream.emit(Rejected(error));
					default:
						// TODO (Simon) : Throw an error?
				}
			case None:
				// TODO (Simon) : Throw an error?
		}
	}

	public function abort() : Void {
		_stream.emit(Aborted);
	}

	public function promise() : Promise<T> {
		return new Promise<T>(_stream);
	}

	public function values() : StreamValues<Null<T>> {
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
		});
	}
}
