package funk;

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

class Funk {

	@:noUsing
	public static function error<T>(type : Errors, ?posInfo : PosInfos) : T {
		var message = switch(type) {
			case Abstract:
				'Type is abstract, you must extend it';
			case AbstractMethod:
				'Method is abstract, you must override it';
			case ActorError(msg):
				msg;
			case ArgumentError(msg):
				msg == null ? 'Arguments supplied are not expected' : msg;
			case BindingError(msg):
				msg;
			case Error(msg):
				msg;
			case HttpError(msg):
				msg;
			case IllegalOperationError(msg):
				msg == null ? 'Required operation can not be executed' : msg;
			case InjectorError(msg):
				msg;
			case NoSuchElementError:
				'No such element exists';
			case RangeError:
				'Value is outside of the expected range';
			case TypeError(msg):
				msg == null ? 'Type error was thrown' : msg;
		}
		throw message;
		return null;
	}

	@:noUsing
	public static function main() : Void {
	}
}
