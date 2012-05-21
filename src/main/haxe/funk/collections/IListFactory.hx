package funk.collections;

import funk.collections.IList;

interface IListFactory<T> {
	
	function createList(value : T, tail : IList<T>) : IList<T>;
	
	function createNilList() : IList<T>;
}
