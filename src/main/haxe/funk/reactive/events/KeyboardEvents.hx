package funk.reactive.events;

import funk.reactive.events.Events;
import funk.reactive.Stream;
import funk.reactive.extensions.Streams;

#if js
import js.Browser;
#elseif flash9
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
#end

#if js
private typedef Event = js.html.Event;
private typedef KeyboardEvent = js.html.KeyboardEvent;
private typedef EventDispatcher = js.html.EventTarget;
#end

enum KeyboardEventType {
    KeyDown;
    KeyUp;
}

class KeyboardEvents {

    #if (js || flash9)
    public static function keyDown(target : EventDispatcher) : Stream<KeyboardEvent> {
        return Events.event(target, KeyboardEventTypes.toString(KeyDown));
    }

    public static function keyUp(target : EventDispatcher) : Stream<KeyboardEvent> {
        return Events.event(target, KeyboardEventTypes.toString(KeyUp));
    }
    #end
}

class KeyboardEventTypes {

    public static function toString(type : KeyboardEventType) : String {
        #if flash9
            var type = AnyTypes.toString(type);
            return type.substr(0, 1).toLowerCase() + type.substr(1);
        #else
            return AnyTypes.toString(type).toLowerCase();
        #end
    }
}
