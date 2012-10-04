package funk.option;

import funk.IFunkObject;
import funk.errors.NoSuchElementError;
import funk.product.Product1;
import funk.product.ProductIterator;

enum Option<T> {
	None;
	Some(value : T);
}

class OptionType {

	inline public static function get<T>(option : Option<T>) : T {
		return switch(option) {
			case Some(value): value;
			case None: throw new NoSuchElementError();
		}
	}

	inline public static function getOrElse<T>(option : Option<T>, func : Void -> T) : T {
		return switch(option) {
			case Some(value): value;
			case None: func();
		}
	}

	inline public static function isDefined<T>(option : Option<T>) : Bool {
		return switch(option) {
			case Some(value): true;
			case None: false;
		}
	}

	inline public static function isEmpty<T>(option : Option<T>) : Bool {
		return switch(option) {
			case Some(value): false;
			case None: true;
		}
	}

	inline public static function filter<T>(option : Option<T>, func : T -> Bool) : Option<T> {
		return switch(option) {
			case Some(value): func(get(option)) ? option : None;
			case None: option;
		}
	}

	inline public static function foreach<T>(option : Option<T>, func : T -> Void) : Void {
		switch(option) {
			case Some(value): func(get(option));
			case None: None;
		}
	}

	inline public static function flatMap<T, E>(option : Option<T>, func : T -> Option<E>) : Option<E> {
		return switch(option) {
			case Some(value): func(get(option));
			case None: None;
		}
	}

	inline public static function map<T, E>(option : Option<T>, func : T -> E) : Option<E> {
		return switch(option) {
			case Some(value): Some(func(get(option)));
			case None: None;
		}
	}

	inline public static function orElse<T>(option : Option<T>, func : Void -> Option<T>) : Option<T> {
		return switch(option) {
			case Some(value): option;
			case None: func();
		}
	}

	inline public static function instance<T>(option : Option<T>) : ProductOption<T> {
		return new ProductOption<T>(option);
	}

	inline public static function productIterator<T>(option : Option<T>) : IProductIterator<T> {
		return cast new ProductOption<T>(option).productIterator();
	}

	inline public static function toString<T>(option : Option<T>) : String {
		return new ProductOption<T>(option).toString();
	}
}

class ProductOption<T> extends Product1<T> {

	private var _option : Option<T>;

	public function new(option : Option<T>) {
		super();

		_option = option;
	}

	override private function get_productArity() : Int {
		return switch(_option) {
			case Some(value): 1;
			case None: 0;
		}
	}

	override private function get_productPrefix() : String {
		return Type.enumConstructor(_option);
	}

	override public function productElement(index : Int) : Dynamic {
		return OptionType.get(_option);
	}

	override public function equals(that: IFunkObject): Bool {
      	if(Std.is(that, Option)) {
        	var thatOption: Option<T> = cast that;

        	if(OptionType.isDefined(thatOption)) {
				var aFunk : Dynamic = OptionType.get(_option);
				var bFunk : Dynamic = OptionType.instance(thatOption).productElement(0);

				return aFunk == bFunk;
				// FIXME (Simon) : This is wrong
          		//return expect(aFunk).toEqual(bFunk);
        	}
      	}

      	return false;
    }
}
