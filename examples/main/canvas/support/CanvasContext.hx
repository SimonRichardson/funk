package support;

import funk.collections.immutable.List;
import CommonJS;
import UserAgentContext;

using funk.collections.immutable.extensions.Lists;

enum CanvasCommands {
    FillStyle(color : String);
    FillRect(x : Float, y : Float, width : Float, height : Float);
    MoveTo(x : Float, y : Float);
}

class CanvasContext {

    private var _commands : List<CanvasCommands>;

    public function new() {
        _commands = Nil;
    }

    public function render(layer : Layer, context : CanvasRenderingContext2D) {
        context.save();
        context.translate(layer.x, layer.y);

        _commands.foreach(function (command) {
            switch(command) {
                case FillStyle(color):
                    context.fillStyle = color;
                case FillRect(x, y, width, height):
                    context.fillRect(x, y, width, height);
                case MoveTo(x, y):
                    context.moveTo(x, y);
            }
        });

        context.restore();
    }

    public function fillStyle(color : String) : Void {
        _commands = _commands.append(FillStyle(color));
    }

    public function fillRect(x : Float, y : Float, width : Float, height : Float) : Void {
        _commands = _commands.append(FillRect(x, y, width, height));
    }

    public function moveTo(x : Float, y : Float) : Void {
        _commands = _commands.append(MoveTo(x, y));
    }
}
