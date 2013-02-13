package funk.reactive.events;

import funk.reactive.Propagation;
import funk.reactive.Stream;
import funk.reactive.extensions.Streams;
import funk.types.Function1;

#if js
extern class Event {
    public var type(default, never) : String;
    public var target(default, never) : EventTarget;
    public var currentTarget(default, never) : EventTarget;
    public var eventPhase(default, never) : Int;
    public var bubbles(default, never) : Bool;
    public var cancelable(default, never) : Bool;
    public var timeStamp(default, never) : Float;
    public var defaultPrevented (default, never) : Bool;

    public function stopPropagation() : Void;
    public function preventDefault() : Void;
    public function initEvent(type : String, bubbles : Bool, cancelable : Bool) : Void;
    public function stopImmediatePropagation() : Void;
}
extern class EventTarget {
    public function addEventListener(type : String, method : Function1<Event, Void>, useCapture : Bool) : Void;
    public function removeEventListener(type : String, method : Function1<Event, Void>, useCapture : Bool) : Void;
    public function dispatchEvent(evt : Event) : Bool;
}
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

        return cast stream;
    }
    #end
}
