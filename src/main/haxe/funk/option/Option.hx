package funk.option;

import funk.errors.NoSuchElementError;
import funk.Product;

enum Option<T> {
	None;
	Some(value : T);
}

class OptionType {
	
	public static function get<T>(option : Option<T>) : T {
		return switch(option) {
			case Some(value): value;
			case None: throw new NoSuchElementError();
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
	
	public static function flatMap<T, E>(option : Option<T>, func : T -> Option<E>) : Option<E> {
		return switch(option) {
			case Some(value): func(get(option));
			case None: None;
		}
	}
	
	public static function map<T, E>(option : Option<T>, func : T -> E) : Option<E> {
		return switch(option) {
			case Some(value): Some(func(get(option)));
			case None: None;
		}
	}
	
	public static function orElse<T>(option : Option<T>, func : Void -> Option<T>) : Option<T> {
		return switch(option) {
			case Some(value): option;
			case None: func();
		}
	}
	
	public static function toString<T>(option : Option<T>) : String {
		return new OptionToString<T>(option).toString();
	}
}

class OptionToString<T> extends Product<T> {
	
	private var _option : Option<T>;
	
	public function new(option : Option<T>) {
		_option = option;
	}
	
	override private function get_productArity() : Int {
		return switch(_option) {
			case Some(value): 1;
			case None: 0;
		}
	}
	
	override private function get_productPrefix() : String {
		// TODO (Simon) : We can be more clever about this : Type.getEnumName
		return switch(_option) {
			case Some(value): "Some";
			case None: "None";
		}
	}
	
	override public function productElement(index : Int) : T {
		return OptionType.get(_option);
	}
}
