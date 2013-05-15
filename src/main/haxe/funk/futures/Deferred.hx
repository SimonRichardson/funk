package funk.futures;

import funk.Funk;
import funk.reactives.Stream;
import funk.reactives.StreamValues;
import funk.signals.Signal1;
import funk.types.Attempt;
import funk.types.Function1;

using funk.types.Any;
using funk.types.Option;
using funk.ds.Collection;
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

    public function progress(value : Float) : Float {
       return switch (_values.last()) {
            case Some(state):
                switch(state) {
                    case Pending: 
                        _progressStream.dispatch(value);
                        value;
                    case _: Funk.error(IllegalOperationError('Invalid state'));
                }
            case _: Funk.error(IllegalOperationError('Invalid value'));
        }
    }

    public function resolve(value : T) : T {
        return switch(_values.last()) {
            case Some(state):
                switch(state) {
                    case Pending: 
                        _stateStream.dispatch(Resolved(Some(value)));
                        value;
                    case _: Funk.error(IllegalOperationError('Invalid state'));
                }
            case _: Funk.error(IllegalOperationError('Invalid value'));
        }
    }

    public function reject(error : Errors) : Errors {
        return switch(_values.last()) {
            case Some(state):
                switch(state) {
                    case Pending: 
                        _stateStream.dispatch(Rejected(error));
                        error;
                    case _: Funk.error(IllegalOperationError('Invalid state'));
                }
            case _: Funk.error(IllegalOperationError('Invalid value'));
        }
    }

    public function abort() : Void _stateStream.dispatch(Aborted);

    public function promise() : Promise<T> return new PromiseImpl<T>(_stateStream, _progressStream, _values.last());

    public function states() : Collection<State<T>> return _values;

    public function values() : Collection<T> {
        return cast _values.map(function(state) {
            return switch(state){
                case Resolved(option): option.get();
                case _: null;
            };
        }).filter(function(value) return AnyTypes.toBool(value));
    }
}

private class PromiseImpl<T> implements Promise<T> {

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
        _progressStream.foreach(function(value) _progress.dispatch(value));
    }

    public function then<R>(func : Function1<T, R>) : Promise<R> {
        var deferred = new Deferred();
        var promise = deferred.promise();
        switch(_state){
            case Pending: _then.add(function(v) return deferred.resolve(func(v)));
            case Resolved(option): deferred.resolve(func(option.get()));
            case _:
        }
        return promise;
    }

    public function but<R>(func : Function1<Errors, R>) : Promise<R> {
        var deferred = new Deferred();
        var promise = deferred.promise();
        switch(_state){
            case Pending: _but.add(function(v) {
                var result = func(v);
                deferred.reject(v);
                return result;
            });
            case Rejected(value): deferred.reject(cast func(value));
            case _:
        }
        return promise;
    }

    public function when<R>(func : Function1<Attempt<T>, R>) : Promise<R> {
        var deferred = new Deferred();
        var promise = deferred.promise();
        switch(_state){
            case Pending: _when.add(function(attempt) {
                return switch(attempt) {
                    case Success(_): deferred.resolve(func(attempt));
                    case _: cast deferred.reject(cast func(attempt));
                };
            });
            case Resolved(option): deferred.resolve(func(Success(option.get())));
            case Rejected(value): deferred.reject(cast func(Failure(value)));
            case _:
        }
        return promise;
    }

    public function progress(func : Function1<Float, Void>) : Promise<T> {
        _progress.add(func);
        return this;
    }
}

class EmptyPromise<T> implements Promise<T> {

    public function new() {}

    public function then<R>(func : Function1<T, R>) : Promise<R> return new Deferred().promise();

    public function but<R>(func : Function1<Errors, R>) : Promise<R> return new Deferred().promise();

    public function when<R>(func : Function1<Attempt<T>, R>) : Promise<R> return new Deferred().promise();

    public function progress(func : Function1<Float, Void>) : Promise<T> return new Deferred().promise();
}
