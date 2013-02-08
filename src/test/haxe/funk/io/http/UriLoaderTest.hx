package funk.io.http;

using funk.net.http.extensions.UriRequests;
using massive.munit.Assert;
using unit.Asserts;

class UriLoaderTest {

	@Test
	public function when_creating_loader__should_not_be_null() {
        "http://localhost:1234/server.n?some=message".fromUri().get();
	}
}
