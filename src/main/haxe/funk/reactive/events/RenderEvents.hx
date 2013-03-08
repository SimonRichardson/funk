package funk.reactive.events;

import funk.reactive.events.Events;
import funk.types.Function0;
import funk.types.Function1;
import funk.types.Any;
import funk.types.Option;

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
    public static function enterFrame(target : RenderTarget) : Stream<Event> {
        return Events.event(cast target, RenderEventTypes.toString(EnterFrame));
    }

    public static function render(target : RenderTarget) : Stream<Event> {
        return Events.event(cast target, RenderEventTypes.toString(Render));
    }
    #end
}

#if js 
class RenderTarget {

    private var _tick : Function1<Float, Bool>;

    private var _listeners : Map<String, Array<Function1<Event, Void>>>;

    private var _running : Bool;

    public function new(type : String) {
        _listeners = new Map();
        _running = false;

        var win = Browser.window;
        var document = win.document;

        _tick = function(value) {
            var event = document.createEvent('Event');
            event.initEvent(type, false, false);

            dispatchEvent(event);

            if (!_running) {
                win.requestAnimationFrame(_tick);
            }
            return true;
        };
    }
    
    public function addEventListener( type : String, listener : Function1<Event, Void>, ?useCapture : Bool ) : Void {
        if(!_listeners.exists(type)) {
            _listeners.set(type, [listener]);
        } else {
            var listeners = _listeners.get(type);
            listeners.push(listener);
        }

        if (!_running) {
            var win = Browser.window;
            win.requestAnimationFrame(_tick);
        }
    }

    public function removeEventListener( type : String, listener : Function1<Event, Void>, ?useCapture : Bool ) : Void {
        if(!_listeners.exists(type)) {
            return;
        }
        
        var listeners = _listeners.get(type);
        
        var index = -1;
        for(i in 0...listeners.length) {
            if (listeners[i] == listener) {
                index = i;
                break;
            }
        }

        if (index >= 0) {
            listeners.splice(index, 1);
        }

        if (listeners.length < 1) {
            if (!_listeners.keys().hasNext()) {
                _running = false;
            }
        }
    }

    public function dispatchEvent(event : Event) : Bool {
        return if (_listeners.exists(event.type)) {
            var listeners = _listeners.get(event.type);
            for(i in 0...listeners.length) {
                var listener = listeners[i];
                listener(event);
            }
            true;
        } else {
            false;
        }
    }
}
#end

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
