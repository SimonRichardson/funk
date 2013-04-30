package funk.ds.immutable;

import funk.Funk;
import funk.ds.Collection;
import funk.ds.immutable.List;
import funk.types.Function1;
import funk.types.Function2;
import funk.types.Option;
import funk.types.Predicate1;
import funk.types.Predicate2;
import funk.types.Tuple2;
import funk.types.Any;

using funk.ds.extensions.Foldable;
using funk.ds.extensions.Reducible;
using funk.ds.extensions.Dropable;
using funk.types.Option;

enum ListType<T> {
    Nil;
    Cons(head : T, tail : List<T>);
}

abstract List<T>(ListType<T>) from ListType<T> to ListType<T> {

    inline function new(list : ListType<T>) {
        this = list;
    }

    inline public function head() : T {
        return switch(this) {
            case Cons(value, _): value;
            case Nil: null;
        }
    }

    inline public function tail() : List<T> {
        return switch (this) {
            case Cons(_, value): value;
            case Nil: Nil;
        }
    }

    inline public function iterator() : Iterator<T> return ListTypes.iterator(this);

    inline public function size() : Int return ListTypes.size(this);

    @:to
    inline public function toFoldable<T>() : Foldable<T> {
        var list : List<T> = this;
        var foldable : Foldable<T> = {
            foldLeft: function(value : T, func : Function2<T, T, T>) return ListTypes.foldLeft(list, value, func),
            foldRight: function(value : T, func : Function2<T, T, T>) return ListTypes.foldRight(list, value, func)
        };
        return foldable;
    }

    @:to
    inline public function toReducible<T>() : Reducible<T> {
        var list : List<T> = this;
        var reducible : Reducible<T> = {
            reduceLeft: function(func : Function2<T, T, T>) return ListTypes.reduceLeft(list, func),
            reduceRight: function(func : Function2<T, T, T>) return ListTypes.reduceRight(list, func)
        };
        return reducible;
    }

    @:to
    inline public function toDropable<T>() : Dropable<T> {
        var list : List<T> = this;
        var dropable : Dropable<T> = {
            dropLeft: function(amount : Int) return ListTypes.collection(ListTypes.dropLeft(list, amount)),
            dropRight: function(amount : Int) return ListTypes.collection(ListTypes.dropRight(list, amount)),
            dropWhile: function(func : Predicate1<T>) return ListTypes.collection(ListTypes.dropWhile(list, func))
        };
        return dropable;
    }

    @:from
    inline public static function fromArray<T>(array : Array<T>) : List<T> return ListUtil.toList(array);

    @:to
    inline public static function toArray<T>(list : ListType<T>) : Array<T> {
        var stack = [];
        for(i in ListTypes.iterator(list)) stack.push(i);
        return stack;
    }

    @:to
    inline public static function toCollection<T>(list : ListType<T>) : Collection<T> return ListTypes.collection(list);

    @:to
    inline public static function toString<T>(list : ListType<T>) : String return ListTypes.toString(list);
}

class ListTypes {

    public static function contains<T>(list : List<T>, item : T, ?func : Predicate2<T, T>) : Bool {
        var eq = function(a, b) {
            return null != func ? func(a, b) : a == b;
        };

        var result = false;
        var p = list;
        while(nonEmpty(p)) {
            if (eq(head(p), item)) {
                result = true;
                break;
            }
            p = tail(p);
        }
        return result;
    }

    public static function count<T>(list : List<T>, func : Predicate1<T>) : Int {
        var counter = 0;

        var p = list;
        while (nonEmpty(p)) {
            if (func(head(p))) {
                counter++;
            }
            p = tail(p);
        }
        return counter;
    }

    public static function dropLeft<T>(list : List<T>, amount : Int) : List<T> {
        if (amount < 0) {
            Funk.error(ArgumentError('Amount must be positive'));
        }

        var p = list;
        var result = p;

        if (amount > 0) {
            for (i in 0...amount) {
                if (isEmpty(p)) {
                    result = Nil;
                    break;
                }
                p = tail(p);
                result = p;
            }
        }

        return result;
    }

    public static function dropRight<T>(list : List<T>, amount : Int) : List<T> {
        var p = list;

        return if (amount < 0) {
            Funk.error(ArgumentError('Amount must be positive'));
        } else if (amount == 0) {
            p;
        } else {

            amount = size(p) - amount;
            if (amount <= 0) {
                Nil;
            } else {

                var stack = Nil;
                for (i in 0...amount) {
                    var h = head(p);
                    p = tail(p);
                    stack = prepend(stack, h);
                }

                reverse(stack);
            }
        }
    }

