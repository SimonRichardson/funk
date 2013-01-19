package support;

class Layer {

    private var _context : CanvasContext;

    public var x(get_x, set_x) : Float;

    public var y(get_y, set_y) : Float;

    private var _x : Float;

    private var _y : Float;

    public function new() {
        _context = new CanvasContext();
        _x = 0;
        _y = 0;
    }

    public function context() : CanvasContext {
        return _context;
    }

    private function get_x() : Float {
        return _x;
    }

    private function set_x(value : Float) : Float {
        _x = value;
        return _x;
    }

    private function get_y() : Float {
        return _y;
    }

    private function set_y(value : Float) : Float {
        _y = value;
        return _y;
    }
}
