package funk.collections;

import funk.FunkObject;

interface ICollection<T> implements IFunkObject {
	
	/**
     * The total number of elements in the collection.
     */
    var size(dynamic, never): Int;

    /**
     * Whether or not the size of the collection is known.
     */
    var hasDefinedSize(dynamic, never): Bool;

    /**
     * The elements of the collection stored in an array.
     */
    var toArray(dynamic, never): Array<T>;
}
