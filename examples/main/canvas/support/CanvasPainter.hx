package support;

import funk.collections.immutable.List;
import CommonJS;
import funk.reactive.events.RenderEvents;
import UserAgentContext;

using funk.collections.immutable.extensions.Lists;
using funk.reactive.extensions.Streams;

class CanvasPainter {

    private static var _paint : Bool;

    private static var _commands : List<List<CanvasCommands>>;

    public static function init(canvas : HTMLCanvasElement) {
        _paint = false;
        _commands = Nil;

        var context = canvas.getContext("2d");

        RenderEvents.enterFrame(null).foreach(function (event : Event) {
            if (_paint) {
                _commands.foreach(function (commands : List<CanvasCommands>) : Void {
                    context.save();

                    commands.foreach(function (command) {
                        switch(command) {
                            case Clear(x, y, width, height):
                                context.clearRect(x, y, width, height);
                            case FillStyle(color):
                                context.fillStyle = color;
                            case FillRect(x, y, width, height):
                                context.fillRect(x, y, width, height);
                            case MoveTo(x, y):
                                context.moveTo(x, y);
                            case Translate(x, y):
                                context.translate(x, y);
                        }
                    });

                    context.restore();
                });
            }
        });
    }

    public static function paint(commands : List<CanvasCommands>) {
        _commands = _commands.prepend(commands);
        _paint = _commands.nonEmpty();
    }
}
