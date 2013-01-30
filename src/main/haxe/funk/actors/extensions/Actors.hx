package funk.actors.extensions;

import funk.actors.Actor;
import funk.actors.Message;
import funk.types.Promise;
import funk.types.Option;

using funk.collections.immutable.extensions.Lists;

class Actors {

    public static function commutes<T1, T2>(a : Actor<T1, T2>, b : Actor<T1, T2>) : Bool {
        return a.recipients().exists(function (actor : Actor<T1, T2>) {
            return actor.address() == b.address();
        });
    }

    public static function echo<T1, T2>(a : Actor<T1, T2>, value : T1) : Promise<Message<T2>> {
        return a.send(value).to(Some(a));
    }
}
