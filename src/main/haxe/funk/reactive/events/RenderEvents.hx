package funk.reactive.events;

import funk.reactive.events.Events;
import funk.types.Function0;
import funk.types.Function1;

#if js
import js.Browser;
#elseif flash9
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
#end

using funk.reactive.Stream;

#if js
private typedef Event = js.html.Event;
private typedef EventDispatcher = js.html.EventTarget;
#end

enum RenderEventType {
    EnterFrame;
    Render;
}

class RenderEvents {

    #if flash9
    public static function enterFrame(target : EventDispatcher) : Stream<Event> {
        return Events.event(target, RenderEventTypes.toString(EnterFrame));
    }

    public static function render(stage : Stage) : Stream<Event> {
        return Events.event(stage, RenderEventTypes.toString(Render));
    }
    #elseif js
    public static function enterFrame() : Stream<Event> {
        return customEvent(RenderEventTypes.toString(EnterFrame));
    }

    public static function render() : Stream<Event> {
        return customEvent(RenderEventTypes.toString(Render));
    }

    private static function customEvent(type : String) : Stream<Event> {
        var stream = StreamTypes.identity(None);

        var win = Browser.window;
        var document = win.document;
        var finished = false;

        var tick : Function1<Float, Bool> = null;
        tick = function(value) {
            var event = document.createEvent('Event');
            event.initEvent(type, false, false);

            stream.dispatch(event);

            if (!finished) {
                win.requestAnimationFrame(tick);
            }
            return true;
        };

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
            var type = AnyTypes.toString(type);
            return type.substr(0, 1).toLowerCase() + type.substr(1);
        #else
            return AnyTypes.toString(type).toLowerCase();
        #end
    }
}
