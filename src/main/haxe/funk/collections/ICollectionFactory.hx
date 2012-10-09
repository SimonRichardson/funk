package funk.collections;

interface ICollectionFactory<T> {
	
	function createNil() : ICollection<T>;
}
