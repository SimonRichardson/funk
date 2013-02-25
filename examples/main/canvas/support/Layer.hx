package support;

import js.Browser;
import js.html.CanvasElement;

class Layer {

    private var _context : CanvasContext;

    private var _parent : CanvasElement;

    private var _bounds : Bounds;

    private var _previousBounds : Bounds;

    public var parent(get_parent, set_parent) : CanvasElement;

    public var x(get_x, set_x) : Float;

    public var y(get_y, set_y) : Float;

    public var width(get_width, set_width) : Float;

    public var height(get_height, set_height) : Float;

    public function new() {
        _context = new CanvasContext(this);
        _bounds = new Bounds();
        _previousBounds = new Bounds();
        _parent = null;
    }

    public function context() : CanvasContext {
        return _context;
    }

    public function rectangle() : Rectangle {
        return _bounds.toRectangle();
    }

    public function previousRectangle() : Rectangle {
        return _previousBounds.toRectangle();
    }

    private function render() : Void {
        _context.render();
    }

    private function get_parent() : CanvasElement {
        return _parent;
    }

    private function set_parent(value : CanvasElement) : CanvasElement {
        _parent = value;
        return _parent;
    }

    private function get_x() : Float {
        return _bounds.x;
    }

    private function set_x(value : Float) : Float {
        if (_bounds.x != value) {
            _previousBounds.copy(_bounds);
            _bounds.x = value;
            render();
        }
        return _bounds.x;
    }

    private function get_y() : Float {
        return _bounds.y;
    }

    private function set_y(value : Float) : Float {
        if (_bounds.y != value) {
            _previousBounds.copy(_bounds);
            _bounds.y = value;
            render();
        }
        return _bounds.y;
    }

    private function get_width() : Float {
        return _bounds.width;
    }

    private function set_width(value : Float) : Float {
        if (_bounds.width != value) {
            _previousBounds.copy(_bounds);
            _bounds.width = value;
            render();
        }
        return _bounds.width;
    }

    private function get_height() : Float {
        return _bounds.height;
    }

    private function set_height(value : Float) : Float {
        if (_bounds.height != value) {
            _previousBounds.copy(_bounds);
            _bounds.height = value;
            render();
        }
        return _bounds.height;
    }
}
