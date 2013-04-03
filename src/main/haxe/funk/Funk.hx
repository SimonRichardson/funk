package funk;

import funk.types.extensions.EnumValues;
import haxe.CallStack;
import haxe.PosInfos;

enum Errors {
    Abstract;
    AbstractMethod;
    ActorError(message : String);
    ArgumentError(?message : String);
    BindingError(message : String);
    Error(message : String);
    HttpError(message : String);
    IllegalOperationError(?message : String);
    InjectorError(message : String);
    NoSuchElementError;
    RangeError;
    TypeError(?message : String);
}

class FunkError {

    private var _error : Errors;

    private var _message : String;

    private var _posInfo : PosInfos;

    private var _stack : Array<StackItem>;

    public function new(    error : Errors,
                            message : String,
                            posInfo : PosInfos,
                            ?stack : Array<StackItem>
                            ) {
        _error = error;
        _message = message;
        _posInfo = posInfo;
        _stack = stack;
    }

    public function error() : Errors return _error;

    public function message() : String return _message;

    public function posInfo() : PosInfos return _posInfo;

    public function stack() : Array<StackItem> return _stack;

    public function toString() : String {
        return '${EnumValues.getEnumName(_error)}: ${_message} ${CallStack.toString(_stack)}';
    }
}

class Funk {

    @:noUsing
    public static function error<T>(type : Errors, ?posInfo : PosInfos) : T {
        var message = switch(type) {
            case Abstract: 'Type is abstract, you must extend it';
            case AbstractMethod: 'Method is abstract, you must override it';
            case ActorError(msg): msg;
            case ArgumentError(msg): msg == null ? 'Arguments supplied are not expected' : msg;
            case BindingError(msg): msg;
            case Error(msg): msg;
            case HttpError(msg): msg;
            case IllegalOperationError(msg): msg == null ? 'Required operation can not be executed' : msg;
            case InjectorError(msg): msg;
            case NoSuchElementError: 'No such element exists';
            case RangeError: 'Value is outside of the expected range';
            case TypeError(msg): msg == null ? 'Type error was thrown' : msg;
        }

        var stack = CallStack.callStack();
        // Remove the first item as it's always going to be Funk.error
        if (stack.length > 0) stack.shift();

        var error = new FunkError(type, message, posInfo, stack);

        #if debug trace(error.toString()); #end

        throw error;

        return null;
    }

    @:noUsing
    public static function main() : Void {
    }
}
