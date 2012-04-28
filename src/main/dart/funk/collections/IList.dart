interface IList<T> extends IProduct<T>, ICollection<T> {
	
	
  bool contains(T value);
	
  int count(Function func);
	
  bool get nonEmpty();
	
	IList<T> dropRight(int total);
	
	IList<T> dropWhile(Function func);
	
	bool exists(Function func);
	
	IList<T> filter(Function func);
	
	IList<T> filterNot(Function func);
	
	Option<T> find(Function func);
	
	int findIndexOf(Function func);
	
	IList<T> flatMap(Function func);
	
	IList<T> get flatten();
	
	Option<T> foldLeft(T x, Function func);
	
	Option<T> foldRight(T x, Function func);
	
	bool forall(Function func);
	
	void foreach(Function func);
	
	Option<T> get(int index);
	
	Option<T> get head();
	
	int indexOf(T value);
	
	IList<int> get indices();
	
	IList<T> get init();
	
	bool get isEmpty();
	
	Option<T> get last();
	
	IList<T> map(Function f);
	
	Tuple2<IList<T>, IList<T>> partition(Function func);
	
	IList<T> prepend(T value);
	
	IList<T> prependAll(IList<T> value);
	
	IList<T> prependIterator(Iterator<T> iterator);
	
	IList<T> prependIterable(Iterable<T> iterable);
	
	IList<T> append(T value);
	
	IList<T> appendAll(IList<T> value);
	
	IList<T> appendIterator(Iterator<T> iterator);
	
	IList<T> appendIterable(Iterable<T> iterable);
	
	Option<T> reduceLeft(Function func);
	
	Option<T> reduceRight(Function func);
	
	IList<T> get reverse();
	
	Option<IList<T>> get tail();
	
	IList<T> take(int index);
	
	IList<T> takeRight(int index);
	
	IList<T> takeWhile(Function func);
	
	IList<Tuple2<T, T>> zip(IList<T> that);
	
	IList<Tuple2<T, int>> get zipWithIndex();
	
}