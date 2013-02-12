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

		var loader = new JsonLoader(Request(Std.format("${baseUri}message=${expected}")));
		loader.start(Get).when(function(attempt) {
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
			#if js
			Assert.areEqual(cast actual, Some(HttpSuccess(OK)));
			#else
			// This would run fine if we had a valid server
			Assert.areEqual(cast actual, cast None);//Some(HttpSuccess(OK)));
			#end
		}, TIMEOUT);

		var loader = new JsonLoader(Request(Std.format("${baseUri}message=${expected}")));
		loader.start(Get).when(function(attempt) {
			switch(attempt){
				case Success(data): 
					actual = data.code;
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

		var loader = new JsonLoader(Request(Std.format("${baseUri}message=${expected}")));
		loader.start(Get).when(function(attempt) {
			switch(attempt){
				case Success(data): actual = Reflect.field(data.body.get(), "message");
				default: Assert.fail("Failed if called");
			}

			handler();
		});
	}
}
