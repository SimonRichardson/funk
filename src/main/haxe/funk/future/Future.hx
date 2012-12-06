package funk.future;

import funk.Funk;
import funk.reactive.Stream;
import funk.signal.Signal1;
import funk.types.Either;
import funk.types.Option;
import funk.types.extensions.Options;

using funk.types.Either;
using funk.types.extensions.Options;

class Future<T> {

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
