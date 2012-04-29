class ListImpl<T> extends Product<T> implements IList<T>  {
  
  Option<T> _head;
  
  Option<IList<T>> _tail;
  
  int _length;
  
  bool _lengthKnown;
  
  ListImpl(T head, IList<T> tail) {
    _head = head is Option ? head : some(head);
    _tail = some(tail);
    
    _length = 0;
    _lengthKnown = false;
  }
  
  bool contains(T value) {
    IList<T> p = this;
    
    while(p.nonEmpty) {
      if(eq(p.head, value)) {
        return true;
      }
      p = p.tail.get;
    }
    
    return false;
  }

  int count(Function func) {
    int n = 0;
    IList<T> p = this;
    
    while(p.nonEmpty) {
      if(func(p.head)) {
        n++;
      }
      p = p.tail.get;
    }
    
    return n;
  }

  bool get nonEmpty() => true;

  IList<T> drop(int total) {
    require(total >= 0, "total must be positive.");
    
    IList<T> p = this;
    
    for(int i = 0; i < total; ++i) {
      if(p.isEmpty) {
        return nil;
      }
      
      p = p.tail.get;
    }
    
    return p;
  }

  IList<T> dropRight(int total) {
    require(total >= 0, "total must be positive.");
    
    int n = total;
    
    if(0 == n) {
      return this;
    }
    
    n = size - n;

    if(n <= 0) {
      return nil;
    }

    final List<ListImpl<T>> buffer = new List(n);
    int m = n - 1;
    int i = 0;
    
    IList<T> p  = this;
    for(i = 0; i < n; ++i) {
      buffer[i] = new ListImpl(p.head, null);
      p = p.tail.get;
    }

    buffer[m]._tail = nil;
    
    int j = 1;
    for(i = 0; i < m; ++i) {
      buffer[i]._tail = some(buffer[j]);
      ++j;
    }

    return buffer[0];
  }

  IList<T> dropWhile(Function func) {
    IList<T> p = this;
    
    while(p.nonEmpty) {
      if(!func(p.head)) {
        return p;
      }
      
      p = p.tail.get;
    }
    
    return nil;
  }

  bool exists(Function func) {
    IList<T> p = this;
    
    while(p.nonEmpty) {
      if(func(p.head)) {
        return true;
      }
      
      p = p.tail.get;
    }
    
    return false;
  }

  IList<T> filter(Function func) {
    IList<T> p = this;
    ListImpl q = null;
    ListImpl first = null;
    ListImpl last = null;
    bool allFiltered = false;
    
    while(p.nonEmpty) {
      if(func(p.head)) {
        q = new ListImpl(p.head, nil);
        
        if(last != null) {
          last._tail = some(q);
        }
        
        if(first == null) {
          first = q;
        }
        
        last = q;
      } else {
        allFiltered = false;
      }
      
      p = p.tail.get;
    }
    
    if(allFiltered) {
      return this;
    }
    
    return (first == null) ? nil : first;
  }

  IList<T> filterNot(Function func) {
    IList<T> p = this;
    ListImpl q = null;
    ListImpl first = null;
    ListImpl last = null;
    bool allFiltered = false;
    
    while(p.nonEmpty) {
      if(!func(p.head)) {
        q = new ListImpl(p.head, nil);
        
        if(last != null) {
          last._tail = some(q);
        }
        
        if(first == null) {
          first = q;
        }
        
        last = q;
      } else {
        allFiltered = false;
      }
      
      p = p.tail.get;
    }
    
    if(allFiltered) {
      return this;
    }
    
    return (first == null) ? nil : first;
  }

  Option<T> find(Function func)  {
    IList<T> p = this;
    
    while(p.nonEmpty) {
      if(func(p.head)) {
        return p.head;
      }
      
      p = p.tail.get;
    }
    
    return none;
  }

  IList<T> flatMap(Function func) {
    int n = size;
    List<IList<T>> buffer = new List<IList<T>>(n);
    IList<T> p = this;
    int i = 0;

    while(p.nonEmpty) {
      buffer[i++] = verifiedType(func(p.head), new ListType<IList<T>>());
      p = p.tail.get;
    }

    IList<T> l = buffer[--n];

    while(--n > -1) {
      l = l.prependAll(buffer[n]);
    }

    return l;
  }

  Option<T> foldLeft(T x, Function func) {
    T value = x;
    IList<T> p = this;

    while(p.nonEmpty) {
      value = func(value, p.head);
      p = p.tail.get;
    }

    return some(value);
  }

  Option<T> foldRight(T x, Function func) {
    T value = x;
    List<T> buffer = toList;
    
    int n = buffer.length;

    while(--n > -1) {
      value = func(value, buffer[n]);
    }

    return some(value);
  }

  bool forall(Function func) {
    IList<T> p = this;

    while(p.nonEmpty) {
      if(!func(p.head)) {
        return false;
      }

      p = p.tail.get;
    }

    return true;
  }

  void foreach(Function func){
    IList<T> p = this;

    while(p.nonEmpty) {
      func(p.head);
      p = p.tail.get;
    }
  }

  Option<T> get(int index) {
    throw new RangeError([]);
  }

  Option<T> get head(){
    return _head;
  }

  IList<int> get indices() {
    int n = size;
    IList<int> p = nil;

    while(--n > -1) {
      p = p.prepend(n);
    }
    
    return p;
  }

  IList<T> get init() => dropRight(1);

  bool get isEmpty() => false;

  Option<T> get last() {
    IList<T> p = this;
    Option<T> value = none;
    
    while(p.nonEmpty) {
      value = p.head;
      p = p.tail.get;
    }
    
    return value;
  }

  IList<T> map(Function func) {
    final int n = size;
    final List<ListImpl<T>> buffer = new List<ListImpl<T>>(n);
    final int m = n - 1;
    
    IList<T> p = this;
    int i = 0;
    int j = 0;

    for(i = 0; i < n; ++i) {
      buffer[i] = new ListImpl<T>(func(p.head), null);
      p = p.tail.get;
    }

    buffer[m]._tail = nil;
    
    j = 1;
    for(i = 0; i < m; ++i) {
      buffer[i]._tail = some(buffer[j]);
      ++j;
    }

    return buffer[0];
  }

  Tuple2<IList<T>, IList<T>> partition(Function func) {
    final List<ListImpl<T>> left = new List<ListImpl<T>>();
    final List<ListImpl<T>> right = new List<ListImpl<T>>();

    int i = 0;
    int j = 0;
    int m = 0;
    int o = 0;

    IList<T> p = this;

    while(p.nonEmpty) {
      if(func(p.head)) {
        left[i++] = new ListImpl(p.head, nil);
      } else {
        right[j++] = new ListImpl(p.head, nil);
      }

      p = p.tail.get;
    }

    m = i - 1;
    o = j - 1;

    if(m > 0) {
      j = 1;
      for(i = 0; i < m; ++i) {
        left[i]._tail = some(left[j]);
        ++j;
      }
    }

    if(o > 0) {
      j = 1;
      for(i = 0; i < o; ++i) {
        right[i]._tail = some(right[j]);
        ++j;
      }
    }

    return tuple2(m > 0 ? left[0] : nil, o > 0 ? right[0] : nil);
  }

  IList<T> prepend(T value) => new ListImpl(value, this);

  IList<T> prependAll(IList<T> value) => value;

  Option<T> reduceLeft(Function func) {
    IList<T> p = this._tail.get;
    Option<T> value = head;
    
    while(p.nonEmpty) {
      value = func(value, p.head);
      p = p.tail.get;
    }
    
    return value;
  }

  Option<T> reduceRight(Function func) {
    List<T> buffer = toList;
    T value = buffer.removeLast();
    int n = buffer.length;
    
    while(--n > -1) {
      value = func(value, buffer[n]);
    }
    
    return some(value);
  }

  IList<T> get reverse() {
    IList<T> result = nil;
    IList<T> p = this;

    while(p.nonEmpty) {
      result = result.prepend(when(p.head, {
        "none": () => null,
        "some": (value) => value
      }));
      p = p.tail.get;
    }

    return result; 
  }

  Option<IList<T>> get tail() => _tail;

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
  
  IList<T> _list;
  
  ListIterator(IList<T> list){
    _list = list;
  }
  
  bool hasNext() => _list.nonEmpty;
  
  T next() {
    if(_list == nil) {
      throw new NoSuchElementException([]);
    }
    
    final T head = _list.head.get;
    _list = _list.tail.get;
    
    return head;
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
