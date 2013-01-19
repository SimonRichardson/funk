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

    private var _context : CanvasRenderingContext2D;

    private var _layer : Layer;

    public var context(get_context, set_context) : CanvasRenderingContext2D;

    public function new(layer : Layer) {
        _layer = layer;
        _commands = Nil;
    }

    public function render() {
        if (_context == null) {
            return;
        }

        _context.save();
        _context.translate(_layer.x, _layer.y);

        _commands.foreach(function (command) {
            switch(command) {
                case FillStyle(color):
                    _context.fillStyle = color;
                case FillRect(x, y, width, height):
                    _context.fillRect(x, y, width, height);
                case MoveTo(x, y):
                    _context.moveTo(x, y);
            }
        });

        _context.restore();
    }

    public function fillStyle(color : String) : Void {
        _commands = _commands.append(FillStyle(color));
    }

    public function fillRect(x : Float, y : Float, width : Float, height : Float) : Void {
        _commands = _commands.append(FillRect(x, y, width, height));

        if (width > _layer.width) {
            _layer.width = width;
        }
        if (height > _layer.height) {
            _layer.height = height;
        }
    }

    public function moveTo(x : Float, y : Float) : Void {
        _commands = _commands.append(MoveTo(x, y));
    }

    private function get_context() : CanvasRenderingContext2D {
        return _context;
    }

    private function set_context(value : CanvasRenderingContext2D) : CanvasRenderingContext2D {
        _context = value;
        return _context;
    }
}
