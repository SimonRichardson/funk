package support;

import CommonJS;
import UserAgentContext;

class Layer {

    private var _context : CanvasContext;

    private var _parent : HTMLCanvasElement;

    private var _x : Float;

    private var _y : Float;

    private var _width : Float;

    private var _height : Float;

    public var parent(get_parent, set_parent) : HTMLCanvasElement;

    public var x(get_x, set_x) : Float;

    public var y(get_y, set_y) : Float;

    public var width(get_width, set_width) : Float;

    public var height(get_height, set_height) : Float;

    public function new() {
        _context = new CanvasContext(this);
        _parent = null;
        _x = 0;
        _y = 0;
        _width = 0;
        _height = 0;
    }

    public function context() : CanvasContext {
        return _context;
    }

    private function get_parent() : HTMLCanvasElement {
        return _parent;
    }

    private function set_parent(value : HTMLCanvasElement) : HTMLCanvasElement {
        _parent = value;
        return _parent;
    }

    private function get_x() : Float {
        return _x;
    }

    private function set_x(value : Float) : Float {
        if (_x != value) {
            _x = value;
            _context.render();
        }
        return _x;
    }

    private function get_y() : Float {
        return _y;
    }

    private function set_y(value : Float) : Float {
        if (_y != value) {
            _y = value;
            _context.render();
        }
        return _y;
    }

    private function get_width() : Float {
        return _width;
    }

    private function set_width(value : Float) : Float {
        if (_width != value) {
            _width = value;
            _context.render();
        }
        return _width;
    }

    private function get_height() : Float {
        return _height;
    }

    private function set_height(value : Float) : Float {
        if (_height != value) {
            _height = value;
            _context.render();
        }
        return _height;
    }
}
