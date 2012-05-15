package funk.ioc.errors;

import funk.ioc.errors.IOCError;

class BindingError extends IOCError {
	public function new(message : String) {
		super(message);
	}
}
