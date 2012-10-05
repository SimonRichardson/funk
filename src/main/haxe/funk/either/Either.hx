package funk.either;

import funk.IFunkObject;
import funk.errors.RangeError;
import funk.product.Product2;
import funk.product.ProductIterator;
import funk.option.Option;

enum Either<T1, T2> {
    Left(value : T1);
    Right(value : T2);
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

    inline public static function left<T1, T2>(either : Either<T1, T2>) : Option<T1> {
        return switch(either) {
            case Left(value): Some(value);
            case Right(_): None;
        }
    }

    inline public static function right<T1, T2>(either : Either<T1, T2>) : Option<T2> {
        return switch(either) {
            case Left(_): None;
            case Right(value): Some(value);
        }
    }

    inline public static function fold<T1, T2>( either : Either<T1, T2>,
                                                func0 : (T1 -> T1),
                                                func1 : (T2 -> T2)) : Either<T1, T2> {
        return switch(either) {
            case Left(value): Left(func0(value));
            case Right(value): Right(func1(value));
        }
    }

    inline public static function swap<T1, T2>(either : Either<T1, T2>) : Either<T2, T1> {
        return switch(either) {
            case Left(value): Right(value);
            case Right(value): Left(value);
        }
    }

    inline public static function toOption<T1, T2>(either : Either<T1, T2>) : Option<T2> {
        return switch(either) {
            case Left(_): None;
            case Right(value): Some(value);
        }
    }

    inline public static function productIterator<T1, T2>(either : Either<T1, T2>)
                                                                    : IProductIterator<Dynamic> {
        return new ProductEither<T1, T2>(either).productIterator();
    }

    inline public static function toInstance<T1, T2>(either : Either<T1, T2>)
                                                                    : ProductEither<T1, T2> {
        return new ProductEither<T1, T2>(either);
    }

    inline public static function toString<T1, T2>(either : Either<T1, T2>) : String {
        return new ProductEither<T1, T2>(either).toString();
    }
}

class ProductEither<T1, T2> extends Product2<T1, T2> {

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
        if(Std.is(that, Either)) {
            var thatEither: Either<T1, T2> = cast that;

            var aFunk : Dynamic = switch(_either) {
                case Left(value): cast value;
                case Right(value): cast value;
            }
            var bFunk : Dynamic = Eithers.toInstance(thatEither).productElement(0);

            return aFunk == bFunk;
            // return expect(aFunk).toEqual(bFunk);
        }

        return false;
    }

    public function isLeft() : Bool {
        return Eithers.isLeft(_either);
    }

    public function isRight() : Bool {
        return Eithers.isRight(_either);
    }

    public function left() : Option<T1> {
        return Eithers.left(_either);
    }

    public function right() : Option<T2> {
        return Eithers.right(_either);
    }

    public function fold(func0 : (T1 -> T1), func1 : (T2 -> T2)) : Either<T1, T2> {
        return Eithers.fold(_either, func0, func1);
    }

    public function swap() : Either<T2, T1> {
        return Eithers.swap(_either);
    }

    public function toOption() : Option<T2> {
        return Eithers.toOption(_either);
    }

    private function toEnum() : Either<T1, T2> {
        return _either;
    }
}


