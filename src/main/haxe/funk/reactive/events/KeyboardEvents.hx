package funk.reactive.events;

import funk.reactive.events.Events;
import funk.reactive.Stream;
import funk.reactive.extensions.Streams;

#if js
import js.w3c.level3.Events;
#elseif flash9
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
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
            var reg = new EReg("([^\\A])([A-Z])", "g");
            return reg.replace(Std.string(type), '$1_$2').toUpperCase();
        #else
            return Std.string(type).toLowerCase();
        #end
    }
}
