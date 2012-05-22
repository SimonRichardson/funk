import funk.collections.HashMapNil;
import funk.collections.ICollection;
import funk.collections.ICollectionFactory;
import funk.collections.IList;
import funk.collections.IListFactory;
import funk.collections.immutable.HashMap;
import funk.collections.immutable.HashMapIterator;
import funk.collections.immutable.List;
import funk.collections.immutable.ListIterator;
import funk.collections.immutable.Nil;
import funk.collections.ISet;
import funk.collections.ISetFactory;
import funk.collections.IteratorUtil;
import funk.collections.ListNil;
import funk.collections.ListUtil;
import funk.collections.mutable.HashMap;
import funk.collections.mutable.List;
import funk.collections.mutable.ListIterator;
import funk.collections.mutable.Nil;
import funk.collections.NilIterator;
import funk.collections.Range;
import funk.errors.ArgumentError;
import funk.errors.FunkError;
import funk.errors.IllegalOperationError;
import funk.errors.NoSuchElementError;
import funk.errors.RangeError;
import funk.errors.TypeError;
import funk.Fork;
import funk.FunkObject;
import funk.ioc.Binding;
import funk.ioc.errors.BindingError;
import funk.ioc.errors.IOCError;
import funk.ioc.Inject;
import funk.ioc.Injector;
import funk.ioc.IProvider;
import funk.ioc.IScope;
import funk.ioc.Module;
import funk.Lazy;
import funk.option.Any;
import funk.option.Option;
import funk.Pass;
import funk.product.Product;
import funk.product.ProductIterator;
import funk.signal.Signal;
import funk.signal.Signal0;
import funk.signal.Signal1;
import funk.signal.Signal2;
import funk.signal.Slot;
import funk.signal.Slot0;
import funk.signal.Slot1;
import funk.signal.Slot2;
import funk.tuple.Tuple;
import funk.tuple.Tuple1;
import funk.tuple.Tuple2;
import funk.tuple.Tuple3;
import funk.tuple.Tuple4;
import funk.unit.Expect;
import funk.util.Reflect;
import funk.util.Require;
import funk.util.RequireRange;
import funk.Wildcard;
class All{}