interface ICollection<T> extends Iterable<T> {
	
  int get size();
  
  bool get hasDefinedSize();

  List<T> get toList();
}