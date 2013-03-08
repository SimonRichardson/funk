package funk.reactives.events;

import funk.reactives.Propagation;
import funk.reactives.Stream;
import funk.types.Function1;
import funk.types.Option;

#if js
import js.Browser;
#elseif flash9
import flash.events.Event;
import flash.events.EventDispatcher;
#end

#if js
private typedef Event = js.html.Event;
private typedef EventDispatcher = js.html.EventTarget;
#end

class Events {

    #if (js || flash9)
    public static function event<T : Event>(    target : EventDispatcher,
                                                type : String,
                                                ?useCapture : Bool = false
                                                ) : Stream<T> {
        var stream = StreamTypes.identity(None);

        var method = function (event) {
            stream.dispatch(event);
        };

        target.addEventListener(type, method, useCapture);

        stream.whenFinishedDo(function () {
            target.removeEventListener(type, method, useCapture);
        });

        return cast stream;
    }
    #end
}
