toList(value) {
  IList l = nil;
  int n;
  
  if(value is IList) {
    return value;
  } else if(value is List) {
    List ls = value;
    n = ls.length;
    
    while(--n > -1) {
      l = l.prepend(ls[n]);
    }
    
    return l;
  } else if(value is String) {
    String str = value;
    n = str.length;
    
    while(--n > -1) {
      l = l.prepend(str.substring(n, 1));
    }
    
    return l;
  } else {
    return list([value]);
  }
}
