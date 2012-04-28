class IteratorUtil {
  
  static IList toList(final Iterator itr) {
    IList l = nil;
    
    while(itr.hasNext()) {
      l = l.prepend(itr.next());
    }
    
    return l.reverse;
  }
}
