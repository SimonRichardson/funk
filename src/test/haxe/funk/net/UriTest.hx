package funk.net;

import funk.types.Option;
import massive.munit.Assert;
import unit.Asserts;

using funk.net.http.extensions.UriRequests;
using funk.net.http.extensions.Uris;
using massive.munit.Assert;
using unit.Asserts;

class UriTest {

	@Test
	public function should_calling_uri_return_same_string() : Void {
		var value = "http://www.google.com";
		value.fromUri().uri().areEqual(value);
	}

	@Test
	public function should_calling_url_return_base_url() : Void {
		var value = "http://www.google.com/going/to/somewhere/?q=something&v=0.1";
		value.fromUri().url().areEqual(Some("http://www.google.com/going/to/somewhere/"));
	}

	@Test
	public function should_calling_a_different_url_return_base_url() : Void {
		var value = "http://www.google.com/going/to/somewhere/else?q=something&v=0.1";
		value.fromUri().url().areEqual(Some("http://www.google.com/going/to/somewhere/else"));
	}

	@Test
	public function should_calling_a_empty_string_on_url_return_None() : Void {
		"".fromUri().url().areEqual(None);
	}

	@Test
	public function should_calling_a_empty_string_on_protocol_return_None() : Void {
		"".fromUri().protocol().areEqual(None);
	}

	@Test
	public function should_calling_a_http_on_protocol_return_http() : Void {
		"http://www.".fromUri().protocol().areEqual(Some("http"));
	}

	@Test
	public function should_calling_a_mailto_on_protocol_return_mailto() : Void {
		"mailto://www.".fromUri().protocol().areEqual(Some("mailto"));
	}

	@Test
	public function should_calling_a_ftp_on_protocol_return_ftp() : Void {
		"ftp://www.".fromUri().protocol().areEqual(Some("ftp"));
	}

	@Test
	public function should_calling_a_empty_string_on_host_return_None() : Void {
		"".fromUri().host().areEqual(None);
	}

	@Test
	public function should_calling_a_url_on_host_return_host() : Void {
		"http://www.google.com/stuff".fromUri().host().areEqual(Some("www.google.com"));
	}

	@Test
	public function should_calling_a_empty_string_on_port_return_None() : Void {
		"".fromUri().port().areEqual(None);
	}

	@Test
	public function should_calling_a_url_on_port_return_port() : Void {
		"http://www.google.com:8080/stuff".fromUri().port().areEqual(Some("8080"));
	}
}
