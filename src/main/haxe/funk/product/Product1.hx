package funk.product;

import funk.product.ProductIterator;
import funk.product.Product;

interface IProduct1<T> implements IProduct {
}

class Product1<T> extends Product, implements IProduct1<T> {
	
}