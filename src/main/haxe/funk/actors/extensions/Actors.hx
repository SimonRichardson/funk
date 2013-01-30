package funk.actors.extensions;

import funk.actors.Actor;
import funk.actors.Message;
import funk.types.Promise;
import funk.types.Option;

using funk.collections.immutable.extensions.Lists;

class Actors {

    public static function commutes<T>(a : Actor<T>, b : Actor<T>) : Bool {
        return a.recipients().exists(function (actor : Actor<T>) {
            return actor.address() == b.address();
        });
    }

    public static function dispatch<T1, T2>(a : Actor<T1>, value : T1) : Promise<Message<T2>> {
        return a.send(value).to(cast Some(a));
    }
}
