package funk.collections;

import funk.FunkObject;

interface ICollection<T> implements IFunkObject {
	
    var size(dynamic, never): Int;
    
    var hasDefinedSize(dynamic, never): Bool;

    var toArray(dynamic, never): Array<T>;
}
