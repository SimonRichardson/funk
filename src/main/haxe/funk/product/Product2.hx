package funk.product;

import funk.product.ProductIterator;
import funk.product.Product;

interface IProduct2<A, B> implements IProduct {
}

@:keep
class Product2<A, B> extends Product, implements IProduct2<A, B> {
}