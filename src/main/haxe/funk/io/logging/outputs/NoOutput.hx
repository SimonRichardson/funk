package funk.io.logging.outputs;

using funk.io.logging.Message;

@:final
class NoOutput<T> extends Output<T> {

    public function new() {
        super();
    }

    override private function process(message : Message<T>) : Void {}
}
