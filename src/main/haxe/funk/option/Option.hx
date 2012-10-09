package funk.option;

import funk.IFunkObject;
import funk.either.Either;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.product.Product1;
import funk.product.ProductIterator;

enum Option<T> {
	None;
	Some(value : Null<T>);
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

	inline public static function toOption<T>(value : Null<T>) : Option<T> {
		return if(null == value) None; else Some(value);
	}

	inline public static function equals<T1, T2>(option : Option<T1>, thatOption : Option<T2>)
																				: Bool {
		return Options.toInstance(option).equals(Options.toInstance(thatOption));
	}

	inline public static function productIterator<T>(option : Option<T>) : IProductIterator<T> {
		return (cast Options.toInstance(option)).productIterator();
	}

	inline public static function toString<T>(option : Option<T>) : String {
		return Options.toInstance(option).toString();
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
			case Some(_): 
				if(index == 0) {
					Options.get(_option);
				} else {
					throw new RangeError();
				}
			case None: throw new RangeError();
		}
	}

	override public function equals(that: IFunkObject): Bool {
		return if(this == that) {
			true;
		} else if(Std.is(that, ProductOption)) {

			var thatOption : ProductOption<Dynamic> = cast that;
			if(this.isEmpty() && thatOption.isEmpty()) {

				true;

			} else if(this.isDefined() && thatOption.isDefined()) {

				var value0 = this.get();
				var value1 = thatOption.get();

				if(Std.is(value0, IFunkObject) && Std.is(value1, IFunkObject)) {
					var funk0 : IFunkObject = cast value0;
					var funk1 : IFunkObject = cast value1;
					funk0.equals(funk1);
				} else {

					switch(Type.typeof(value0)){
						case TEnum(_):
							switch(Type.typeof(value1)){
								case TEnum(_):
									Type.enumEq(value0, value1);
								default:
									false;
							}
						default:
							value0 == value1;
					}

				}
			} else {
				false;
			}
		} else {
			false;
		}
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
