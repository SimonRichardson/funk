package funk.types;

import funk.Funk;

enum Attempt<T> {
    Success(value : T);
    Failure(error : Errors);
}
