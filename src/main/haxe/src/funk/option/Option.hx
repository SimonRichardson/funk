package funk.option;

using funk.utils.VerifiedType;

enum Option<T> {
	None;
	Some(value : T);
}

class OptionType {
	
	public static function get<T>(option : Option<T>) : T {
		return switch(option) {
			case Some(value): value;
			case None: throw new funk.errors.NoSuchElementError();
		}
	}
	
	public static function getOrElse<T>(option : Option<T>, func : Void -> T) : T {
		return switch(option) {
			case Some(value): value;
			case None: func();
		}
	}
	
	public static function isDefined<T>(option : Option<T>) : Bool {
		return switch(option) {
			case Some(value): true;
			case None: false;
		}
	}
	
	public static function isEmpty<T>(option : Option<T>) : Bool {
		return switch(option) {
			case Some(value): false;
			case None: true;
		}
	}
	
	public static function filter<T>(option : Option<T>, func : T -> Bool) : Option<T> {
		return switch(option) {
			case Some(value): func(get(option)) ? option : None;
			case None: option;
		}
	}
	
	public static function foreach<T>(option : Option<T>, func : T -> Void) : Void {
		switch(option) {
			case Some(value): func(get(option));
			case None:
		}
	}
	
	public static function flatMap<T>(option : Option<T>, func : T -> Option<T>) : Option<T> {
		return switch(option) {
			case Some(value): func(get(option));//.verifyEnum(Option);
			case None: option;
		}
	}
}
