package funk.types;

import funk.Funk;
import funk.types.Either;

typedef Promise<T> = {

    function then(func : Function1<T, Void>) : Promise<T>;

    function but(func : Function1<Errors, Void>) : Promise<T>;

    function when(func : Function1<Attempt<T>, Void>) : Promise<T>;

    function progress(func : Function1<Float, Void>) : Promise<T>;
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
