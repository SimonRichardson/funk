package funk.reactive.events;

import funk.reactive.Propagation;
import funk.reactive.Stream;
import funk.reactive.extensions.Streams;
import funk.types.Function1;

#if js
import js.Dom;
typedef EventDispatcher = {
    function addEventListener(type : String, method : Function1<Event, Void>, useCapture : Bool) : Void;
    function removeEventListener(type : String, method : Function1<Event, Void>, useCapture : Bool) : Void;
};
#elseif flash9
import flash.events.Event;
import flash.events.EventDispatcher;
#end

class Events {

    #if (js || flash9)
    public static function event<T : Event>(    target : EventDispatcher,
                                                type : String,
                                                ?useCapture : Bool = false
                                                ) : Stream<T> {
        var stream = Streams.identity(None);

        var method = function (event) {
            stream.dispatch(event);
        };

        target.addEventListener(type, method, useCapture);

        stream.whenFinishedDo(function () {
            target.removeEventListener(type, method, useCapture);
        });

        return stream;
    }
    #end
}
