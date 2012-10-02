package funk.either;

import funk.IFunkObject;
import funk.errors.RangeError;
import funk.product.Product;
import funk.option.Option;
import funk.util.Expect;

enum Either<A, B> {
    Left(value : A);
    Right(value : B);
}

class EitherType {

    inline public static function isLeft<A, B>(either : Either<A, B>) : Bool {
        return switch(option) {
            case Left(value): true;
            case Right(value): false;
        }
    }

    inline public static function isRight<A, B>(either : Either<A, B>) : Bool {
        return switch(option) {
            case Left(value): false;
            case Right(value): true;
        }
    }

    inline public static function left<A, B>(either : Either<A, B>) : Option<A> {
        return switch(option) {
            case Left(value): Some(value);
            case Right(value): None;
        }
    }

    inline public static function right<A, B>(either : Either<A, B>) : Option<B> {
        return switch(option) {
            case Left(value): None;
            case Right(value): Some(value);
        }
    }

    inline public static function fold<A, B>(either : Either<A, B>, func0 : (A -> A), func1 : (B -> B)) : Either<A, B> {
        return switch(option) {
            case Left(value): Left(func0(value));
            case Right(value): Right(func1(value));
        }
    }

    inline public static function swap<A, B>(either : Either<A, B>) : Either<B, A> {
        return switch(option) {
            case Left(value): Right(value);
            case Right(value): Left(value);
        }
    }

    inline public static function instance<A, B>(either : Either<A, B>) : ProductEither<A, B> {
        return new ProductEither<A, B>(either);
    }

    inline public static function iterator<A, B>(either : Either<A, B>) : IProductIterator<Dynamic> {
        return new ProductEither<A, B>(either).iterator();
    }
}

class ProductEither<A, B> extends Product {

    private var _either : Either<A, B>;

    public function new(either : Either<A, B>) {
        super();

        _either = either;
    }

    override private function get_productArity() : Int {
        return switch(_option) {
            case Left(value): 1;
            case Right(value): 1;
        }
    }

    override private function get_productPrefix() : String {
        return Type.enumConstructor(_either);
    }

    override public function productElement(index : Int) : Dynamic {
        return if(index == 0) {
            switch(_either) {
                case Left(value): value;
                case Right(value): value;
            }
        } else {
            throw new RangeError();
        }
    }

    override public function equals(that: IFunkObject): Bool {
        if(Std.is(that, Either)) {
            var thatEither: Either<A, B> = cast that;

            var aFunk : Dynamic = switch(_either) {
                case Left(value): value;
                case Right(value): value;
            }
            var bFunk : Dynamic = EitherType.instance(thatOption).productElement(0);

            return expect(aFunk).toEqual(bFunk);
        }

        return false;
    }
}

