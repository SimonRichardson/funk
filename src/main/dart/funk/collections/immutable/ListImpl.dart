class ListImpl<T> extends Product<T> implements IList<T>  {
  
  Option<T> _head;
  
  Option<IList<T>> _tail;
  
  ListImpl(T head, IList<T> tail) {
    _head = head is Option ? head : some(head);
    _tail = some(tail);
  }
  
  bool contains(T value) => false;

  int count(Function func) => 0;

  bool get nonEmpty() => false;

  IList<T> drop(int total) {
    require(total >= 0, "total must be positive.");
    return this;
  }

  IList<T> dropRight(int total) {
    require(total >= 0, "total must be positive.");
    return this;
  }

  IList<T> dropWhile(Function func) => this;

  bool exists(Function func) => false;

  IList<T> filter(Function func) => this;

  IList<T> filterNot(Function func) => this;

  Option<T> find(Function func) => none;

  IList<T> flatMap(Function func) => this;

  Option<T> foldLeft(T x, Function func) => some(x);

  Option<T> foldRight(T x, Function func) => some(x);

  bool forall(Function func) => false;

  void foreach(Function func){}

  Option<T> get(int index) {
    throw new RangeError([]);
  }

  Option<T> get head(){
    throw new NoSuchElementException([]);
  }

  Option<T> get headOption() => none;

  IList<int> get indices() => none;

  IList<T> get init() => this;

  bool get isEmpty() => true;

  Option<T> get last() {
    throw new NoSuchElementException([]);
  }

  IList<T> map(Function func) => this;

  Tuple2<IList<T>, IList<T>> partition(Function func) => tuple2(this, this);

  IList<T> prepend(T value) => new ListImpl(value, this);

  IList<T> prependAll(IList<T> value) => value;

  Option<T> reduceLeft(Function func) => none;

  Option<T> reduceRight(Function func) => none;

  IList<T> get reverse() => this;

  Option<IList<T>> get tail() => none;

  IList<T> take(int total) {
    require(total >= 0, "total must be positive.");
    return this;
  }

  IList<T> takeRight(int total) {
    require(total >= 0, "total must be positive.");
    return this;
  }

  IList<T> takeWhile(Function func) => this;
  
  IList<Tuple2<T, T>> zip(IList<T> that) => none;

  IList<Tuple2<T, int>> get zipWithIndex() => none;

  int get size() => 0;

  bool get hasDefinedSize() => true;

  int findIndexOf(Function func) => -1;

  IList<T> get flatten() => none;

  int indexOf(T value) => -1;

  int get productArity() => 0;

  T productElement(int index) {
    throw new RangeError([]);
  }

  String get productPrefix() => "List";

  IList<T> prependIterator(Iterator<T> itr) => itr.toList;

  IList<T> prependIterable(Iterable<T> iterable) => iterable.iterator.toList;

  IList<T> append(T value) => new ListImpl(value, this);

  IList<T> appendAll(IList<T> value) => value;

  IList<T> appendIterator(Iterator<T> itr) => itr.toList;

  IList<T> appendIterable(Iterable<T> iterable) => iterable.iterator.toList;

  List<T> get toList() => new List();
  
  Iterator<T> iterator() => new NilIterator<T>();
}

class ListIterator<T> implements Iterator<T> {
  
  ListIterator(){
  }
  
  bool hasNext() => false;
  
  T next() {
    throw new NoSuchElementException([]);
  }
}

list(List args) {
  IList l = nil;
  int n = args.length;

  while(--n > -1) {
    l = l.prepend(args[n]);
  }

  return l;
}
