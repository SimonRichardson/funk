package funk.option;

import funk.IFunkObject;
import funk.either.Either;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.product.Product1;
import funk.product.ProductIterator;

enum Option<T> {
	None;
	Some(value : T);
}

class Options {

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
			case Some(_): true;
			case None: false;
		}
	}

	inline public static function isEmpty<T>(option : Option<T>) : Bool {
		return switch(option) {
			case Some(_): false;
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

	inline public static function flatMap<T1, T2>(option : Option<T1>, func : T1 -> Option<T2>)
																					 : Option<T2> {
		return switch(option) {
			case Some(value): func(get(option));
			case None: None;
		}
	}

	inline public static function map<T1, T2>(option : Option<T1>, func : T1 -> T2) : Option<T2> {
		return switch(option) {
			case Some(value): Some(func(get(option)));
			case None: None;
		}
	}

	inline public static function orElse<T>(option : Option<T>, func : Void -> Option<T>)
																					: Option<T> {
		return switch(option) {
			case Some(value): option;
			case None: func();
		}
	}

	inline public static function orEither<T1, T2>(option : Option<T1>, func : Void -> T2)
																				: Either<T2, T1> {
		return switch(option) {
			case Some(value): Right(value);
			case None: Left(func());
		}
	}

	inline public static function toInstance<T>(option : Option<T>) : ProductOption<T> {
		return new ProductOption<T>(option);
	}

	inline public static function productIterator<T>(option : Option<T>) : IProductIterator<T> {
		return cast new ProductOption<T>(option).productIterator();
	}

	inline public static function toOption<T>(value : Null<T>) : Option<T> {
		return if(null == value) None; else Some(value);
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
			case Some(_): 1;
			case None: 0;
		}
	}

	override private function get_productPrefix() : String {
		return Type.enumConstructor(_option);
	}

	override public function productElement(index : Int) : Dynamic {
		return switch(_option) {
			case Some(_): Options.get(_option);
			case None: throw new RangeError();
		}
	}

	override public function equals(that: IFunkObject): Bool {
      	if(Std.is(that, Option)) {
        	var thatOption: Option<T> = cast that;

        	if(Options.isDefined(thatOption)) {
				var aFunk : Dynamic = Options.get(_option);
				var bFunk : Dynamic = Options.toInstance(thatOption).productElement(0);

				return aFunk == bFunk;
				// FIXME (Simon) : This is wrong
          		//return expect(aFunk).toEqual(bFunk);
        	}
      	}

      	return false;
    }

    public function get() : T {
		return Options.get(_option);
	}

	public function getOrElse(func : Void -> T) : T {
		return Options.getOrElse(_option, func);
	}

	public function isDefined() : Bool {
		return Options.isDefined(_option);
	}

	public function isEmpty() : Bool {
		return Options.isEmpty(_option);
	}

	public function filter(func : T -> Bool) : Option<T> {
		return Options.filter(_option, func);
	}

	public function foreach(func : T -> Void) : Void {
		Options.foreach(_option, func);
	}

	public function flatMap<T2>(func : T -> Option<T2>) : Option<T2> {
		return Options.flatMap(_option, func);
	}

	public function map<T2>(func : T -> T2) : Option<T2> {
		return Options.map(_option, func);
	}

	public function orElse(func : Void -> Option<T>) : Option<T> {
		return Options.orElse(_option, func);
	}

	public function orEither<T2>(func : Void -> T2) : Either<T2, T> {
		return Options.orEither(_option, func);
	}

}