    public static function dropWhile<T>(list : List<T>, func : Predicate1<T>) : List<T> {
        var p = list;
        var result = Nil;
        while (nonEmpty(p)) {
            if (!func(head(p))) {
                result = p;
                break;
            }

            p = tail(p);
        }

        return result;
    }

    public static function exists<T>(list : List<T>, func : Predicate1<T>) : Bool {
        var p = list;
        var result = false;
        while (nonEmpty(p)) {
            if (func(head(p))) {
                result = true;
                break;
            }
            p = tail(p);
        }

        return result;
    }

    public static function flatMap<T1, T2>(list : List<T1>, func : Function1<T1, List<T2>>) : List<T2> {
        var stack = Nil;
        var p = list;
        while (nonEmpty(p)) {
            stack = prependAll(stack, func(head(p)));
            p = tail(p);
        }
        return reverse(stack);
    }

    inline public static function flatten<T1, T2>(list : List<T1>) : List<T2> {
        var p = list;
        return flatMap(p, function(x) return ListUtil.toList(x));
    }

    public static function filter<T>(list : List<T>, func : Predicate1<T>) : List<T> {
        var stack = Nil;
        var allFiltered = true;

        var p = list;
        var all = list;
        while (nonEmpty(p)) {
            var h = head(p);

            p = tail(p);

            if (func(h)) {
                stack = prepend(stack, h);
            } else {
                allFiltered = false;
            }
        }

        return allFiltered ? all : reverse(stack);
    }

    public static function filterNot<T>(list : List<T>, func : Predicate1<T>) : List<T> {
        var stack = Nil;
        var allFiltered = true;

        var p = list;
        var all = list;
        while (nonEmpty(p)) {
            var h = head(p);

            p = tail(p);

            if (!func(h)) {
                stack = prepend(stack, h);
            } else {
                allFiltered = false;
            }
        }

        return allFiltered ? all : reverse(stack);
    }

    public static function find<T>(list : List<T>, func : Predicate1<T>) : Option<T> {
        var result = None;
        var p = list;
        while (nonEmpty(p)) {
            if (func(head(p))) {
                result = headOption(p);
                break;
            }
            p = tail(p);
        }
        return result;
    }

    public static function findIndexOf<T>(list : List<T>, func : Predicate1<T>) : Int {
        var index = 0;
        var p = list;
        var result = -1;
        while (nonEmpty(p)) {
            if (func(head(p))) {
                result = index;
                break;
            }
            index++;
            p = tail(p);
        }
        return result;
    }

    public static function foldLeft<T1, T2>( list : List<T1>,
                                                    value : T2,
                                                    func : Function2<T2, T1, T2>
                                                    ) : Option<T2> {
        var p = list;
        while (nonEmpty(p)) {
            value = func(value, head(p));
            p = tail(p);
        }
        return Some(value);
    }

    public static function foldRight<T1, T2>(    list : List<T1>,
                                                        value : T2,
                                                        func : Function2<T2, T1, T2>
                                                        ) : Option<T2> {
        var p = list;
        p = reverse(p);
        while (nonEmpty(p)) {
            value = func(value, head(p));
            p = tail(p);
        }
        return Some(value);
    }

    public static function forall<T>(list : List<T>, func : Predicate1<T>) : Bool {
        var p = list;
        var result = true;
        while (nonEmpty(p)) {
            if (!func(head(p))) {
                result = false;
                break;
            }
            p = tail(p);
        }
        return result;
    }

    public static function foreach<T>(list : List<T>, func : Function1<T, Void>) : Void {
        var p = list;
        while (nonEmpty(p)) {
            func(head(p));
            p = tail(p);
        }
    }

    public static function get<T>(list : List<T>, index : Int) : Option<T> {
        var p = list;
        return if (index < 0 || index > size(p)) {
            None;
        } else {

            var result : Option<T> = None;
            while (nonEmpty(p)) {
                if (index == 0) {
                    result = headOption(p);
                    break;
                }

                index--;
                p = tail(p);
            }

            result;
        }
    }

    public static function indexOf<T>(list : List<T>, value : T) : Int {
        var index = 0;
        var p = list;
        var result = -1;
        while (nonEmpty(p)) {
            if (AnyTypes.equals(head(p), value)) {
                result = index;
                break;
            }
            index++;
            p = tail(p);
        }
        return result;
    }

    public static function insert<T>(list : List<T>, value : T, index : Int) : List<T> {
        var added = false;

        var stack = Nil;
        var p = list;
        while (nonEmpty(p)) {
            if (index-- == 0) {
                stack = prepend(stack, value);
                added = true;
            }

            stack = prepend(stack, head(p));

            p = tail(p);
        }

        if (!added) stack = prepend(stack, value);

        return reverse(stack);
    }

