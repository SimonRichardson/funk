package funk.io.logging;

using funk.reactives.Stream;

class Output<T> {

    private var _isActive : Bool;

    public function new() {
        _isActive = false;
    }

    public function add(stream : Stream<Message<T>>) : Void {
        _isActive = true;

        stream.foreach(function (message) if (_isActive) process(message));
    }

    public function remove(stream : Stream<Message<T>>) : Void _isActive = false;

    @:overridable
    private function process(message : Message<T>) : Void {}
}
