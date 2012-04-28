interface Tuple2<A, B> extends ITuple default TupleImpl2 {
  A get _1();
  B get _2();
}

class TupleImpl2<A, B> extends Product implements Tuple2<A, B> {
  
  A __1;
  B __2;
  
  TupleImpl2(A _1, B _2) {
    __1 = _1;
    __2 = _2;
  }
  
  A get _1() => __1;
  B get _2() => __2;
  
  productElement(int index) {
    if(index >= productArity) {
      throw new RangeError([]);
    }
    
    if(index == 0) {
      return _1;
    } else {
      return _2;
    }
  }

  int get productArity() => 2;

  String get productPrefix() => "Tuple";
}

tuple2(_1, _2) => new TupleImpl2(_1, _2); 