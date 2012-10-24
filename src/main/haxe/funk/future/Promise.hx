package funk.future;

import funk.either.Either;
import funk.errors.FunkError;
import funk.errors.NoSuchElementError;
import funk.option.Option;
import funk.reactive.Stream;
import funk.signal.Signal1;

class Promise<T> {

	private var _state : State<T>;

	private var _stream : Stream<State<T>>;

	private var _then : Signal1<T>;

	private var _but : Signal1<FunkError>;

	private var _when : Signal1<Either<FunkError, T>>;

	public function new(stream : Stream<State<T>>, state : IOption<State<T>>) {
		_then = new Signal1<T>();
		_but = new Signal1<FunkError>();
		_when = new Signal1<Either<FunkError, T>>();

		switch(state.toOption()) {
			case Some(value):
				_state = value;
			case None:
				_state = Aborted;
		}

		_stream = stream;
		_stream.forEach(function(value) {
			_state = value;

			switch(value) {
				case Resolved(option):
					switch(option.toOption()) {
						case Some(v):
							_then.dispatch(v);
							_when.dispatch(Right(v));
						case None:
							_when.dispatch(Left(cast new NoSuchElementError()));
					}
				case Rejected(error):
					_but.dispatch(error);
					_when.dispatch(Left(error));
				case Aborted:
					_when.dispatch(Left(cast new NoSuchElementError()));
				default:
			}
		});
	}

	public function then(func : T -> Void) : Promise<T> {
		switch(_state){
			case Pending:
				_then.add(func);
			case Resolved(option):
				switch(option.toOption()) {
					case Some(value):
						func(value);
					case None:
				}
			default:
		}
		return this;
	}

	public function but(func : FunkError -> Void) : Promise<T> {
		switch(_state){
			case Pending:
				_but.add(func);
			case Rejected(value):
				func(value);
			default:
		}
		return this;
	}

	public function when(func : Either<FunkError, T> -> Void) : Promise<T> {
		switch(_state){
			case Pending:
				_when.add(func);
			case Resolved(option):
				switch(option.toOption()) {
					case Some(value):
						func(Right(value));
					case None:
				}
			case Rejected(value):
				func(Left(value));
			default:
		}
		return this;
	}
}
