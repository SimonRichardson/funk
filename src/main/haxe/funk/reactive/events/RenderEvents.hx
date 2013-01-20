package funk.reactive.events;

import funk.reactive.events.Events;
import funk.reactive.Stream;
import funk.reactive.extensions.Streams;

#if js
import CommonJS;
import UserAgentContext;
#elseif flash9
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
#end

using funk.reactive.extensions.Streams;

enum RenderEventType {
    EnterFrame;
    Render;
}

class RenderEvents {

    #if (flash9)
    public static function enterFrame(target : EventDispatcher) : Stream<Event> {
        return Events.event(target, RenderEventTypes.toString(EnterFrame));
    }

    public static function render(stage : Stage) : Stream<Event> {
        return Events.event(stage, RenderEventTypes.toString(Render));
    }
    #elseif (js)
    public static function enterFrame(target : EventDispatcher) : Stream<Event> {
        return customEvent(RenderEventTypes.toString(EnterFrame));
    }

    public static function render(target : EventDispatcher) : Stream<Event> {
        return customEvent(RenderEventTypes.toString(Render));
    }

    private static function customEvent(type : String) : Stream<Event> {
        var stream = Streams.identity(None);

        var win = untyped __js__("window");
        var document = CommonJS.getHtmlDocument();
        var finished = false;

        function tick() {
            var event = document.createEvent("Event");
            event.initEvent(type, false, false);

            stream.emit(event);

            if (!finished) {
                win.requestAnimationFrame(tick);
            }
        }

        win.requestAnimationFrame(tick);

        stream.whenFinishedDo(function () {
            finished = true;
        });

        return stream;
    }
    #end
}

class RenderEventTypes {

    public static function toString(type : RenderEventType) : String {
        #if flash9
            var type = Std.string(type);
            return type.substr(0, 1).toLowerCase() + type.substr(1);
        #else
            return Std.string(type).toLowerCase();
        #end
    }
}
