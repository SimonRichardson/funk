package funk.either;

import funk.IFunkObject;
import funk.errors.RangeError;
import funk.product.Product2;
import funk.product.ProductIterator;
import funk.option.Option;

enum Either<A, B> {
    Left(value : A);
    Right(value : B);
}

class EitherType {

    inline public static function isLeft<A, B>(either : Either<A, B>) : Bool {
        return switch(either) {
            case Left(value): true;
            case Right(value): false;
        }
    }

    inline public static function isRight<A, B>(either : Either<A, B>) : Bool {
        return switch(either) {
            case Left(value): false;
            case Right(value): true;
        }
    }

    inline public static function left<A, B>(either : Either<A, B>) : Option<A> {
        return switch(either) {
            case Left(value): Some(value);
            case Right(value): None;
        }
    }

    inline public static function right<A, B>(either : Either<A, B>) : Option<B> {
        return switch(either) {
            case Left(value): None;
            case Right(value): Some(value);
        }
    }

    inline public static function fold<A, B>(either : Either<A, B>, func0 : (A -> A), func1 : (B -> B)) : Either<A, B> {
        return switch(either) {
            case Left(value): Left(func0(value));
            case Right(value): Right(func1(value));
        }
    }

    inline public static function swap<A, B>(either : Either<A, B>) : Either<B, A> {
        return switch(either) {
            case Left(value): Right(value);
            case Right(value): Left(value);
        }
    }

    inline public static function instance<A, B>(either : Either<A, B>) : ProductEither<A, B> {
        return new ProductEither<A, B>(either);
    }

    inline public static function productIterator<A, B>(either : Either<A, B>) : IProductIterator<Dynamic> {
        return new ProductEither<A, B>(either).productIterator();
    }

    inline public static function toString<A, B>(either : Either<A, B>) : String {
        return new ProductEither<A, B>(either).toString();
    }
}

class ProductEither<A, B> extends Product2<A, B> {

    private var _either : Either<A, B>;

    public function new(either : Either<A, B>) {
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
            var thatEither: Either<A, B> = cast that;

            var aFunk : Dynamic = switch(_either) {
                case Left(value): cast value;
                case Right(value): cast value;
            }
            var bFunk : Dynamic = EitherType.instance(thatEither).productElement(0);

            return aFunk == bFunk;
            // return expect(aFunk).toEqual(bFunk);
        }

        return false;
    }
}

