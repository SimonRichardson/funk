package funk.reactive.events;

import funk.reactive.Propagation;
import funk.reactive.Stream;
import funk.reactive.extensions.Streams;
import funk.types.Function1;

#if js
import js.w3c.level3.Events;
typedef EventDispatcher = EventTarget;
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
            stream.emit(event);
        };

        target.addEventListener(type, method, useCapture);

        stream.whenFinishedDo(function () {
            target.removeEventListener(type, method, useCapture);
        });

        return stream;
    }
    #end
}
