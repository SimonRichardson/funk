interface Tuple1<A> extends ITuple default TupleImpl1 {
  A get _1();
}

class TupleImpl1<A> extends Product implements Tuple1<A> {
  
  A __1;
  
  TupleImpl1(A _1) {
    __1 = _1;
  }
  
  A get _1() => __1;
  
  A productElement(int index) {
    if(index >= productArity) {
      throw new RangeError([]);
    }
    return _1;
  }

  int get productArity() => 1;

  String get productPrefix() => "Tuple";
}

tuple1(_1) => new TupleImpl1(_1); 