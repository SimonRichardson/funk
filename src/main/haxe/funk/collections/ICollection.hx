package funk.collections;

import funk.IFunkObject;

interface ICollection<T> implements IFunkObject {
	
    var size(dynamic, never): Int;
    
    var hasDefinedSize(dynamic, never): Bool;

    var toArray(dynamic, never): Array<T>;
}
