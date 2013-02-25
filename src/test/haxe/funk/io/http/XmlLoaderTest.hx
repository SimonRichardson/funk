package funk.io.http;

import funk.collections.immutable.List;
import funk.io.http.JsonLoader;
import funk.net.http.HttpHeader;
import funk.net.http.HttpMethod;
import funk.net.http.HttpStatusCode;
import funk.net.http.UriRequest;
import funk.reactive.Stream;
import funk.types.Attempt;
import funk.types.Promise;
import funk.types.Option;
import haxe.Http;

import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;

using funk.collections.immutable.extensions.Lists;
using funk.net.http.extensions.HttpHeaders;
using funk.net.http.extensions.HttpStatusCodes;
using funk.net.http.extensions.UriRequests;
using funk.net.http.extensions.Uris;
using funk.types.extensions.Options;
using massive.munit.Assert;
using unit.Asserts;

class XmlLoaderTest extends BaseLoaderTest {

    @Before
    override public function setup() {
        baseType = "xml";

        super.setup();
    }

    @AsyncTest
    public function when_creating_loader__should_not_be_null(asyncFactory : AsyncFactory) {
        var actual = null;
        var expected = "Hello";

        var handler = asyncFactory.createHandler(this, function() {
            Assert.isNotNull(actual);
        }, TIMEOUT);

        '${baseUri}message=${expected}'.fromUri().get(Content(Application(Xml))).when(function(attempt) {
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

        '${baseUri}message=${expected}'.fromUri().get(Content(Application(Xml))).when(function(attempt) {
            switch(attempt){
                case Success(data): actual = data.code;
                default: Assert.fail("Failed if called");
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

        '${baseUri}message=${expected}'.fromUri().get(Content(Application(Xml))).when(function(attempt) {
            switch(attempt){
                case Success(data): 
                    var xml : Xml = data.body.get();
                    actual = xml.firstChild().firstChild().firstChild().toString();
                default: Assert.fail("Failed if called");
            }
            
            handler();
        });
    }
}
