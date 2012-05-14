package funk.ioc;

interface IProvider<T> {

	function get() : T;
}
