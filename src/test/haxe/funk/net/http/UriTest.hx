package funk.net.http;

import funk.types.Option;
import massive.munit.Assert;
import unit.Asserts;

using funk.net.http.UriRequest;
using funk.net.http.Uri;
using funk.collections.immutable.Map;
using funk.collections.immutable.List;
using massive.munit.Assert;
using unit.Asserts;

class UriTest {

    @Test
    public function should_calling_uri_return_same_string() : Void {
        var value = "http://www.localhost.com";
        value.fromUri().uri().areEqual(value);
    }

    @Test
    public function should_calling_url_return_base_url() : Void {
        var value = "http://www.localhost.com/going/to/somewhere/?q=something&v=0.1";
        value.fromUri().url().areEqual(Some("http://www.localhost.com/going/to/somewhere/"));
    }

    @Test
    public function should_calling_a_different_url_return_base_url() : Void {
        var value = "http://www.localhost.com/going/to/somewhere/else?q=something&v=0.1";
        value.fromUri().url().areEqual(Some("http://www.localhost.com/going/to/somewhere/else"));
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
        "http://www.localhost.com/stuff".fromUri().host().areEqual(Some("www.localhost.com"));
    }

    @Test
    public function should_calling_a_empty_string_on_port_return_None() : Void {
        "".fromUri().port().areEqual(None);
    }

    @Test
    public function should_calling_a_url_on_port_return_port() : Void {
        "http://www.localhost.com:8080/stuff".fromUri().port().areEqual(Some("8080"));
    }

    @Test
    public function should_calling_a_url_on_port_return_None() : Void {
        "http://www.localhost.com:8080".fromUri().path().areEqual(None);
    }

    @Test
    public function should_calling_a_url_on_path_return_path() : Void {
        "http://www.localhost.com:8080/path".fromUri().path().areEqual(Some("/path"));
    }

    @Test
    public function should_calling_a_url_on_path_return_complex_path() : Void {
        "http://www.localhost.com:8080/path/to/something/here".fromUri().path().areEqual(Some("/path/to/something/here"));
    }

    @Test
    public function should_calling_a_url_on_path_return_complex_path_with_trailing_slash() : Void {
        "http://www.localhost.com:8080/path/to/something/here/".fromUri().path().areEqual(Some("/path/to/something/here/"));
    }

    @Test
    public function should_calling_a_url_on_path_return_complex_path_with_file() : Void {
        "http://www.localhost.com:8080/path/to/something/here/index.html".fromUri().path().areEqual(Some("/path/to/something/here/index.html"));
    }

    @Test
    public function should_calling_a_url_on_hash_return_None() : Void {
        "http://www.localhost.com:8080".fromUri().hash().areEqual(None);
    }

    @Test
    public function should_calling_a_url_on_hash_return_hash() : Void {
        "http://www.localhost.com:8080#hash".fromUri().hash().areEqual(Some("hash"));
    }

    @Test
    public function should_calling_a_url_on_hash_return_complex_hash() : Void {
        "http://www.localhost.com:8080/path/to/something/here/index.html#hash".fromUri().hash().areEqual(Some("hash"));
    }

    @Test
    public function should_calling_a_url_on_parameters_return_Empty() : Void {
        "http://www.localhost.com:8080#hash".fromUri().parameters().areEqual(Empty);
    }

    @Test
    public function should_calling_a_url_on_parameters_return_size_of_1() : Void {
        "http://www.localhost.com:8080?id=0#hash".fromUri().parameters().indices().size().areEqual(1);
    }

    @Test
    public function should_calling_a_url_on_parameters_return_size_of_4() : Void {
        "http://www.localhost.com:8080?id0=0&id1=1&id2=2&id3=3".fromUri().parameters().indices().size().areEqual(4);
    }

    @Test
    public function should_calling_a_url_on_parameters_return_size_of_4_with_hash() : Void {
        "http://www.localhost.com:8080?id0=0&id1=1&id2=2&id3=3#hash".fromUri().parameters().indices().size().areEqual(4);
    }

    @Test
    public function should_calling_a_url_on_parameters_return_toString() : Void {
        var str = "http://www.localhost.com:8080?id0=0&id1=1&id2=2&id3=3#hash".fromUri().parameters().toString();
        str.substr(0, 3).areEqual('Map');
        (str.indexOf('id3 => Some(3)') >= 0).isTrue();
        (str.indexOf('id2 => Some(2)') >= 0).isTrue();
        (str.indexOf('id1 => Some(1)') >= 0).isTrue();
        (str.indexOf('id0 => Some(0)') >= 0).isTrue();
    }

    @Test
    public function should_calling_a_url_on_parameters_with_missing_values_return_toString() : Void {
        var str = "http://www.localhost.com:8080?id0&id1&id2&id3=3#hash".fromUri().parameters().toString();
        str.substr(0, 3).areEqual('Map');
        (str.indexOf('id3 => Some(3)') >= 0).isTrue();
        (str.indexOf('id2 => None') >= 0).isTrue();
        (str.indexOf('id1 => None') >= 0).isTrue();
        (str.indexOf('id0 => None') >= 0).isTrue();
    }

    @Test
    public function should_calling_a_url_on_parameters_with_missing_values_but_with_equality_return_toString() : Void {
        var str = "http://www.localhost.com:8080?id0&id1=1&id2=&id3=3#hash".fromUri().parameters().toString();
        str.substr(0, 3).areEqual('Map');
        (str.indexOf('id3 => Some(3)') >= 0).isTrue();
        (str.indexOf('id2 => None') >= 0).isTrue();
        (str.indexOf('id1 => Some(1)') >= 0).isTrue();
        (str.indexOf('id0 => None') >= 0).isTrue();
    }
}
