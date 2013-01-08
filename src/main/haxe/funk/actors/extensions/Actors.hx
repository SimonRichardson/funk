package funk.actors.extensions;

import funk.actors.Actor;

class Actors {

    public static function commutes<T1, T2>(a : Actor<T1, T2>, b : Actor<T1, T2>) : Bool {
        return a.recipients().exists(function (actor : Actor<T1, T2>) {
            return actor.address() == b.address();
        });
    }
}
