class NilImpl<T> extends Product<T> implements IList<T> {
  
  static NilImpl _instance;
  
  factory NilImpl(){
    if(_instance == null) {
      _instance = new NilImpl._internal();
    }
    return _instance;
  }
  
  NilImpl._internal();
  
  int hashCode() => 0;
  
  bool equals(IFunkObject obj) {
    if(obj is NilImpl) {
      return hashCode() == obj.hashCode();
    }
    return false;
  }
  
  bool contains(final T value) => false;

  int count(final Function func) => 0;

  bool get nonEmpty() => false;

  IList<T> drop(final int total) {
    require(total >= 0, "total must be positive.");
    return this;
  }

  IList<T> dropRight(final int total) {
    require(total >= 0, "total must be positive.");
    return this;
  }

  IList<T> dropWhile(final Function func) => this;

  bool exists(final Function func) => false;

  IList<T> filter(final Function func) => this;

  IList<T> filterNot(final Function func) => this;

  Option<T> find(final Function func) => none;

  IList<T> flatMap(final Function func) => this;

  Option<T> foldLeft(final T x, final Function func) => some(x);

  Option<T> foldRight(final T x, final Function func) => some(x);

  bool forall(final Function func) => false;

  void foreach(final Function func){}

  Option<T> get(final int index) {
    throw new RangeError([]);
  }

  Option<T> get head(){
    throw new NoSuchElementException([]);
  }

  IList<int> get indices() => none;

  IList<T> get init() => this;

  bool get isEmpty() => true;

  Option<T> get last() {
    throw new NoSuchElementException([]);
  }

  IList<T> map(final Function func) => this;

  Tuple2<IList<T>, IList<T>> partition(final Function func) => tuple2(this, this);

  IList<T> prepend(final T value) => new ListImpl<T>(value, this);

  IList<T> prependAll(final IList<T> value) => value;

  Option<T> reduceLeft(final Function func) => none;

  Option<T> reduceRight(final Function func) => none;

  IList<T> get reverse() => this;

  Option<IList<T>> get tail() => none;

  IList<T> take(final int total) {
    require(total >= 0, "total must be positive.");
    return this;
  }

  IList<T> takeRight(final int total) {
    require(total >= 0, "total must be positive.");
    return this;
  }

  IList<T> takeWhile(final Function func) => this;
  
  IList<Tuple2<T, T>> zip(final IList<T> that) => none;

  IList<Tuple2<T, int>> get zipWithIndex() => none;

  int get size() => 0;

  bool get hasDefinedSize() => true;

  int findIndexOf(final Function func) => -1;

  IList<T> get flatten() => none;

  int indexOf(final T value) => -1;

  int get productArity() => 0;

  T productElement(final int index) {
    throw new RangeError([]);
  }

  String get productPrefix() => "List";

  IList<T> prependIterator(final Iterator<T> itr) => IteratorUtil.toList(itr);

  IList<T> prependIterable(final Iterable<T> iterable) => IteratorUtil.toList(iterable.iterator());

  IList<T> append(final T value) => new ListImpl(value, this);

  IList<T> appendAll(final IList<T> value) => value;

  IList<T> appendIterator(final Iterator<T> itr) => IteratorUtil.toList(itr);

  IList<T> appendIterable(final Iterable<T> iterable) => IteratorUtil.toList(iterable.iterator());

  List<T> get toList() => new List<T>();
  
  Iterator<T> iterator() => new NilIterator<T>();
}

class NilIterator<T> implements Iterator<T> {
  
  static NilIterator _instance;
  
  factory NilIterator(){
    if(_instance == null) {
      _instance = new NilIterator._internal(); 
    }
    return _instance;
  }
  
  NilIterator._internal();
  
  bool hasNext() => false;
  
  T next() {
    throw new NoSuchElementException([]);
  }
}

get nil() => new NilImpl();
