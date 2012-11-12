package funk.future;

import funk.Funk;
import funk.either.Either;
import funk.errors.FunkError;
import funk.errors.NoSuchElementError;
import funk.option.Option;
import funk.reactive.Stream;
import funk.signal.Signal1;

using funk.either.Either;

class Future<T> {

	private var _state : State<T>;

	private var _stateStream : Stream<State<T>>;

	private var _progressStream : Stream<Float>;

	private var _then : Signal1<T>;

	private var _but : Signal1<FunkError>;

	private var _when : Signal1<IEither<FunkError, T>>;

	private var _progress : Signal1<Float>;

	public function new(	stateStream : Stream<State<T>>,
							progressStream : Stream<Float>,
							state : IOption<State<T>>) {
		_then = new Signal1<T>();
		_but = new Signal1<FunkError>();
		_when = new Signal1<IEither<FunkError, T>>();
		_progress = new Signal1<Float>();

		_state = state.get();

		_stateStream = stateStream;
		_stateStream.forEach(function(value) {
			_state = value;

			switch(value) {
				case Resolved(option):
					var v = option.get();

					_then.dispatch(v);
					_when.dispatch(Right(v).toInstance());
				case Rejected(error):
					_but.dispatch(error);
					_when.dispatch(Left(error).toInstance());
				case Aborted:
					_when.dispatch(Left(cast new NoSuchElementError()).toInstance());
				default:
			}
		});

		_progressStream = progressStream;
		_progressStream.forEach(function(value) {
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

	public function but(func : Function1<FunkError, Void>) : Future<T> {
		switch(_state){
			case Pending:
				_but.add(func);
			case Rejected(value):
				func(value);
			default:
		}
		return this;
	}

	public function when(func : Function1<IEither<FunkError, T>, Void>) : Future<T> {
		switch(_state){
			case Pending:
				_when.add(func);
			case Resolved(option):
				func(Right(option.get()).toInstance());
			case Rejected(value):
				func(Left(value).toInstance());
			default:
		}
		return this;
	}

	public function progress(func : Function1<Float, Void>) : Future<T> {
		_progress.add(func);
		return this;
	}
}
