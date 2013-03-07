package support;

import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import funk.reactive.events.RenderEvents;
import support.CanvasCommands;

using funk.collections.immutable.List;
using funk.reactive.Stream;

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

        // Make sure we translate to the correct position.
        var list = switch (_commands.head()) {
            case Translate(_, _): _commands.tail();
            default: _commands;
        };

        _commands = list.prepend(Translate(Math.round(_layer.x), Math.round(_layer.y)));

        CanvasPainter.paint(_layer.previousRectangle(), _commands);
    }

    public function clear() : Void {
        _commands = Nil.prepend(Clear(_layer.x, _layer.y, _layer.width, _layer.height));

        _layer.width = 0;
        _layer.height = 0;
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
