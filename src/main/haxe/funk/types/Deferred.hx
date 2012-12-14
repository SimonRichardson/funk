package funk.types;

import funk.Funk;
import funk.collections.Collection;
import funk.collections.extensions.Collections;
import funk.reactive.Stream;
import funk.reactive.StreamValues;
import funk.reactive.extensions.Streams;
import funk.signals.Signal1;
import funk.types.Either;
import funk.types.Option;
import funk.types.extensions.Options;

using funk.collections.extensions.Collections;
using funk.reactive.extensions.Streams;
using funk.types.extensions.Options;

enum State<T> {
	Pending;
	Resolved(state : Option<T>);
	Rejected(error : Errors);
	Aborted;
}

class Deferred<T> {

	private var _stateStream : Stream<State<T>>;

	private var _progressStream : Stream<Float>;

	private var _values : Collection<State<T>>;

	public function new() {
		_stateStream = Streams.identity(None);

		_progressStream = Streams.identity(None);

		_values = _stateStream.values();

		// Set-up for the state
		_stateStream.emit(Pending);
	}

	public function attempt() : Either<Errors, T> {
		return switch(_values.last()) {
			case Some(state):
				switch(state) {
					case Resolved(option):
						Right(option.get());
					case Rejected(error):
						Left(error);
					default:
						Left(Errors.NoSuchElementError);
				}
			case None:
				Left(Errors.NoSuchElementError);
		}
	}

	public function get() : Option<T> {
		return switch(_values.last()) {
			case Some(state):
				switch(state) {
					case Resolved(option):
						option;
					default:
						None;
				}
			case None:
		};
	}

	public function progress(value : Float) : Void {
		switch (_values.last()) {
			case Some(state):
				switch(state) {
					case Pending:
						_progressStream.emit(value);
					default:
						throw Errors.IllegalOperationError('Invalid state');
				}
			case None:
				throw Errors.IllegalOperationError('Invalid value');
		}
	}

	public function resolve(value : T) : Void {
		switch(_values.last()) {
			case Some(state):
				switch(state) {
					case Pending:
						_stateStream.emit(Resolved(Some(value)));
					default:
						throw Errors.IllegalOperationError('Invalid state');
				}
			case None:
				throw Errors.IllegalOperationError('Invalid value');
		}
	}

	public function reject(error : Errors) : Void {
		switch(_values.last()) {
			case Some(state):
				switch(state) {
					case Pending:
						_stateStream.emit(Rejected(error));
					default:
						throw Errors.IllegalOperationError('Invalid state');
				}
			case None:
				throw Errors.IllegalOperationError('Invalid value');
		}
	}

	public function abort() : Void {
		_stateStream.emit(Aborted);
	}

	public function future() : Future<T> {
		return new FutureImpl<T>(_stateStream, _progressStream, _values.last());
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

private class FutureImpl<T> {

	private var _state : State<T>;

	private var _stateStream : Stream<State<T>>;

	private var _progressStream : Stream<Float>;

	private var _then : Signal1<T>;

	private var _but : Signal1<Errors>;

	private var _when : Signal1<Either<Errors, T>>;

	private var _progress : Signal1<Float>;

	public function new(	stateStream : Stream<State<T>>,
							progressStream : Stream<Float>,
							state : Option<State<T>>) {
		_then = new Signal1<T>();
		_but = new Signal1<Errors>();
		_when = new Signal1<Either<Errors, T>>();
		_progress = new Signal1<Float>();

		_state = state.get();

		_stateStream = stateStream;
		_stateStream.foreach(function(value) {
			_state = value;

			switch(value) {
				case Resolved(option):
					var v = option.get();

					_then.dispatch(v);
					_when.dispatch(Right(v));
				case Rejected(error):
					_but.dispatch(error);
					_when.dispatch(Left(error));
				case Aborted:
					_when.dispatch(Left(Errors.NoSuchElementError));
				default:
			}
		});

		_progressStream = progressStream;
		_progressStream.foreach(function(value) {
			_progress.dispatch(value);
		});
	}

	public function then(func : Function1<T, Void>) : Future<T> {
		switch(_state){
			case Pending:
				_then.add(func);
			case Resolved(option):
				func(option.get());
			default:
		}
		return this;
	}

	public function but(func : Function1<Errors, Void>) : Future<T> {
		switch(_state){
			case Pending:
				_but.add(func);
			case Rejected(value):
				func(value);
			default:
		}
		return this;
	}

	public function when(func : Function1<Either<Errors, T>, Void>) : Future<T> {
		switch(_state){
			case Pending:
				_when.add(func);
			case Resolved(option):
				func(Right(option.get()));
			case Rejected(value):
				func(Left(value));
			default:
		}
		return this;
	}

	public function progress(func : Function1<Float, Void>) : Future<T> {
		_progress.add(func);
		return this;
	}
}

