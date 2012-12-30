package funk.reactive.events;

import funk.reactive.events.Events;
import funk.reactive.Stream;
import funk.reactive.extensions.Streams;

#if js
import js.w3c.level3.Events;
#elseif flash9
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
#else
throw "Unsupported platform";
#end

enum MouseEventType {
    MouseDown;
    MouseMove;
    MouseUp;
}

class MouseEvents {

    public static function mouseDown(target : EventDispatcher) : Stream<MouseEvent> {
        return Events.event(target, MouseEventTypes.toString(MouseDown));
    }

    public static function mouseMove(target : EventDispatcher) : Stream<MouseEvent> {
        return Events.event(target, MouseEventTypes.toString(MouseMove));
    }

    public static function mouseUp(target : EventDispatcher) : Stream<MouseEvent> {
        return Events.event(target, MouseEventTypes.toString(MouseUp));
    }
}

class MouseEventTypes {

    public static function toString(type : MouseEventType) : String {
        #if js
            return Std.string(type).toLowerCase();
        #elseif flash9
            var reg = new EReg("([^\\A])([A-Z])", "g");
            return reg.replace(Std.string(type), '$1_$2').toUpperCase();
        #else
            return Std.string(type);
        #end
    }
}
