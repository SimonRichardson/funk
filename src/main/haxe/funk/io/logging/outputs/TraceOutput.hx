package funk.io.logging.outputs;

using funk.io.logging.Message;

@:final
class TraceOutput<T> extends Output<T> {

    public function new() {
        super();
    }

    override private function process(message : Message<T>) : Void {
        // Should produce the output [DEFAULT][DEBUG] message
        trace(message.toString());
    }
}