    public static function map<T, E>(list : List<T>, func : Function1<T, E>) : List<E> {
        var stack = Nil;
        var p = list;
        while (nonEmpty(p)) {
            stack = prepend(stack, func(head(p)));
            p = tail(p);
        }
        return reverse(stack);
    }

    public static function partition<T>(list : List<T>, func : Predicate1<T>) : Tuple2<List<T>, List<T>> {
        var left = Nil;
        var right = Nil;

        var p = list;
        while (nonEmpty(p)) {
            var h = head(p);
            if (func(h)) left = prepend(left, h);
            else right = prepend(right, h);
            
            p = tail(p);
        }

        return tuple2(reverse(left), reverse(right));
    }

    public static function reduceLeft<T>(list : List<T>, func : Function2<T, T, T>) : Option<T> {
        var p = list;
        return if (size(p) < 1) None;
        else {

            var value = head(p);
            p = tail(p);
            while (nonEmpty(p)) {
                value = func(value, head(p));
                p = tail(p);
            }

            Some(value);
        }
    }

    public static function reduceRight<T>(list : List<T>, func : Function2<T, T, T>) : Option<T> {
        var p = list;
        return if (size(p) < 1) None;
        else {

            p = reverse(p);
            var value = head(p);
            p = tail(p);
            while (nonEmpty(p)) {
                value = func(value, head(p));
                p = tail(p);
            }

            Some(value);
        }
    }

    public static function takeLeft<T>(list : List<T>, amount : Int) : List<T> {
        var p = list;
        return if (amount < 0) Funk.error(ArgumentError('Amount must be positive'));
        else if (amount == 0) Nil;
        else if (amount > size(p)) p;
        else {

            var stack = Nil;
            for (i in 0...amount) {
                stack = prepend(stack, head(p));
                p = tail(p);
            }

            reverse(stack);
        }
    }

    public static function takeRight<T>(list : List<T>, amount : Int) : List<T> {
        var p = list;
        return if (amount < 0) Funk.error(ArgumentError('Amount must be positive'));
        else if (amount == 0) Nil;
        else if (amount > size(p)) p;
        else {

            p = reverse(p);

            var stack = Nil;
            for (i in 0...amount) {
                stack = prepend(stack, head(p));
                p = tail(p);
            }

            stack;
        }
    }

    public static function takeWhile<T>(list : List<T>, func : Predicate1<T>) : List<T> {
        var stack = Nil;
        var p = list;
        while (nonEmpty(p)) {
            var h = head(p);
            if (func(h)) stack = prepend(stack, h);
            p = tail(p);
        }
        return reverse(stack);
    }

    public static function zip<T1, T2>(list : List<T1>, other : List<T2>) : List<Tuple2<T1, T2>> {
        var p = list;
        var amount = Std.int(Math.min(size(p), size(other)));

        return if (amount <= 0) Nil;
        else {

            var stack = Nil;
            for (i in 0...amount) {
                var tuple : Tuple2<T1, T2> = tuple2(head(p), head(other));
                stack = prepend(stack, tuple);
                p = tail(p);
                other = tail(other);
            }

            reverse(stack);
        }
    }

    inline public static function append<T>(list : List<T>, item : T) : List<T> {
        return appendAll(list, Cons(item, Nil));
    }

    public static function appendAll<T>(list : List<T>, items : List<T>) : List<T> {
        var result = items;
        var p = list;

        var stack = reverse(p);
        while(nonEmpty(stack)) {
            result = Cons(head(stack), result);
            stack = tail(stack);
        }

        return result;
    }

    public static function appendIterator<T>(list : List<T>, iterator : Iterator<T>) : List<T> {
        var result : List<T> = Nil;
        while(iterator.hasNext()) {
            result = Cons(iterator.next(), result);
        }
        return result;
    }

    public static function appendIterable<T>(list : List<T>, iterable : Iterable<T>) : List<T> {
        return appendIterator(list, iterable.iterator());
    }

    inline public static function prepend<T>(list : List<T>, item : T) : List<T> return Cons(item, list);

    public static function prependAll<T>(list : List<T>, items : List<T>) : List<T> {
        var p = list;
        var result = p;

        while(nonEmpty(items)) {
            result = Cons(head(items), result);
            items = tail(items);
        }

        return result;
    }

