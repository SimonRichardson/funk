package funk.io.http;

import funk.collections.immutable.List;
import funk.io.http.JsonLoader;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.HttpStatusCode;
import funk.net.http.UriRequest;
import funk.reactive.Stream;
import funk.types.Promise;
import haxe.Http;

import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using funk.collections.immutable.extensions.Lists;
using funk.net.http.extensions.HttpHeaders;
using funk.net.http.extensions.HttpStatusCodes;
using funk.net.http.extensions.UriRequests;
using funk.net.http.extensions.Uris;
using massive.munit.Assert;
using unit.Asserts;

class UriLoaderTest {

    private static inline var TIMEOUT : Int = 4000;

    private var _baseUri : String;

    @Before
    public function setup() {
        _baseUri = "http://localhost:1234/echo.n?";
    }

	@AsyncTest
	public function when_creating_loader__should_not_be_null(asyncFactory : AsyncFactory) {
        var actual = null;
        var expected = "Hello";

        var handler = asyncFactory.createHandler(this, function() {
            Assert.isNotNull(actual);
        }, TIMEOUT);

        Std.format("${_baseUri}message=${expected}").fromUri().get().then(function(data) {
            actual = data;
            handler();
        });
	}
}
