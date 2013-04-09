package funk.io.http;

import funk.io.http.JsonLoader;
import funk.net.http.HttpMethod;
import funk.reactives.Stream;
import funk.types.Attempt;
import funk.futures.Promise;
import funk.types.Option;
import haxe.Http;

import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using funk.collections.immutable.List;
using funk.net.http.HttpHeader;
using funk.net.http.HttpStatusCode;
using funk.net.http.UriRequest;
using funk.net.http.Uri;
using funk.types.Option;
using massive.munit.Assert;
using unit.Asserts;

class UriLoaderTest extends BaseLoaderTest {

    @Before
    override public function setup() {
        baseType = "text";

        super.setup();
    }

    @AsyncTest
    public function when_creating_loader__should_not_be_null(asyncFactory : AsyncFactory) {
        var actual = null;
        var expected = "Hello";

        var handler = asyncFactory.createHandler(this, function() {
            Assert.isNotNull(actual);
        }, TIMEOUT);

        '${baseUri}message=${expected}'.fromUri().get().when(function(attempt) {
            switch(attempt){
                case Success(data): actual = data.body.get();
                default: Assert.fail("Failed if called");
            }

            handler();
        });
    }

    @AsyncTest
    public function when_creating_loader__should_be_valid_option(asyncFactory : AsyncFactory) {
        var actual = null;
        var expected = "Hello";

        var handler = asyncFactory.createHandler(this, function() {
            // This would run fine if we had a valid server
            Assert.areEqual(cast actual, cast None);//Some(HttpSuccess(OK)));
        }, TIMEOUT);

        '${baseUri}message=${expected}'.fromUri().get().when(function(attempt) {
            switch(attempt){
                case Success(data): actual = data.code;
                default: Assert.fail("Failed if called");
            }

            handler();
        });
    }
}