    public static function prependIterator<T>(list : List<T>, iterator : Iterator<T>) : List<T> {
        var result : List<T> = Nil;
        while(iterator.hasNext()) {
            result = Cons(iterator.next(), result);
        }
        return result;
    }

    public static function prependIterable<T>(list : List<T>, iterable : Iterable<T>) : List<T> {
        return prependIterator(list, iterable.iterator());
    }

    inline public static function head<T>(list : List<T>) : T {
        return switch(list) {
            case _ if(list == null): null;
            case Cons(head, _): head;
            case _: null;
        }
    }

    inline public static function headOption<T>(list : List<T>) : Option<T> {
        return switch(list) {
            case _ if(list == null): None;
            case Cons(head, _): Some(head);
            case _: None;
        }
    }

    inline public static function tail<T>(list : List<T>) : List<T> {
        return switch(list) {
            case _ if(list == null): Nil;
            case Cons(_, tail): tail;
            case _: Nil;
        }
    }

    inline public static function tailOption<T>(list : List<T>) : Option<List<T>> {
        var p = list;
        return if (null == p) None;
        else {
            switch(p) {
                case Cons(_, tail): Some(tail);
                case _: None;
            }
        }
    }

    public static function reverse<T>(list : List<T>) : List<T> {
        // Note (Simon) : We do it this way because as3 gets very confused about using.
        function recursive(p, stack) {
            return switch(p) {
                case Cons(head, tail): recursive(tail, Cons(head, stack));
                case _: stack;
            }
        }

        return recursive(list, Nil);
    }

    public static function size<T>(list : List<T>) : Int {
        var count = 0;

        var p = list;
        while(nonEmpty(p)) {
            count++;
            p = tail(p);
        }

        return count;
    }

    public static function indices<T>(list : List<T>) : List<Int> {
        var p = list;
        var n = size(p);
        var stack = Nil;
        while(--n > -1) {
            stack = prepend(stack, n);
        }
        return stack;
    }

    inline public static function init<T>(list : List<T>) : List<T> return dropRight(list, 1);

    public static function last<T>(list : List<T>) : Option<T> {
        var value = None;

        var p = list;
        while(nonEmpty(p)) {
            value = headOption(p);
            p = tail(p);
        }

        return value;
    }

    public static function zipWithIndex<T>(list : List<T>) : List<Tuple2<T, Int>> {
        var p = list;
        var amount = size(p);

        var stack = Nil;
        for (i in 0...amount) {
            var h = head(p);
            p = tail(p);

            var tuple : Tuple2<T, Int> = tuple2(h, i);
            stack = prepend(stack, tuple);
        }

        return reverse(stack);
    }

    inline public static function isEmpty<T>(list : List<T>) : Bool {
        return switch(list) {
            case Cons(_, _): false;
            case _: true;
        };
    }

    inline public static function nonEmpty<T>(list : List<T>) : Bool return !isEmpty(list);

    inline public static function hasDefinedSize<T>(list : List<T>) : Bool {
        return switch (list) {
            case Cons(_, _): true;
            case _: false;
        };
    }

    inline public static function collection<T>(list : List<T>) : Collection<T> return new ListInstanceImpl(list);

    inline public static function iterable<T>(list : List<T>) : Iterable<T> return new ListInstanceImpl(list);

    inline public static function iterator<T>(list : List<T>) : Iterator<T> return iterable(list).iterator();

    inline public static function toString<T>(list : List<T>, ?func : Function1<T, String>) : String {
        var p = list;
        return switch(p) {
            case Cons(_, _):
                var mapped : Collection<String> = CollectionTypes.map(collection(p), function(value) {
                    return AnyTypes.toString(value, func);
                });
                var folded : Option<String> = CollectionTypes.foldLeftWithIndex(mapped, '', function(a, b, index) {
                    return index < 1 ? b : '$a, $b';
                });
                'List(${folded.get()})';
            case _: 'Nil';
        }
    }
}

private class ListInstanceImpl<T> {

    private var _list : List<T>;

    private var _knownSize : Bool;

    private var _size : Int;

    public function new(list : List<T>) {
        _list = list;

        _size = 0;
        _knownSize = false;
    }

    public function iterator() : Iterator<T> {
        var list = _list;
        return {
            hasNext: function() return ListTypes.nonEmpty(list),
            next: function() {
                return if (ListTypes.nonEmpty(list)) {
                    var value = ListTypes.head(list);
                    list = ListTypes.tail(list);
                    value;
                } else Funk.error(NoSuchElementError);
            }
        };
    }

    public function size() : Int {
        if (_knownSize) return _size;

        _size = ListTypes.size(_list);
        _knownSize = true;

        return _size;
    }
}
