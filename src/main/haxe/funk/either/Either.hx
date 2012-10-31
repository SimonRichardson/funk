package funk.either;

import funk.IFunkObject;
import funk.errors.RangeError;
import funk.product.Product;
import funk.product.Product2;
import funk.product.ProductIterator;
import funk.option.Option;

using funk.option.Option;

enum Either<T1, T2> {
    Left(value : T1);
    Right(value : T2);
}

interface IEither<T1, T2> implements IProduct {

    function isLeft() : Bool;

    function isRight() : Bool;

    function left() : IOption<T1>;

    function right() : IOption<T2>;

    function fold<T3>(func0 : (T1 -> T3), func1 : (T2 -> T3)) : T3;

    function swap() : Either<T2, T1>;

    function toOption() : IOption<T2>;
}

class Eithers {

    inline public static function isLeft<T1, T2>(either : Either<T1, T2>) : Bool {
        return switch(either) {
            case Left(_): true;
            case Right(_): false;
        }
    }

    inline public static function isRight<T1, T2>(either : Either<T1, T2>) : Bool {
        return switch(either) {
            case Left(_): false;
            case Right(_): true;
        }
    }

    inline public static function left<T1, T2>(either : Either<T1, T2>) : IOption<T1> {
        return switch(either) {
            case Left(value): Some(value).toInstance();
            case Right(_): None.toInstance();
        }
    }

    inline public static function right<T1, T2>(either : Either<T1, T2>) : IOption<T2> {
        return switch(either) {
            case Left(_): None.toInstance();
            case Right(value): Some(value).toInstance();
        }
    }

    inline public static function fold<T1, T2, T3>( either : Either<T1, T2>,
                                                    func0 : (T1 -> T3),
                                                    func1 : (T2 -> T3)) : T3 {
        return switch(either) {
            case Left(value): func0(value);
            case Right(value): func1(value);
        }
    }

    inline public static function swap<T1, T2>(either : Either<T1, T2>) : Either<T2, T1> {
        return switch(either) {
            case Left(value): Right(value);
            case Right(value): Left(value);
        }
    }

    inline public static function toOption<T1, T2>(either : Either<T1, T2>) : IOption<T2> {
        return switch(either) {
            case Left(_): None.toInstance();
            case Right(value): Some(value).toInstance();
        }
    }

    inline public static function productIterator<T1, T2>(either : Either<T1, T2>)
                                                                    : IProductIterator<Dynamic> {
        return new ProductEither<T1, T2>(either).productIterator();
    }

    inline public static function toInstance<T1, T2>(either : Either<T1, T2>) : IEither<T1, T2> {
        return new ProductEither<T1, T2>(either);
    }

    inline public static function toString<T1, T2>(either : Either<T1, T2>) : String {
        return new ProductEither<T1, T2>(either).toString();
    }
}

class ProductEither<T1, T2> extends Product2<T1, T2>, implements IEither<T1, T2> {

    private var _either : Either<T1, T2>;

    public function new(either : Either<T1, T2>) {
        super();

        _either = either;
    }

    override private function get_productArity() : Int {
        return 1;
    }

    override private function get_productPrefix() : String {
        return Type.enumConstructor(_either);
    }

    override public function productElement(index : Int) : Dynamic {
        return if(index == 0) {
            switch(_either) {
                case Left(value): cast value;
                case Right(value): cast value;
            }
        } else {
            throw new RangeError();
        }
    }

    override public function equals(that: IFunkObject): Bool {
        return if(this == that) {
            true;
        } else if(Std.is(that, ProductEither)) {

            var thatEither : ProductEither<Dynamic, Dynamic> = cast that;
            if(isLeft() && thatEither.isLeft() || isRight() && thatEither.isRight()) {
                var value0 = switch(_either) {
                    case Left(value): cast value;
                    case Right(value): cast value;
                }

                var value1 = thatEither.productElement(0);

                if(Std.is(value0, IFunkObject) && Std.is(value1, IFunkObject)) {
                    var funk0 : IFunkObject = cast value0;
                    var funk1 : IFunkObject = cast value1;
                    funk0.equals(funk1);
                } else {
                    value0 == value1;
                }
            } else {
                false;
            }
        } else {
            false;
        }
    }

    public function isLeft() : Bool {
        return Eithers.isLeft(_either);
    }

    public function isRight() : Bool {
        return Eithers.isRight(_either);
    }

    public function left() : IOption<T1> {
        return Eithers.left(_either);
    }

    public function right() : IOption<T2> {
        return Eithers.right(_either);
    }

    public function fold<T3>(func0 : (T1 -> T3), func1 : (T2 -> T3)) : T3 {
        return Eithers.fold(_either, func0, func1);
    }

    public function swap() : Either<T2, T1> {
        return Eithers.swap(_either);
    }

    public function toOption() : IOption<T2> {
        return Eithers.toOption(_either);
    }
}


