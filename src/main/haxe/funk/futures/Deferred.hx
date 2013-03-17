package funk.futures;

import funk.Funk;
import funk.reactives.Stream;
import funk.reactives.StreamValues;
import funk.signals.Signal1;
import funk.types.Attempt;
import funk.types.Function1;

using funk.types.Any;
using funk.types.Option;
using funk.collections.Collection;
using funk.reactives.Stream;

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
        _stateStream = StreamTypes.identity(None);

        _progressStream = StreamTypes.identity(None);

        _values = _stateStream.values();

        // Set-up for the state
        _stateStream.dispatch(Pending);
    }

    public function attempt() : Attempt<T> {
        return switch(_values.last()) {
            case Some(state):
                switch(state) {
                    case Resolved(option): Success(option.get());
                    case Rejected(error): Failure(error);
                    case _: Failure(NoSuchElementError);
                }
            case _: Failure(NoSuchElementError);
        }
    }

    public function get() : Option<T> {
        return switch(_values.last()) {
            case Some(state):
                switch(state) {
                    case Resolved(option): option;
                    case _: None;
                }
            case _: None;
        };
    }

    public function progress(value : Float) : Void {
        switch (_values.last()) {
            case Some(state):
                switch(state) {
                    case Pending: _progressStream.dispatch(value);
                    case _: Funk.error(IllegalOperationError('Invalid state'));
                }
            case None: Funk.error(IllegalOperationError('Invalid value'));
        }
    }

    public function resolve(value : T) : Void {
        switch(_values.last()) {
            case Some(state):
                switch(state) {
                    case Pending: _stateStream.dispatch(Resolved(Some(value)));
                    case _: Funk.error(IllegalOperationError('Invalid state'));
                }
            case None: Funk.error(IllegalOperationError('Invalid value'));
        }
    }

    public function reject(error : Errors) : Void {
        switch(_values.last()) {
            case Some(state):
                switch(state) {
                    case Pending: _stateStream.dispatch(Rejected(error));
                    case _: Funk.error(IllegalOperationError('Invalid state'));
                }
            case None: Funk.error(IllegalOperationError('Invalid value'));
        }
    }

    public function abort() : Void {
        _stateStream.dispatch(Aborted);
    }

    public function promise() : Promise<T> {
        return new PromiseImpl<T>(_stateStream, _progressStream, _values.last());
    }

    public function states() : Collection<State<T>> {
        return _values;
    }

    public function values() : Collection<T> {
        return cast _values.map(function(state) {
            return switch(state){
                case Resolved(option): option.get();
                case _: null;
            };
        }).filter(function(value) return AnyTypes.toBool(value));
    }
}

private class PromiseImpl<T> {

    private var _state : State<T>;

    private var _stateStream : Stream<State<T>>;

    private var _progressStream : Stream<Float>;

    private var _then : Signal1<T>;

    private var _but : Signal1<Errors>;

    private var _when : Signal1<Attempt<T>>;

    private var _progress : Signal1<Float>;

    public function new(    stateStream : Stream<State<T>>,
                            progressStream : Stream<Float>,
                            state : Option<State<T>>) {
        _then = new Signal1<T>();
        _but = new Signal1<Errors>();
        _when = new Signal1<Attempt<T>>();
        _progress = new Signal1<Float>();

        _state = state.get();

        _stateStream = stateStream;
        _stateStream.foreach(function(value) {
            _state = value;

            switch(value) {
                case Resolved(option):
                    var v = option.get();

                    _then.dispatch(v);
                    _when.dispatch(Success(v));

                case Rejected(error):

                    _but.dispatch(error);
                    _when.dispatch(Failure(error));

                case Aborted:

                    _when.dispatch(Failure(NoSuchElementError));

                case _:
            }
        });

        _progressStream = progressStream;
        _progressStream.foreach(function(value) {
            _progress.dispatch(value);
        });
    }

    public function then(func : Function1<T, Void>) : Promise<T> {
        switch(_state){
            case Pending: _then.add(func);
            case Resolved(option): func(option.get());
            case _:
        }
        return this;
    }

    public function but(func : Function1<Errors, Void>) : Promise<T> {
        switch(_state){
            case Pending: _but.add(func);
            case Rejected(value): func(value);
            case _:
        }
        return this;
    }

    public function when(func : Function1<Attempt<T>, Void>) : Promise<T> {
        switch(_state){
            case Pending: _when.add(func);
            case Resolved(option): func(Success(option.get()));
            case Rejected(value): func(Failure(value));
            case _:
        }
        return this;
    }

    public function progress(func : Function1<Float, Void>) : Promise<T> {
        _progress.add(func);
        return this;
    }
}

class EmptyPromise<T> {

    public function new() {
    }

    public function then(func : Function1<T, Void>) : Promise<T> {
        return this;
    }

    public function but(func : Function1<Errors, Void>) : Promise<T> {
        return this;
    }

    public function when(func : Function1<Attempt<T>, Void>) : Promise<T> {
        return this;
    }

    public function progress(func : Function1<Float, Void>) : Promise<T> {
        return this;
    }
}
