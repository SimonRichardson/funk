package funk.reactive.events;

import funk.reactive.events.Events;
import funk.reactive.Stream;
import funk.reactive.extensions.Streams;

#if js
import js.Dom;
typedef MouseEvent = Event;
#elseif flash9
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
#end

enum MouseEventType {
    Click;
    MouseDown;
    MouseOver;
    MouseOut;
    MouseMove;
    MouseUp;
}

class MouseEvents {

    #if (js || flash9)
    public static function click(target : EventDispatcher) : Stream<MouseEvent> {
        return Events.event(target, MouseEventTypes.toString(Click));
    }

    public static function mouseDown(target : EventDispatcher) : Stream<MouseEvent> {
        return Events.event(target, MouseEventTypes.toString(MouseDown));
    }

    public static function mouseOver(target : EventDispatcher) : Stream<MouseEvent> {
        return Events.event(target, MouseEventTypes.toString(MouseOver));
    }

    public static function mouseOut(target : EventDispatcher) : Stream<MouseEvent> {
        return Events.event(target, MouseEventTypes.toString(MouseOut));
    }

    public static function mouseMove(target : EventDispatcher) : Stream<MouseEvent> {
        return Events.event(target, MouseEventTypes.toString(MouseMove));
    }

    public static function mouseUp(target : EventDispatcher) : Stream<MouseEvent> {
        return Events.event(target, MouseEventTypes.toString(MouseUp));
    }
    #end
}

class MouseEventTypes {

    public static function toString(type : MouseEventType) : String {
        #if flash9
            var type = Std.string(type);
            return type.substr(0, 1).toLowerCase() + type.substr(1);
        #else
            return Std.string(type).toLowerCase();
        #end
    }
}
