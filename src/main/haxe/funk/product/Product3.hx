package funk.product;

import funk.product.ProductIterator;
import funk.product.Product;

interface IProduct3<A, B, C> implements IProduct {
	
}

@:keep
class Product3<A, B, C> extends Product, implements IProduct3<A, B, C> {
	
}
