package funk.io.http;

import funk.io.http.JsonLoader;
import funk.io.http.MimeType;
import funk.net.http.HttpMethod;
import funk.reactives.Stream;
import funk.types.Attempt;
import funk.futures.Promise;
import haxe.ds.Option;
import haxe.Http;

import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using funk.types.Option;
using funk.net.http.HttpHeader;
using funk.net.http.HttpStatusCode;
using funk.net.http.UriRequest;
using funk.net.http.Uri;
using funk.collections.immutable.List;
using massive.munit.Assert;
using unit.Asserts;

class JsonLoaderTest extends BaseLoaderTest {

    @Before
    override public function setup() {
        baseType = "json";

        super.setup();
    }

    @AsyncTest
    public function when_creating_loader__should_not_be_null(asyncFactory : AsyncFactory) {
        var actual = null;
        var expected = "Hello";

        var handler = asyncFactory.createHandler(this, function() {
            Assert.isNotNull(actual);
        }, TIMEOUT);

        '${baseUri}message=${expected}'.fromUri().get(Content(Application(Json))).when(function(attempt) {
            switch(attempt){
                case Success(data): actual = data.body.get();
                case _: Assert.fail("Failed if called");
            }

            handler();
        });
    }

    @AsyncTest
    public function when_creating_loader__should_be_valid_option(asyncFactory : AsyncFactory) {
        var actual = null;
        var expected = "Hello";

        var handler = asyncFactory.createHandler(this, function() {
            #if js
            Assert.areEqual(cast actual, Some(HttpSuccess(OK)));
            #else
            // This would run fine if we had a valid server
            Assert.areEqual(cast actual, cast None);//Some(HttpSuccess(OK)));
            #end
        }, TIMEOUT);

        '${baseUri}message=${expected}'.fromUri().get(Content(Application(Json))).when(function(attempt) {
            switch(attempt){
                case Success(data): actual = data.code;
                case _: Assert.fail("Failed if called");
            }

            handler();
        });
    }

    @AsyncTest
    public function when_creating_loader__should_response_be_correct_message(asyncFactory : AsyncFactory) {
        var actual = "";
        var expected = "Hello";

        var handler = asyncFactory.createHandler(this, function() {
            actual.areEqual(expected);
        }, TIMEOUT);

        '${baseUri}message=${expected}'.fromUri().get(Content(Application(Json))).when(function(attempt) {
            switch(attempt){
                case Success(data): actual = Reflect.field(data.body.get(), "message");
                case _: Assert.fail("Failed if called");
            }

            handler();
        });
    }
}
