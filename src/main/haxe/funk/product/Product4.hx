package funk.product;

import funk.product.ProductIterator;
import funk.product.Product;

interface IProduct4<A, B, C, D> implements IProduct {
}

@:keep
class Product4<A, B, C, D> extends Product, implements IProduct4<A, B, C, D> {
	
}
