package funk.net.http;

import funk.collections.immutable.List;
import haxe.ds.Option;

typedef HttpResponse<T> = {
	code : Option<HttpStatusCode>,
	body : Option<T>,
	headers : List<HttpHeader>
}