package funk.logging.outputs;

using funk.logging.extensions.Messages;

@:final
class FileOutput<T> extends Output<T> {

    #if (neko || cpp)

    private var _output : sys.io.FileOutput;

    public function new(output : sys.io.FileOutput) {
        super();

        _output = output;
    }

    override private function process(message : Message<T>) : Void {
        var str = message.toString();
        _output.writeInt32(str.length);
        _output.writeString(str);
        _output.flush();
    }

    #else

    public function new() {
        super();
    }

    #end
}
